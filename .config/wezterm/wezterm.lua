local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Blue Scheme"

config.color_schemes = {
  ["Blue Scheme"] = {
    background = "#0d1117",
  },
}

config.initial_rows = 200
config.initial_cols = 300

local font_size = 16

config.window_frame = {
  font_size = font_size,
  inactive_titlebar_bg = 'rgba(5% 6% 9% 80%)',
}

config.use_fancy_tab_bar = false
config.colors = {
  tab_bar = {
    background = 'rgba(5% 6% 9% 80%)',
    inactive_tab = {
      bg_color = 'rgba(5% 6% 9% 80%)',
      fg_color = 'rgba(5% 6% 9% 90%)',
    },
  },
}

config.window_decorations = "RESIZE"
config.window_background_opacity = 0.94
config.macos_window_background_blur = 50

config.font_size = font_size

config.keys = {
  {
    key = "V",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "S",
    mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "Tab",
    mods = "CTRL",
    action = wezterm.action.ActivateTabRelative(1),
  },
  {
    key = "h",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "CTRL|SHIFT",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "w",
    mods = "CTRL|SHIFT",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
}

return config
