-- Editor options / IDE-ish defaults

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable built-in netrw (nvim-tree / oil take over)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local opt = vim.opt

-- Appearance
opt.termguicolors = true
opt.background = "light" -- important for Catppuccin Latte
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorcolumn = false
opt.signcolumn = "yes:1"
opt.colorcolumn = "120"
opt.ruler = false
opt.showmode = false -- noice / lualine handle this
opt.laststatus = 3 -- global statusline
opt.wrap = false
opt.list = true
opt.listchars = {
  tab = "» ",
  space = "·",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
}
opt.fillchars = {
  eob = " ",
  vert = "│",
  fold = "·",
  foldopen = "▾",
  foldclose = "▸",
  diff = "╱",
}
opt.winborder = "rounded"

-- Indentation / tabs
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"

-- Editing behavior
opt.backspace = { "indent", "eol", "start" }
-- Set after startup: clipboard provider detection is slow
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)
opt.mouse = "a"
opt.joinspaces = false
opt.splitright = true
opt.splitbelow = true
opt.equalalways = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.virtualedit = "block"
opt.formatoptions = "jcrql"

-- Completion / menu
opt.pumheight = 12
opt.pumblend = 10
opt.winblend = 0
opt.completeopt = "menu,menuone,noselect"

-- Performance / misc
opt.updatetime = 200
opt.timeoutlen = 300
opt.redrawtime = 1500
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undolevels = 10000
opt.jumpoptions = "stack"
opt.history = 1000
opt.confirm = true -- ask to save instead of failing on :q / :bd
opt.smoothscroll = true
opt.splitkeep = "screen" -- keep text stable when splits open/close
opt.grepprg = "rg --vimgrep --smart-case"
opt.grepformat = "%f:%l:%c:%m"

-- Folding (treesitter-based; falls back gracefully without a parser)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.vim.treesitter.foldtext()"
opt.foldlevel = 99
opt.foldnestmax = 10

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = " ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    header = "",
  },
})
