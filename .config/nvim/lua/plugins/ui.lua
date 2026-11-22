-- UI: statusline, tabline, dashboard, file explorer, notifications, etc.

local icons = {
  git = "󰊢",
  error = " ",
  warn = " ",
  info = " ",
  hint = " ",
}

return {
  -- Devicons (shared by many plugins)
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = {
      color = true,
      override = {},
      default = true,
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
    opts = function()
      local function navic_location()
        local ok, navic = pcall(require, "nvim-navic")
        if ok and navic.is_available() then
          return navic.get_location()
        end
        return ""
      end

      return {
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "alpha" }, winbar = { "alpha", "NvimTree", "oil" } },
          always_divide_middle = true,
          refresh = { statusline = 200, tabline = 500, winbar = 500 },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            { "branch", icon = icons.git },
            "diff",
            {
              "diagnostics",
              symbols = {
                error = icons.error,
                warn = icons.warn,
                info = icons.info,
                hint = icons.hint,
              },
            },
          },
          lualine_c = {
            { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
            { "filename", path = 1, symbols = { modified = "●", readonly = "◼", unnamed = "[No Name]" } },
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        winbar = {
          lualine_c = {
            { "filename", path = 1, symbols = { modified = "●", readonly = "◼", unnamed = "[No Name]" } },
            { navic_location, cond = function()
              local ok, navic = pcall(require, "nvim-navic")
              return ok and navic.is_available()
            end },
          },
        },
        inactive_winbar = {
          lualine_c = {
            { "filename", path = 1, symbols = { modified = "●", readonly = "◼", unnamed = "[No Name]" } },
          },
        },
        extensions = { "nvim-tree", "toggleterm", "trouble" },
      }
    end,
  },

  -- Buffer tabs
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        close_command = "bdelete %d",
        right_mouse_command = "bdelete %d",
        middle_mouse_command = "bdelete %d",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local s = ""
          if diag.error then s = s .. icons.error .. diag.error .. " " end
          if diag.warning then s = s .. icons.warn .. diag.warning end
          return s
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "  󰙅  EXPLORER",
            highlight = "Directory",
            separator = true,
            text_align = "left",
          },
          {
            filetype = "oil",
            text = "  󰙅  EXPLORER",
            highlight = "Directory",
            separator = true,
            text_align = "left",
          },
        },
        separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        color_icons = true,
        always_show_bufferline = true,
        sort_by = "insert_after_current",
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Toggle pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to right" },
      { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Close buffers to left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
    },
  },

  -- File explorer (tree)
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      sort = { sorter = "case_sensitive" },
      view = {
        width = 32,
        relativenumber = true,
        signcolumn = "no",
      },
      renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "󰈙",
            symlink = "󰟦",
            folder = {
              default = "󰉋",
              open = "󰉋",
              empty = "󰉋",
              empty_open = "󰉋",
              symlink = "󰟦",
              symlink_open = "󰟦",
            },
            git = {
              unstaged = "󰄱",
              staged = "󰱒",
              unmerged = "󰙅",
              renamed = "󰁕",
              untracked = "󰈄",
              deleted = "󰺔",
              ignored = "󰰱",
            },
          },
        },
      },
      filters = { dotfiles = false },
      git = { enable = true, ignore = false },
      update_focused_file = { enable = true },
      actions = {
        open_file = { quit_on_open = false, resize_window = false },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        local map = vim.keymap.set
        api.config.mappings.default_on_attach(bufnr)
        pcall(vim.keymap.del, "n", "<C-k>", { buffer = bufnr })
        local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }
        map("n", "<CR>", api.node.open.edit, vim.tbl_extend("force", opts, { desc = "Open file" }))
        map("n", "o", api.node.open.edit, vim.tbl_extend("force", opts, { desc = "Open file" }))
        map("n", "<C-v>", api.node.open.vertical, vim.tbl_extend("force", opts, { desc = "Open in vsplit" }))
        map("n", "<C-x>", api.node.open.horizontal, vim.tbl_extend("force", opts, { desc = "Open in split" }))
        map("n", "a", api.fs.create, vim.tbl_extend("force", opts, { desc = "Create file/dir" }))
        map("n", "d", api.fs.remove, vim.tbl_extend("force", opts, { desc = "Delete file/dir" }))
        map("n", "r", api.fs.rename, vim.tbl_extend("force", opts, { desc = "Rename file/dir" }))
        map("n", "c", api.fs.copy.node, vim.tbl_extend("force", opts, { desc = "Copy file/dir" }))
        map("n", "x", api.fs.cut, vim.tbl_extend("force", opts, { desc = "Cut file/dir" }))
        map("n", "p", api.fs.paste, vim.tbl_extend("force", opts, { desc = "Paste file/dir" }))
        map("n", "y", api.fs.copy.filename, vim.tbl_extend("force", opts, { desc = "Copy filename" }))
        map("n", "R", api.tree.reload, vim.tbl_extend("force", opts, { desc = "Reload tree" }))
        map("n", "?", api.tree.toggle_help, vim.tbl_extend("force", opts, { desc = "Toggle help" }))
      end,
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Find current file in tree" },
    },
  },

  -- File explorer (vim-like buffer editor)
  {
    "stevearc/oil.nvim",
    lazy = false, -- needed so `nvim .` opens a directory
    opts = {
      default_file_explorer = true,
      default_alternate_effect = "right",
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          return name == ".." or name == ".git"
        end,
      },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["g."] = "actions.toggle_hidden",
      },
      float = { padding = 4, max_height = 40 },
    },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    },
  },

  -- Dashboard / start screen
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                   ",
        "   ██╗   ██╗██╗██╗   ██╗██╗██████╗ ",
        "   ██║   ██║██║██║   ██║██║██╔══██╗",
        "   ██║   ██║██║██║   ██║██║██║  ██║",
        "   ╚██╗ ██╔╝██║╚██╗ ██╔╝██║██║  ██║",
        "    ╚████╔╝ ██║ ╚████╔╝ ██║██████╔╝",
        "     ╚═══╝  ╚═╝  ╚═══╝  ╚═╝╚═════╝ ",
        "                                   ",
        "            󰅣  C a t p u c c i n   L a t t e  󰅣",
      }
      dashboard.section.header.opts.hl = "Title"
      dashboard.section.buttons.val = {
        dashboard.button("f", "󰈞  Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", "󰤽  New file", "<cmd>ene<bar>startinsert<cr>"),
        dashboard.button("r", "󰄉  Recent files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("g", "󰊢  Search text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("s", "󰆄  Restore session", "<cmd>lua require('persistence').load()<cr>"),
        dashboard.button("p", "󰏖  Manage plugins", "<cmd>Lazy<cr>"),
        dashboard.button("q", "󰈆  Quit Neovim", "<cmd>qa<cr>"),
      }
      dashboard.section.buttons.opts.hl = "String"
      dashboard.section.footer.val = "  󰄮  Ready to code"
      dashboard.section.footer.opts.hl = "Comment"
      dashboard.opts.opts.noautocmd = true

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        once = true,
        callback = function()
          local stats = require("lazy").stats()
          dashboard.section.footer.val =
            string.format("  󰄮  %d/%d plugins loaded in %.0f ms", stats.loaded, stats.count, stats.startuptime)
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      return dashboard.config
    end,
  },

  -- Notifications
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = {
      stages = "fade",
      timeout = 3000,
      max_height = function() return math.floor(vim.o.lines * 0.75) end,
      max_width = function() return math.floor(vim.o.columns * 0.5) end,
      background_colour = "#eff1f5", -- Catppuccin Latte base
      render = "default",
      top_down = false,
    },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  -- Clean message / cmdline / popup UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
      messages = {
        enabled = true,
        view_error = "notify",
        view_warn = "notify",
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = { { find = "written" }, { find = "%d+ lines less" }, { find = "E486" } },
          },
          opts = { skip = true },
        },
      },
      lsp = {
        progress = { enabled = true },
        signature = { enabled = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },

  -- Keymap discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      delay = function(ctx) return ctx.plugin and 0 or 250 end,
      spec = {
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code / LSP" },
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find / File" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunks" },
        { "<leader>q", group = "Quit / Session" },
        { "<leader>s", group = "Search / Session" },
        { "<leader>t", group = "Terminal / Test" },
        { "<leader>w", group = "Workspace" },
        { "<leader>x", group = "Diagnostics / Trouble" },
        { "<leader>z", group = "Zen / Focus" },
      },
      win = { border = "rounded", padding = { 1, 2 } },
    },
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = true }) end,
        desc = "Show all keymaps",
      },
    },
  },

  -- Diagnostics / reference lists
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      focus = true,
      auto_preview = true,
      win = { border = "rounded" },
      keys = {
        ["<C-s>"] = "jump_split",
        ["<C-v>"] = "jump_vsplit",
      },
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (all)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Document symbols" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP locations" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "]d", function()
        require("trouble").next({ mode = "diagnostics", skip_groups = true, jump = true })
      end, desc = "Next diagnostic" },
      { "[d", function()
        require("trouble").prev({ mode = "diagnostics", skip_groups = true, jump = true })
      end, desc = "Previous diagnostic" },
    },
  },

  -- Distraction-free mode
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {
      window = {
        width = 130,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
        },
      },
      plugins = {
        gitsigns = true,
        toggleterm = false,
        tmux = false,
        alacritty = false,
        wezterm = false,
        kitty = false,
      },
      on_open = function()
        pcall(function() require("twilight").enable() end)
      end,
      on_close = function()
        pcall(function() require("twilight").disable() end)
      end,
    },
    keys = {
      { "<leader>zz", "<cmd>ZenMode<cr>", desc = "Toggle Zen mode" },
    },
  },

  -- Dim code outside the visible scope in Zen mode
  {
    "folke/twilight.nvim",
    cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    opts = {
      dimming = { alpha = 0.5, color = { 90, 95, 110 } },
      context = 0,
      exclude = {},
    },
  },

  -- Smooth navigation / "flash" jump
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { multi_window = true, wrap = true },
      jump = { autojump = true },
      modes = {
        char = { jump_labels = true, multi_line = false },
        treesitter = {
          labels = "asdfghjkl",
        },
      },
    },
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "o" }, desc = "Flash treesitter jump" },
      { "r", function() require("flash").remote() end, mode = "o", desc = "Remote flash" },
      { "R", function() require("flash").treesitter_search() end, mode = { "o", "x" }, desc = "Treesitter search" },
      { "<C-s>", function() require("flash").toggle() end, mode = { "c" }, desc = "Toggle flash search" },
    },
  },
}
