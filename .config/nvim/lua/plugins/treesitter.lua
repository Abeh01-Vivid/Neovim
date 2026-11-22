-- Treesitter parsing, text objects and sticky context
-- Uses the nvim-treesitter 0.12+ rewrite API

local parsers = {
  "bash", "c", "cpp", "css", "dockerfile", "go", "html", "javascript",
  "json", "lua", "markdown", "markdown_inline", "python", "query", "regex",
  "rust", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- the rewrite cannot be lazy-loaded
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-treesitter-context",
    },
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = function(_, opts)
      require("nvim-treesitter").setup(opts)

      -- Install the core parser set in the background (no-op when present).
      require("nvim-treesitter").install(parsers)

      -- Syntax-aware text objects
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
        },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")
      local m = { "n", "x", "o" }

      local mappings = {
        { mode = { "x", "o" }, lhs = "af", rhs = function() select.select_textobject("@function.outer", "textobjects") end, desc = "Select outer function" },
        { mode = { "x", "o" }, lhs = "if", rhs = function() select.select_textobject("@function.inner", "textobjects") end, desc = "Select inner function" },
        { mode = { "x", "o" }, lhs = "ac", rhs = function() select.select_textobject("@class.outer", "textobjects") end, desc = "Select outer class" },
        { mode = { "x", "o" }, lhs = "ic", rhs = function() select.select_textobject("@class.inner", "textobjects") end, desc = "Select inner class" },
        { mode = { "x", "o" }, lhs = "aa", rhs = function() select.select_textobject("@parameter.outer", "textobjects") end, desc = "Select outer argument" },
        { mode = { "x", "o" }, lhs = "ia", rhs = function() select.select_textobject("@parameter.inner", "textobjects") end, desc = "Select inner argument" },
        { mode = m, lhs = "]f", rhs = function() move.goto_next_start("@function.outer", "textobjects") end, desc = "Next function" },
        { mode = m, lhs = "[f", rhs = function() move.goto_previous_start("@function.outer", "textobjects") end, desc = "Previous function" },
        { mode = m, lhs = "]]", rhs = function() move.goto_next_start("@class.outer", "textobjects") end, desc = "Next class" },
        { mode = m, lhs = "[[", rhs = function() move.goto_previous_start("@class.outer", "textobjects") end, desc = "Previous class" },
        { mode = m, lhs = "[a", rhs = function() move.goto_previous_start("@parameter.inner", "textobjects") end, desc = "Previous argument" },
        { mode = m, lhs = "]a", rhs = function() move.goto_next_start("@parameter.inner", "textobjects") end, desc = "Next argument" },
      }

      for _, mapping in ipairs(mappings) do
        vim.keymap.set(mapping.mode, mapping.lhs, mapping.rhs, { desc = mapping.desc, silent = true })
      end

      vim.keymap.set("n", "<leader>ta", function() swap.swap_next("@parameter.inner") end, { desc = "Swap argument with next" })
      vim.keymap.set("n", "<leader>tA", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap argument with previous" })

      -- Sticky context header
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        min_window_height = 12,
        line_numbers = true,
        multiline_threshold = 12,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
      })
      vim.keymap.set("n", "[C", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { desc = "Jump to context", silent = true })
    end,
  },
}
