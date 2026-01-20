vim.loader.enable()
vim.g.mapleader = " "

-- options
local o = vim.opt
o.number, o.relativenumber = true, true
o.scrolloff, o.sidescrolloff = 10, 10
o.shiftwidth, o.tabstop, o.expandtab, o.smartindent = 4, 4, true, true
o.ignorecase, o.smartcase = true, true
o.splitright, o.splitbelow = true, true
o.undofile, o.updatetime, o.clipboard = true, 250, "unnamedplus"

-- load plugins
require("plugins")

-- keymaps
local map = vim.keymap.set
map("i", "jj", "<Esc>")
map("n", "<leader>q", "<cmd>quit<cr>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<leader>e", "<cmd>Oil<cr>")
map("n", "<leader>f", "<cmd>Pick files<cr>")
map("n", "<leader>b", "<cmd>Pick buffers<cr>")
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>")
map("n", "<leader>sr", "<cmd>vsplit<cr>")
map("n", "<leader>sd", "<cmd>split<cr>")
map("n", "gl", vim.diagnostic.open_float)
