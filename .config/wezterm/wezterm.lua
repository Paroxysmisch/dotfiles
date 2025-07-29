local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Spawn a fish shell in login mode
config.default_prog = { "fish", "-l" }

config.tab_max_width = 128

config.color_scheme = "Blue Scheme"

config.color_schemes = {
	["Blue Scheme"] = {
		background = "#0d1117",
	},
}

config.initial_rows = 200
config.initial_cols = 300

local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil
local font_size = 16
if is_darwin then
	font_size = 16
elseif is_linux then
	font_size = 12
end

if is_darwin then
	config.window_frame = {
		font_size = font_size,
		inactive_titlebar_bg = "rgba(5% 6% 9% 80%)",
	}
	config.window_decorations = "RESIZE"
end

if is_linux then
	config.window_decorations = "NONE"
end

config.use_fancy_tab_bar = false
config.colors = {
	tab_bar = {
		background = "rgba(5% 6% 9% 80%)",
		inactive_tab = {
			bg_color = "rgba(5% 6% 9% 80%)",
			fg_color = "rgba(40% 40% 40% 90%)",
		},
	},
}

config.window_background_opacity = 0.94
config.macos_window_background_blur = 50

config.font_size = font_size

config.keys = {
	{
		key = "Tab",
		mods = "CTRL",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "w",
		mods = "CTRL|SHIFT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{ key = "{", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "}", mods = "CTRL|SHIFT", action = wezterm.action.MoveTabRelative(1) },
}

return config
