local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font({
	family = "FiraCode Nerd Font",
	harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
})

config.font_size = 13
config.color_scheme = "Alabaster"

return config

