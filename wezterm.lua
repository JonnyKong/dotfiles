-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

config.color_scheme = 'Vs Code Dark+ (Gogh)'
config.font = wezterm.font 'JetBrains Mono'
config.font_size = 14.0
config.line_height = 1.17
config.cell_width = 0.9
config.window_padding = {
  left = 4,
  right = 4,
  top = 0,
  bottom = 0,
}
config.window_close_confirmation = 'NeverPrompt'

-- and finally, return the configuration to wezterm
return config
