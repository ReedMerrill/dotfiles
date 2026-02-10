-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = wezterm.config_builder()
config.automatically_reload_config = true
config.set_environment_variables = { COLORTERM = "truecolor" }

config.color_scheme = "Gruvbox Material (Gogh)"
config.colors = { background = "#1d2021" }
config.enable_tab_bar = false
config.font = wezterm.font("0xProto Nerd Font Mono", { weight = "Regular" })
config.font_size = 13.5
config.keys = {
	-- disable keys that conflict with neovim and tmux
	-- disable <C-T>, which create a new wezterm tab
	{
		key = "T",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "T",
		mods = "CMD",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "N",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "P",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "A",
		mods = "ALT",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
