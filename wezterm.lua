local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- Ctrl+B as leader key (like tmux)
config.leader = { key = 'b', mods = 'CTRL', timeout_milliseconds = 1000 }

-- Disable default Ctrl+B (PageUp) so it can work as leader
config.keys = {
  { key = 'b', mods = 'CTRL', action = act.DisableDefaultAssignment },

  -- Toggle fullscreen (press F11 again to exit)
  { key = 'F11', action = act.ToggleFullScreen },

  -- Split panes (like tmux)
  { key = '%', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '"', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Navigate panes with arrow keys (Ctrl+B + arrow)
  { key = 'LeftArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow',    mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },

  -- Tabs (like tmux windows)
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },

  -- Close pane (Ctrl+B + x)
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- Switch to tab by number (Ctrl+B + 0-9)
  { key = '0', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(8) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(9) },

  -- Resize panes (Ctrl+B + Ctrl+Arrow)
  { key = 'LeftArrow',  mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow',    mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow',  mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Down', 5 } },

  -- Zoom pane toggle (Ctrl+B + z)
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- Detach (close window, Ctrl+B + d)
  { key = 'd', mods = 'LEADER', action = act.QuitApplication },
}

return config
