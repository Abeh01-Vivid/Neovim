-- Debug Adapter Protocol support

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: continue" },
      { "<F6>", function() require("dap").pause() end, desc = "Debug: pause" },
      { "<F8>", function() require("dap").step_over() end, desc = "Debug: step over" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      { "<F10>", function() require("dap").step_into() end, desc = "Debug: step into" },
      { "<F11>", function() require("dap").step_out() end, desc = "Debug: step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Debug: conditional breakpoint",
      },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: toggle REPL" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Debug: run last" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: terminate" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
    },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Gutter signs
      vim.fn.sign_define("DapBreakpoint", { text = "󰅧 ", texthl = "DiagnosticError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "󰅧 ", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "󰅢 ", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "󰁔 ", texthl = "DiagnosticOk", linehl = "Visual", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "󰅙 ", texthl = "DiagnosticError", linehl = "", numhl = "" })

      -- Debug UI
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "󰁔 " },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.30 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = { { id = "repl", size = 0.6 }, { id = "console", size = 0.4 } },
            size = 10,
            position = "bottom",
          },
        },
        floating = { border = "rounded", max_height = 0.6, max_width = 0.6 },
        controls = { enabled = true, element = "repl", icons = { pause = "󰅒 ", play = "󰁔 " } },
        render = { max_type_length = 30 },
      })

      -- Inline variable values
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        commented = true,
        show_stop_reason = true,
        virt_text_pos = "eol",
      })

      -- Auto open / close the UI
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Python (debugpy installed through Mason)
      local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      if vim.fn.executable(debugpy_python) == 1 then
        require("dap-python").setup(debugpy_python)
      else
        require("dap-python").setup("python")
      end

      -- Go (delve from Mason, or any `dlv` on PATH)
      local dlv = vim.fn.stdpath("data") .. "/mason/bin/dlv"
      if vim.fn.executable(dlv) ~= 1 then
        dlv = "dlv"
      end
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = { command = dlv, args = { "dap", "-l", "127.0.0.1:${port}" } },
      }
      dap.configurations.go = {
        { type = "delve", name = "Debug file", request = "launch", program = "${file}" },
        { type = "delve", name = "Debug package", request = "launch", program = "${fileDirname}" },
        { type = "delve", name = "Debug test", request = "launch", mode = "test", program = "./${relativeFileDirname}" },
      }
    end,
  },
}
