local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("BlexMono Nerd Font", { weight = 490 })
config.font_size = 13
config.line_height = 1.3
config.color_scheme = "Alabaster"

config.window_frame = {
  font = wezterm.font("BlexMono Nerd Font", { weight = "Bold"}),
  font_size = 13,
}

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  {
    key = 'Enter',
    mods = 'LEADER',
    action = wezterm.action.ActivateCopyMode
  },
  {
    key = 'Tab',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator
  },
  {
    key = 'Space',
    mods = 'LEADER',
    action = wezterm.action.ShowLauncher
  }
}

config.window_close_confirmation = 'NeverPrompt'

return config
