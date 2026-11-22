-- Autocommands

local function augroup(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

-- Highlight text after yanking
autocmd("TextYankPost", {
  group = augroup("yank"),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- Reload files that changed outside Neovim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Create missing parent directories when saving (skips oil://, ssh://, ...)
autocmd("BufWritePre", {
  group = augroup("auto_mkdir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

-- Restore last cursor position (not for commit messages)
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local buf = event.buf
    if vim.tbl_contains({ "gitcommit", "gitrebase" }, vim.bo[buf].filetype) or vim.b[buf].last_loc_restored then
      return
    end
    vim.b[buf].last_loc_restored = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local line_count = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Resize splits when the window is resized (and stay on the current tab)
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Quit-friendly behavior for utility buffers (the alpha dashboard has its own q button)
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "checkhealth", "help", "lspinfo", "man", "notify", "qf", "trouble" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Clean terminal buffers
autocmd("TermOpen", {
  group = augroup("terminal"),
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end,
})

-- Wrap and spellcheck prose
autocmd("FileType", {
  group = augroup("prose"),
  pattern = { "markdown", "text", "gitcommit" },
  callback = function()
    vim.wo.wrap = true
    vim.wo.spell = true
  end,
})

-- Enable treesitter highlighting / folds / indent for every supported buffer
-- (skipped for utility buffers and for files over 1 MB, where it gets slow)
local ts_skip = { "alpha", "notify", "qf", "trouble", "NvimTree", "oil" }
autocmd("FileType", {
  group = augroup("treesitter"),
  callback = function(event)
    if vim.tbl_contains(ts_skip, vim.bo[event.buf].filetype) then
      return
    end
    local name = vim.api.nvim_buf_get_name(event.buf)
    local ok_stat, stat = pcall(vim.uv.fs_stat, name)
    if ok_stat and stat and stat.size > 1024 * 1024 then
      return
    end
    local ok = pcall(vim.treesitter.start, event.buf)
    if ok then
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
      -- Treesitter indentation is experimental but works well in 0.12
      vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
