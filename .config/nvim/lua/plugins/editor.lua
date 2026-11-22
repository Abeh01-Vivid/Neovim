-- Editing power-tools: pairs, comments, surround, formatting, sessions, etc.

return {
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = true,
      check_ts = true,
      fast_wrap = { map = "<M-e>" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
      end
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    keys = { { "gcc", desc = "Toggle line comment" }, { "gc", mode = { "n", "v" }, desc = "Toggle comment" } },
    opts = {
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gc", block = "gb" },
      extra = { above = "gcO", below = "gco", eol = "gcA" },
    },
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    -- v4 sets up the default keymaps itself (ys, yss, yS, ySS, S, gS, ds, cs, cS),
    -- which is exactly what the old `keymaps` table listed.
    opts = {},
  },

  -- TODO / FIXME / NOTE highlights
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    dependencies = "nvim-lua/plenary.nvim",
    opts = {
      signs = true,
      keywords = {
        FIX = { icon = "󰅙 ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = "󰅢 ", color = "warning" },
        HACK = { icon = "󰅢 ", color = "info" },
        WARN = { icon = "󰀦 ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = "󰅒 ", color = "hint", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "󰅙 ", color = "info", alt = { "INFO" } },
        TEST = { icon = "󰅧 ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = { before = "", after = "", multipass = false },
    },
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find TODO comments" },
    },
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, char = "│", show_start = false, show_end = false },
      exclude = {
        filetypes = { "alpha", "notify", "qf", "NvimTree", "oil", "help", "trouble" },
      },
    },
  },

  -- Undo history
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
    init = function()
      vim.g.undotree_WindowLayout = 3
      vim.g.undotree_SplitWidth = 40
    end,
  },

  -- Multiple cursors
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_leader = "<leader>m"
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Select All"] = "<leader>ma",
      }
    end,
  },

  -- Formatting engine
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" },
    opts = {
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 800, lsp_format = "fallback" }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
        yaml = { "prettier" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        go = { "gofumpt", "gofmt" },
        rust = { "rustfmt" },
        sql = { "sqlfluff" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
      },
    },
    keys = {
      {
        "<leader>fm",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        desc = "Format buffer",
      },
      {
        "<leader>fa",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
        end,
        desc = "Toggle format on save",
      },
      {
        "<leader>fM",
        function()
          local first, last = vim.fn.line("v"), vim.fn.line(".")
          if first > last then
            first, last = last, first
          end
          require("conform").format({
            async = true,
            lsp_format = "fallback",
            range = { start = { first, 0 }, ["end"] = { last, #vim.fn.getline(last) } },
          })
        end,
        mode = "v",
        desc = "Format selection",
      },
    },
  },

  -- Install formatters / linters via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = "williamboman/mason.nvim",
    event = "VeryLazy",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "shfmt",
        "black",
        "isort",
        "gofumpt",
        "debugpy",
        "delve",
      },
      auto_update = false,
    },
  },

  -- Terminal
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = {
      size = 18,
      open_mapping = [[<C-\>]],
      shade_terminals = true,
      direction = "float",
      float_opts = { border = "rounded", width = function() return math.floor(vim.o.columns * 0.85) end },
      winbar = { enabled = false },
    },
    keys = {
      { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float terminal" },
      { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Horizontal terminal" },
      { "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Vertical terminal" },
      { "<leader>tg", "<cmd>LazyGit<cr>", desc = "LazyGit terminal" },
    },
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" },
    },
    keys = {
      {
        "<leader>qs",
        function() require("persistence").select() end,
        desc = "Select session",
      },
      {
        "<leader>ql",
        function() require("persistence").load({ last = true }) end,
        desc = "Load last session",
      },
      {
        "<leader>qd",
        function() require("persistence").stop() end,
        desc = "Stop auto-saving session",
      },
    },
  },

  -- Better folding (peek via treesitter is handled natively; this adds fold preview)
  {
    "anuvyklack/fold-preview.nvim",
    event = "VeryLazy",
    dependencies = "anuvyklack/keymap-amend.nvim",
    opts = {},
  },
}
