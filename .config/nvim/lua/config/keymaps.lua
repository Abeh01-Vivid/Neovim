-- General keymaps (plugin-specific keymaps live in the plugin specs)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize windows with Alt+arrows
map("n", "<M-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
map("n", "<M-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })
map("n", "<M-Up>", ":resize +2<CR>", { desc = "Resize window up" })
map("n", "<M-Down>", ":resize -2<CR>", { desc = "Resize window down" })

-- Move text in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep visual selection when indenting
map("v", "<", "<gv", { desc = "Outdent selection" })
map("v", ">", ">gv", { desc = "Indent selection" })

-- Keep cursor centered while searching
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })

-- Paste without overwriting the unnamed register
map("x", "p", [["_dP]], { desc = "Paste without yanking" })

-- Redo with U
map("n", "U", "<C-r>", { desc = "Redo" })

-- Save / quit
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
map("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force quit all" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Increment / decrement
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- Buffers
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Terminal escape
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: go to left window" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: go to lower window" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: go to upper window" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: go to right window" })

-- Quickfix navigation
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix item" })
