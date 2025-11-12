# Go Debugging in Neovim

Neovim is configured with nvim-dap for Go debugging using Delve. The setup includes virtual text for variable inspection, custom breakpoint signs, and a comprehensive set of keybindings.

## Prerequisites

- `dlv` (Delve debugger) must be installed: `go install github.com/go-delve/delve/cmd/dlv@latest`

## Debug Configurations

The following debug configurations are available when starting a debug session (`<leader>bs`):

1. **Debug** - Debug the current file
2. **Debug (current package)** - Debug all files in the current package
3. **Debug test** - Debug tests in the current file
4. **Attach to process** - Attach to a running Go process (interactive selection)

## Keybindings Quick Reference

### Session Control
- `<leader>bs` - Start/Continue debugging
- `<leader>bc` - Continue (same as above)
- `<leader>bt` - Terminate debugging session

### Breakpoints
- `<leader>bb` - Toggle breakpoint at current line
- `<leader>bB` - Set conditional breakpoint (prompts for condition)
- `<leader>gb` - Toggle breakpoint (Go-specific, available in .go files)

### Stepping
- `<leader>bo` - Step over (next line)
- `<leader>bi` - Step into (enter function)
- `<leader>bu` - Step out (exit function)

### Variable Inspection
- `<leader>bh` - Hover to show variable value (works in normal and visual mode)
- `<leader>ba` - Evaluate expression under cursor or visual selection
- `<leader>be` - Evaluate custom expression (prompts for input)
- `<leader>bE` - Watch expression in hover window (prompts for input)
- `<leader>bw` - Show scopes/variables in floating window
- `<leader>bf` - Show stack frames in floating window

### UI and Output
- `<leader>bv` - Toggle DAP UI
- `<leader>bl` - Reset DAP UI layout
- `<leader>br` - Toggle REPL
- `<leader>bR` - Show REPL in floating window
- `<leader>bp` - Show console output in floating window
- `<leader>bT` - Run current file in terminal split (non-debug mode)

### Go-Specific Debug Commands (available in .go files)
- `<leader>gD` - Start debug session using go.nvim

## Visual Indicators

Breakpoint and execution state are shown with emoji signs in the gutter:
- 🔴 - Active breakpoint
- 🟡 - Conditional breakpoint
- ⭕ - Rejected/invalid breakpoint
- ▶️ - Current execution line (stopped)
- 📝 - Log point

## Features

- **Virtual text**: Variable values shown inline during debugging
- **No permanent UI**: Debug UI is shown on-demand via floating windows
- **REPL access**: Evaluate expressions and interact with the debugger via REPL
- **Console output**: View program output in a dedicated console window

## Configuration Files

- `nvim/lua/plugins/dap.lua` - DAP configuration and keybindings
- `nvim/lua/plugins/go.lua` - Go-specific integration and keybindings
