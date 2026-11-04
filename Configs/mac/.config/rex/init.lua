-- cmd+k clears the terminal; the session picker moves to cmd+s
rex.bind("cmd+k", "com.superlogical.terminal.clear")
rex.bind("cmd+s", "session.switch")

-- tmux
rex.bind("ctrl+space>ctrl+space", "pane.send_key", { key = "ctrl+space" })
rex.bind("ctrl+space>j", "client.tab.previous")
rex.bind("ctrl+space>k", "client.tab.next")

-- Herdr
rex.mode("resize", { exclusive = true })
rex.bind("resize/enter", "client.mode.exit")
rex.bind("resize/escape", "client.mode.exit")

rex.bind("ctrl+space>,", "client.settings")
rex.bind("ctrl+space>shift+r", "client.config.reload")
rex.bind("ctrl+space>w", "session.switch")
rex.bind("ctrl+space>shift+n", "session.new")
rex.bind("ctrl+space>d", "session.close")
rex.bind("ctrl+space>ctrl+b", "session.previous")
rex.bind("ctrl+space>n", "client.tab.new")
rex.bind("ctrl+space>shift+t", "client.tab.rename")
rex.bind("ctrl+space>ctrl+tab", "client.tab.previous")
rex.bind("ctrl+space>tab", "client.tab.next")
rex.bind("ctrl+space>1", "client.tab.goto", { index = 1 })
rex.bind("ctrl+space>2", "client.tab.goto", { index = 2 })
rex.bind("ctrl+space>3", "client.tab.goto", { index = 3 })
rex.bind("ctrl+space>4", "client.tab.goto", { index = 4 })
rex.bind("ctrl+space>5", "client.tab.goto", { index = 5 })
rex.bind("ctrl+space>6", "client.tab.goto", { index = 6 })
rex.bind("ctrl+space>7", "client.tab.goto", { index = 7 })
rex.bind("ctrl+space>8", "client.tab.goto", { index = 8 })
rex.bind("ctrl+space>9", "client.tab.goto", { index = 9 })
rex.bind("ctrl+space>shift+x", "client.tab.close")
rex.bind("ctrl+space>v", "pane.split", { direction = "right" })
rex.bind("ctrl+space>h", "pane.split", { direction = "down" })
rex.bind("ctrl+space>x", "pane.close")
rex.bind("ctrl+space>z", "pane.zoom")
rex.bind("ctrl+space>r", "client.mode.enter", { name = "resize" })
rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/down", "pane.resize", { direction = "down" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
rex.bind("ctrl+space>a", "client.sidebar.toggle")

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

for key, direction in pairs(nav_directions) do
	rex.bind("ctrl+" .. key, function(ctx)
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
