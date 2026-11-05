-- Last session (herdr-last's prefix+b): jump back to the previously active session.
--
-- Rex doesn't tell init.lua which session the app is showing, but every key
-- handler and action gets the session it ran in (ctx.session_id). So we note the
-- session on each key that can leave it (pane navigation, the session bindings
-- below) and read the "previous" one back when prefix+b is pressed. State lives
-- in a file so it survives config reloads and server restarts.
local state_path = (os.getenv("HOME") or "") .. "/.local/state/rex-last-session"

local function load_sessions()
	local f = io.open(state_path, "r")
	if not f then
		return nil, nil
	end
	local current, previous = f:read("*l"), f:read("*l")
	f:close()
	return current ~= "" and current or nil, previous ~= "" and previous or nil
end

local function save_sessions(current, previous)
	local f = io.open(state_path, "w")
	if f then
		f:write(current or "", "\n", previous or "", "\n")
		f:close()
	end
end

-- Record the session a key was pressed in; the one we were in before becomes "previous".
local function track(ctx)
	local id = ctx and ctx.session_id
	if not id then
		return
	end
	local current, previous = load_sessions()
	if id ~= current then
		save_sessions(id, current or previous)
	end
end

local function session_exists(id)
	for _, session in ipairs(rex.call("session.list").sessions or {}) do
		if session.session_id == id then
			return true
		end
	end
	return false
end

-- Key handlers can't queue client actions, so everything that switches
-- sessions is a rex.action that notes the session first and then performs the
-- app's own action.
local function session_action(name, title, client_action)
	rex.action({
		name = name,
		title = title,
		run = function(ctx)
			track(ctx)
			rex.client.queue(client_action)
		end,
	})
end

session_action("session_switch", "Change Session…", "session.switch")
session_action("session_new", "New Session", "session.new")
session_action("session_previous", "Previous Session", "session.previous")

rex.action({
	name = "session_last",
	title = "Last Session",
	run = function(ctx)
		track(ctx)
		local current, previous = load_sessions()
		if not previous or not session_exists(previous) then
			return
		end
		save_sessions(previous, current)
		rex.client.queue("session.select", { session_id = previous })
	end,
})

-- Open-or-focus a named session (herdr-open-notes / herdr-open-files): switch to
-- the session with this label if one exists, otherwise create it in `dir` and
-- type `startup` into its shell, so the shell stays open after the program quits.
local function open_or_focus(name, title, label, dir, startup)
	rex.action({
		name = name,
		title = title,
		run = function(ctx)
			track(ctx)
			local id
			for _, session in ipairs(rex.call("session.list").sessions or {}) do
				if session.label == label then
					id = session.session_id
					break
				end
			end
			if not id then
				local created = rex.call("session.create", {
					label = label,
					initial_windows = {
						{
							layout = {
								block = {
									flavor = "com.superlogical.terminal.shell",
									options = { cwd = dir },
								},
							},
						},
					},
				})
				id = created.session_id
				local block_id = created.initial_windows[1].block_ids[1]
				rex.block.call("com.superlogical.terminal", "write", {
					block_id = block_id,
					data = startup .. "\n",
				})
			end
			rex.client.queue("session.select", { session_id = id })
		end,
	})
end

local home = os.getenv("HOME") or ""

open_or_focus(
	"open_notes",
	"Open Notes Session",
	"notes",
	home .. "/Can. Mun. Barometer Dropbox/Reed Merrill/3-resources/obsidian/CMB",
	"nvim tasks/next.todo.md"
)
open_or_focus("open_files", "Open Files Session", "files", home, "yazi")

local terminal = "com.superlogical.terminal"

-- the focused pane's foreground process, with its name, pid and cwd
local function foreground(ctx)
	local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
	return proc and proc.foreground
end

-- the focused pane's directory, from what the shell last reported or else its foreground process
local function focused_cwd(ctx)
	local pwd = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
	if pwd and pwd.pwd then
		return (pwd.pwd:gsub("^file://[^/]*", ""))
	end
	local fg = foreground(ctx)
	return fg and fg.cwd
end

-- a terminal pane layout running command, or a shell if command is nil, in cwd
local function shell(command, cwd)
	return rex.layout.block({ flavor = terminal .. ".shell", options = { command = command, cwd = cwd } })
end

-- a palette action that opens a floating pane in the focused pane's directory,
-- running command or a shell bounds is x, y, w, h as fractions of the window,
-- nearly full-window by default
local function float(spec)
	rex.action({
		name = spec.name,
		title = spec.title,
		keywords = spec.keywords,
		run = function(ctx)
			local _, err = rex.session.new_layer({
				bounds = spec.bounds or { 0.05, 0.05, 0.9, 0.9 },
				layout = shell(spec.command, focused_cwd(ctx)),
				focus = true,
			})
			if err then
				error(err)
			end
		end,
	})
end
-- the scripts next to this file, and the float sizes they use
local scripts = os.getenv("HOME") .. "/.config/rex/"
local picker = { 0.25, 0.2, 0.5, 0.5 }
local prompt = { 0.3, 0.4, 0.4, 0.2 }

float({
	name = "scratch_float",
	title = "Scratch Terminal",
	keywords = "scratch terminal float",
})

float({
	name = "lazygit_float",
	title = "Lazygit",
	keywords = "git lazygit float",
	command = { "lazygit" },
})

float({
	name = "yazi_float",
	title = "yazi",
	keywords = "yazi files",
	command = { "yazi" },
})

rex.bind("cmd+g", "lazygit_float")
rex.bind("cmd+shift+t", "scratch_float")
rex.bind("cmd+;", "yazi_float")
rex.bind("cmd+p", "client.palette.toggle")
rex.bind("ctrl+space>j", "open_notes")
rex.bind("ctrl+space>k", "open_files")
rex.bind("ctrl+space>,", "client.settings")
rex.bind("ctrl+space>shift+r", "client.config.reload")
rex.bind("ctrl+s", "session_switch")
rex.bind("cmd+s", "session_switch")
rex.bind("ctrl+space>b", "session_last")
rex.bind("ctrl+space>shift+n", "session_new")
rex.bind("ctrl+space>d", "session.close")
rex.bind("ctrl+space>ctrl+b", "session_previous")
rex.bind("ctrl+space>shift+t", "client.tab.rename")
rex.bind("ctrl+space>ctrl+tab", "client.tab.previous")
rex.bind("ctrl+space>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+space>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+space>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+space>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+space>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+space>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+space>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+space>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+space>9", "client.tab.goto", { index = 9 })
rex.bind("cmd+w", "client.tab.close")
rex.bind("ctrl+space>v", "pane.split", { direction = "right" })
rex.bind("ctrl+space>h", "pane.split", { direction = "down" })
rex.bind("cmd+x", "pane.close")
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>r", "client.mode.enter", { name = "resize" })
rex.mode("resize", { exclusive = true })
rex.bind("resize/escape", "client.mode.exit")
rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })

-- Seamless ctrl+h/j/k/l navigation between Nvim windows and Rex panes.
-- When Nvim is the foreground program, the key falls through to it (see
-- lua/rex_nav.lua in the nvim config, which hands focus back to Rex at its
-- edge). Otherwise Rex moves focus to the neighbouring pane itself.
local nav_directions = { h = "left", j = "down", k = "up", l = "right" }

local function basename(path)
	return (path or ""):match("([^/]*)$")
end

local function is_nvim(proc)
	local fg = proc and proc.foreground
	return fg ~= nil and (basename(fg.argv0) == "nvim" or basename(fg.name) == "nvim")
end

-- set the nvim navigation keybindings to be ctrl+h/j/k/l, and if the focused
-- terminal is not nvim, then move focus to the neighbouring pane in the
-- specified direction.
for key, direction in pairs(nav_directions) do
	rex.bind("ctrl+" .. key, function(ctx)
		track(ctx)
		local proc = rex.block.call("com.superlogical.terminal", "process", { block_id = ctx.block_id })
		if is_nvim(proc) then
			-- Not handled: the key is sent on to the focused terminal (Nvim).
			return false
		end
		rex.call("session.focus_direction", {
			session_id = ctx.session_id,
			direction = direction,
			wrap = false,
		})
		return true
	end)
end
