local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Transparent background with a blurred (acrylic) backdrop.
-- Lower opacity => more desktop shows through. win32_system_backdrop
-- 'Acrylic' blurs whatever is behind the window (Windows 11) so text
-- stays readable over a busy desktop. Use 'Mica'/'Tabbed' for a subtler,
-- desktop-tinted effect, or 'Disable' for plain transparency with no blur.
config.window_background_opacity = 0.85
config.win32_system_backdrop = 'Acrylic'

-- Ctrl+B is herdr's prefix key; leave it alone here so herdr (running in
-- the pane) sees it instead of WezTerm swallowing it as its own leader.
config.keys = {
  -- Toggle fullscreen (press F11 again to exit)
  { key = 'F11', action = act.ToggleFullScreen },
}

return config
