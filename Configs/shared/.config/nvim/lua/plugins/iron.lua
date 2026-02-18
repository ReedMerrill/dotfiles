return {
	"Vigemus/iron.nvim",
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")
		-- Iron core configuration
		iron.setup({
			config = {
				-- If iron should expose `<plug>(...)` mappings for the plugins
				should_map_plug = false,
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- How the repl window will be displayed
				repl_open_cmd = view.split.vertical.botright(90),
				-- Your repl definitions come here
				repl_definition = {
					quarto = {
						command = { "radian" },
						format = require("iron.fts.common").bracketed_paste,
					},
					r = {
						command = { "radian" },
						format = require("iron.fts.common").bracketed_paste,
					},
				},
			},
			-- Keymaps for iron functions
			keymaps = {
				send_motion = "<space>sc",
				visual_send = "<space>sl",
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_until_cursor = "<space>su",
				send_mark = "<space>sm",
				mark_motion = "<space>mc",
				mark_visual = "<space>mc",
				remove_mark = "<space>md",
				cr = "<space>s<cr>",
				interrupt = "<space>s<space>",
				exit = "<space>rq",
				clear = "<space>cl",
			},
			highlight = {
				italic = false,
			},
		})
	end,
}
