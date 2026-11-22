-- Fuzzy finder

return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    opts = {
      defaults = {
        prompt_prefix = "  󰍉 ",
        selection_caret = "  󰁔 ",
        multi_icon = " 󰅢 ",
        path_display = { "smart" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            preview_width = 0.55,
            width = 0.92,
            height = 0.88,
            prompt_position = "top",
          },
          vertical = {
            width = 0.85,
            height = 0.92,
            preview_height = 0.45,
          },
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          ".venv/",
          "vendor/",
        },
        mappings = {
          i = {
            ["<C-y>"] = "select_default",
            ["<C-d>"] = "delete_buffer",
          },
          n = {
            ["<C-d>"] = "delete_buffer",
          },
        },
      },
      pickers = {
        find_files = { find_command = { "rg", "--files", "--hidden", "-g", "!.git" } },
        buffers = { sort_mru = true, ignore_current_buffer = false },
        oldfiles = { cwd_only = true },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local ok_trouble, trouble_telescope = pcall(require, "trouble.sources.telescope")
      if ok_trouble then
        opts.defaults.mappings.i["<C-t>"] = trouble_telescope.open
        opts.defaults.mappings.n["<C-t>"] = trouble_telescope.open
      end
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ hidden = true }) end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find help tags" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
      { "<leader>fc", function() require("telescope.builtin").commands() end, desc = "Find commands" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end, desc = "Find keymaps" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find diagnostics" },
      { "<leader>fs", function() require("telescope.builtin").grep_string() end, desc = "Search word under cursor" },
      { "<leader>fz", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Fuzzy search in buffer" },
      { "<leader>fo", function() require("telescope.builtin").resume() end, desc = "Resume last search" },
      { "<leader>fp", function() require("persistence").select() end, desc = "Find sessions" },
      { "<leader>/", function() require("telescope.builtin").current_buffer_fuzzy_find() end, desc = "Search in current buffer" },
      { "<leader>:", function() require("telescope.builtin").command_history() end, desc = "Command history" },
    },
  },

  -- ripgrep is the search backend
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
}
