-- globals & options
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  -- theme
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({ options = { transparent = true } })
      vim.cmd("colorscheme github_dark_dimmed")
      -- minimal statusline
      vim.cmd("hi StatusLine guibg=NONE guifg=#768390")
      vim.cmd("hi StatusLineNC guibg=NONE guifg=#768390")
    end,
  },
  -- editor
  {
    "stevearc/oil.nvim",
    opts = {
      view_options = { show_hidden = true },
      keymaps = { ["<C-c>"] = false, ["q"] = "actions.close" },
    },
  },
  {
    "echasnovski/mini.pick",
    version = false,
    cmd = "Pick",
    config = function() require("mini.pick").setup() end,
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    config = function() require("mini.pairs").setup() end,
  },
  -- completion
  {
    "saghen/blink.cmp",
    version = "*",
    opts = {
      keymap = { preset = "enter" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
    },
  },
  -- lsp
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        automatic_installation = true,
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,
        },
      })
      -- diagnostics config
      vim.diagnostic.config({
        virtual_text = false,
        float = { border = "rounded" },
        signs = { text = { [1] = "E", [2] = "W", [3] = "I", [4] = "H" } },
      })
    end,
  },
})

-- keymaps
local map = vim.keymap.set
map("i", "jj", "<ESC>")
map("n", "<leader>w", ":write<CR>")
map("n", "<leader>q", ":qa!<CR>")
map("n", "<leader>e", ":Oil<CR>")
map("n", "<leader>f", ":Pick files<CR>")
map("n", "<leader>b", ":Pick buffers<CR>")
map("n", "<leader>h", ":Pick help<CR>")
map("n", "<leader>fg", ":Pick grep_live<CR>")

-- window navigation & resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>sr", ":vsplit<CR>")
map("n", "<leader>se", "<C-w>=")
map("n", "<C-Left>", ":vertical resize -5<CR>")
map("n", "<C-Right>", ":vertical resize +5<CR>")

-- lsp keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    map("n", "<leader>lf", vim.lsp.buf.format, opts)
  end,
})

-- auto open diagnostics
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function() vim.diagnostic.open_float(nil, { focusable = false }) end,
})
