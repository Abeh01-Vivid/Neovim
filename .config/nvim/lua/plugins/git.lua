-- Git integration

return {
  -- Git signs in the gutter
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = { follow_files = true },
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 500,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
      diff_opts = { internal = true },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        local opts = { buffer = bufnr, silent = true }

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, { buffer = bufnr, desc = "Next git hunk" })

        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, { buffer = bufnr, desc = "Previous git hunk" })

        map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>", vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
        map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>", vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
        map("n", "<leader>hS", gs.stage_buffer, vim.tbl_extend("force", opts, { desc = "Stage buffer" }))
        map("n", "<leader>hR", gs.reset_buffer, vim.tbl_extend("force", opts, { desc = "Reset buffer" }))
        map("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, vim.tbl_extend("force", opts, { desc = "Blame line" }))
        map("n", "<leader>htb", gs.toggle_current_line_blame, vim.tbl_extend("force", opts, { desc = "Toggle line blame" }))
        map("n", "<leader>hd", gs.diffthis, vim.tbl_extend("force", opts, { desc = "Diff against index" }))
        map("n", "<leader>hD", function() gs.diffthis("~") end, vim.tbl_extend("force", opts, { desc = "Diff against last commit" }))
      end,
    },
    keys = {
      { "<leader>hh", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
    },
  },

  -- The classic git porcelain
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gstatus", "Gcommit", "Gpush", "Gpull", "Gdiff", "Gblame", "Glog", "Gread", "Gwrite" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff split" },
    },
  },

  -- Full-screen git client
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_floating_window_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
      vim.g.lazygit_use_custom_config_file_path = 0
    end,
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
      { "<leader>gf", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit: current file" },
    },
  },

  -- GitHub issues / PRs (optional, loaded on demand)
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "folke/trouble.nvim",
    },
    opts = {
      icons = true,
      use_local_fs = false,
      enable_builtin = true,
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "GitHub issues" },
      { "<leader>gP", "<cmd>Octo pr list<cr>", desc = "GitHub pull requests" },
    },
  },
}
