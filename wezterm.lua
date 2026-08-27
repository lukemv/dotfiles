local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- ===========================================================================
-- Fonts
-- ===========================================================================
-- WezTerm was silently using its *bundled* JetBrains Mono plus a bundled
-- "Symbols Nerd Font Mono" for icons -- confirmed with `wezterm ls-fonts`,
-- which reported every face as "<built-in>, BuiltIn". That build ships a
-- 2023-era JetBrains Mono, while all 96 faces of JetBrains Mono Nerd Font
-- v3 sit installed and unused. Two fonts also meant two sets of metrics:
-- text from one file, powerline and status glyphs from another.
--
-- "NFM" is the Nerd Font *Mono* packaging: every icon is squeezed to one
-- cell. The plain "NF" build draws icons 1.5 cells wide, which is what
-- shunts herdr's sidebar rows and starship's segments out of alignment.
-- "NL" faces are the no-ligature cut; see harfbuzz_features below instead.
config.font = wezterm.font_with_fallback {
  { family = 'JetBrainsMono NFM', weight = 'Regular' },
  -- Anything the Nerd Font lacks: CJK, then emoji, then the bundled
  -- symbol font as a last resort so a missing glyph is never a blank box.
  'Cascadia Mono',
  'Segoe UI Emoji',
  'Symbols Nerd Font Mono',
}
config.font_size = 12.0

-- Slightly open leading. Herdr's sidebar stacks three rows per agent and
-- starship adds a second prompt line, so vertical rhythm matters more here
-- than raw density.
config.line_height = 1.06
config.cell_width = 1.0

-- Explicit weight mapping. Without these, WezTerm synthesises styles from
-- the regular face; the family ships real ones.
--
-- The dim rule is the important one: herdr's redesigned sidebar leans on
-- dim for secondary rows (terminal title, workspace, branch), and dim as
-- plain alpha over an acrylic background turns to mush. Drawing it in the
-- Light face keeps the hierarchy legible as *weight*, not just opacity.
config.font_rules = {
  {
    intensity = 'Half',
    font = wezterm.font { family = 'JetBrainsMono NFM', weight = 'Light' },
  },
  {
    intensity = 'Half',
    italic = true,
    font = wezterm.font { family = 'JetBrainsMono NFM', weight = 'Light', italic = true },
  },
  {
    intensity = 'Bold',
    font = wezterm.font { family = 'JetBrainsMono NFM', weight = 'Bold' },
  },
  {
    intensity = 'Bold',
    italic = true,
    font = wezterm.font { family = 'JetBrainsMono NFM', weight = 'Bold', italic = true },
  },
  {
    italic = true,
    font = wezterm.font { family = 'JetBrainsMono NFM', weight = 'Regular', italic = true },
  },
}

-- Ligatures stay on: JetBrains Mono's are restrained, and -> => != read
-- better as single marks. To kill them, uncomment -- switching to the NL
-- faces is unnecessary and costs the fallback chain.
-- config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Rendering, tuned for the translucent window below.
-- Subpixel (LCD) antialiasing assumes an opaque background; over acrylic
-- it produces colour fringes on every glyph edge. Grayscale AA with a
-- lighter hinting target stays clean against a moving backdrop.
config.freetype_load_target = 'Light'
config.freetype_render_target = 'Normal'

-- Let WezTerm draw box-drawing and block characters itself rather than
-- taking them from the font. This is what makes herdr's heavy pane
-- borders meet at the corners with no seams or gaps at any font size.
config.custom_block_glyphs = true
config.warn_about_missing_glyphs = false

-- Transparent background with a blurred (acrylic) backdrop.
-- Lower opacity => more desktop shows through. win32_system_backdrop
-- 'Acrylic' blurs whatever is behind the window (Windows 11) so text
-- stays readable over a busy desktop. Use 'Mica'/'Tabbed' for a subtler,
-- desktop-tinted effect, or 'Disable' for plain transparency with no blur.
config.window_background_opacity = 0.85
config.win32_system_backdrop = 'Acrylic'

-- Windowed look: no title bar (RESIZE keeps a draggable/resizable border,
-- 'NONE' breaks resize + minimize on Windows), slim tab bar only when it's
-- actually useful.
config.window_decorations = 'RESIZE'
-- Never any tabs: herdr/tmux handles multiplexing, so the tab bar is pure
-- wasted rows. This is unconditional, not hide_tab_bar_if_only_one_tab.
config.enable_tab_bar = false
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.adjust_window_size_when_changing_font_size = false

-- True immersion in fullscreen: kill the tab bar and all padding so the
-- grid touches every edge of the display. window-resized fires on
-- enter/exit fullscreen, so we flip per-window overrides there.
wezterm.on('window-resized', function(window, _pane)
  local overrides = window:get_config_overrides() or {}
  local fullscreen = window:get_dimensions().is_full_screen

  if fullscreen then
    overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
    overrides.window_background_opacity = 1.0
  else
    overrides.window_padding = nil
    overrides.window_background_opacity = nil
  end

  window:set_config_overrides(overrides)
end)

-- Ctrl+B is herdr's prefix key; leave it alone here so herdr (running in
-- the pane) sees it instead of WezTerm swallowing it as its own leader.
config.keys = {
  -- Toggle fullscreen (press F11 again to exit)
  { key = 'F11', action = act.ToggleFullScreen },
}

return config
