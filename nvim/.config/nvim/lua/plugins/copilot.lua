return {
	"github/copilot.vim",
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			mappings = {
				close = "q",
				reset = "<C-L>",
				complete = "<Tab>",
				submit_prompt = "<CR>",
				accept_diff = "<C-y>",
				show_diff = "<C-d>",
			},
		},
	},
}
