-- Seamless <C-h/j/k/l> navigation between Nvim windows and Rex panes.
--
-- Pairs with the ctrl+h/j/k/l bindings in ~/.config/rex/init.lua. Rex passes
-- those keys through to Nvim whenever Nvim is the foreground program in the
-- focused pane. Here we move between Nvim windows, and once we are already at
-- the edge of Nvim's layout we hand focus to the neighbouring Rex pane.
--
-- Outside Rex ($REX_SESSION unset) this is plain `wincmd` navigation.

local directions = { h = "left", j = "down", k = "up", l = "right" }

local function navigate(key)
	local win = vim.api.nvim_get_current_win()
	vim.cmd("wincmd " .. key)

	-- Moved to another Nvim window, or we are not inside Rex: nothing more to do.
	local session = vim.env.REX_SESSION
	if vim.api.nvim_get_current_win() ~= win or not session or session == "" then
		return
	end

	-- Still in the same window, so we were at the edge: ask Rex to move focus.
	-- Asynchronous so Nvim never blocks on the CLI; wrap = false so focus does
	-- not jump to the opposite side when there is no pane in that direction.
	vim.system({
		"rex",
		"api",
		"call",
		"-s",
		session,
		"session.focus_direction",
		vim.json.encode({ direction = directions[key], wrap = false }),
	})
end

for key in pairs(directions) do
	vim.keymap.set("n", "<C-" .. key .. ">", function()
		navigate(key)
	end, { desc = "Navigate to the " .. directions[key] .. " Nvim window or Rex pane" })
end
