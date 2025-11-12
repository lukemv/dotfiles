return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Setup dapui - no permanent windows, use floats on demand
      dapui.setup({
        layouts = {},  -- No automatic layout
      })

      -- Setup virtual text
      require("nvim-dap-virtual-text").setup()

      -- Configure breakpoint signs to be more obvious
      vim.fn.sign_define("DapBreakpoint", {
        text = "🔴",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "DapBreakpoint"
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "🟡",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "DapBreakpoint"
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "⭕",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "DapBreakpoint"
      })
      vim.fn.sign_define("DapStopped", {
        text = "▶️",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "DapStopped"
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "📝",
        texthl = "DapLogPoint",
        linehl = "",
        numhl = "DapLogPoint"
      })

      -- Go configuration
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug (current package)",
          request = "launch",
          program = "${fileDirname}",
        },
        {
          type = "delve",
          name = "Debug test",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Attach to process",
          request = "attach",
          mode = "local",
          processId = require('dap.utils').pick_process,
        },
      }

      -- Don't auto open/close dapui - use on demand only

      -- Ergonomic keymaps for debugging (using <leader>b prefix)
      vim.keymap.set("n", "<leader>bc", dap.continue, { desc = "Debug: Continue" })
      vim.keymap.set("n", "<leader>bs", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>bB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>bo", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<leader>bi", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<leader>bu", dap.step_out, { desc = "Debug: Step Out (up)" })
      vim.keymap.set("n", "<leader>bt", dap.terminate, { desc = "Debug: Terminate" })
      vim.keymap.set("n", "<leader>br", dap.repl.toggle, { desc = "Debug: Toggle REPL" })

      -- Variable inspection and modification
      vim.keymap.set("n", "<leader>bh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Debug: Hover variable" })
      vim.keymap.set("v", "<leader>bh", function()
        require("dap.ui.widgets").hover()
      end, { desc = "Debug: Hover expression" })
      vim.keymap.set("n", "<leader>be", function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then
            dap.repl.execute(expr)
          end
        end)
      end, { desc = "Debug: Evaluate expression" })
      vim.keymap.set("n", "<leader>bw", function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes)
      end, { desc = "Debug: Show scopes/variables" })
      vim.keymap.set("n", "<leader>bf", function()
        require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames)
      end, { desc = "Debug: Show frames/stack" })
      vim.keymap.set("n", "<leader>bv", function()
        dapui.toggle()
      end, { desc = "Debug: Toggle UI" })
      vim.keymap.set("n", "<leader>bl", function()
        dapui.open({ reset = true })
      end, { desc = "Debug: Reset UI layout" })
      vim.keymap.set({"n", "v"}, "<leader>ba", function()
        dapui.eval()
      end, { desc = "Debug: Evaluate under cursor/selection" })
      vim.keymap.set("n", "<leader>bE", function()
        vim.ui.input({ prompt = "Watch expression: " }, function(expr)
          if expr then
            require("dap.ui.widgets").hover(expr)
          end
        end)
      end, { desc = "Debug: Watch expression" })
      vim.keymap.set("n", "<leader>bp", function()
        dapui.float_element("console", { enter = true })
      end, { desc = "Debug: Show console (output)" })
      vim.keymap.set("n", "<leader>bR", function()
        dapui.float_element("repl", { enter = true })
      end, { desc = "Debug: Show REPL" })

      -- Run program in terminal split to see output
      vim.keymap.set("n", "<leader>bT", function()
        vim.cmd("split | terminal go run " .. vim.fn.expand("%"))
        vim.cmd("resize 15")
      end, { desc = "Debug: Run in terminal split" })
    end,
  },
}
