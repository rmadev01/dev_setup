-- init
vim.loader.enable()
vim.g.mapleader = " "

-- options
local o = vim.opt
o.number = true 
o.relativenumber = true
o.scrolloff = 10
o.sidescrolloff = 10
o.shiftwidth = 4
o.tabstop = 4
o.expandtab = true
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.splitright = true
o.splitbelow = true
o.undofile = true
o.updatetime = 250
o.clipboard = "unnamedplus"

-- lazy bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  -- theme
  { "vague2k/vague.nvim", config = function()
      require("vague").setup({ style = { comments = "italic" } })
      vim.cmd.colorscheme("vague")
      vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#222226", fg = "#c7c6c6" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#3a3a42", fg = "#8cadc6", bold = true })
  end },

  -- utilities
  { "echasnovski/mini.nvim", config = function()
      require("mini.basics").setup({
        options = { basic = false },
        mappings = { basic = true, windows = true },
        autocommands = { basic = true }
      })
      for _, m in ipairs({ "ai", "surround", "pairs", "comment", "cursorword" }) do
        require("mini." .. m).setup()
      end
      require("mini.pick").setup({ window = { config = { border = "rounded" } } })
      require("mini.statusline").setup({ use_icons = true, set_vim_settings = false })
      require("mini.indentscope").setup({
        symbol = "▎",
        draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() }
      })
      require("mini.completion").setup({ lsp_completion = { source_func = "omnifunc", auto_setup = false } })
      require("mini.cmdline").setup()
      require("mini.diff").setup({ view = { style = "sign", signs = { add = "▎", change = "▎", delete = "▁" } } })
  end },

  -- git
  { "tpope/vim-fugitive", config = function()
      vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
  end },

  -- splits
  { "mrjones2014/smart-splits.nvim", config = function()
      local s = require("smart-splits")
      s.setup({ at_edge = "stop" })
      vim.keymap.set("n", "<C-h>", s.move_cursor_left)
      vim.keymap.set("n", "<C-l>", s.move_cursor_right)
      vim.keymap.set("n", "<C-Left>", s.resize_left)
      vim.keymap.set("n", "<C-Right>", s.resize_right)
  end },

  -- file manager
  { "stevearc/oil.nvim", opts = {
      view_options = { show_hidden = true },
      float = { border = "rounded" },
      keymaps = { ["<BS>"] = "actions.parent", ["q"] = "actions.close" }
  } },

  -- treesitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", config = function()
      require("nvim-treesitter").install(require("nvim-treesitter").get_installed())
      vim.api.nvim_create_autocmd("FileType", { callback = function() pcall(vim.treesitter.start) end })
  end },

  -- harpoon
  { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" }, config = function()
      local harpoon = require("harpoon")
      harpoon:setup({ settings = { save_on_toggle = true } })
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<leader>o", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
  end },

  -- copilot
  { "github/copilot.vim", config = function()
      vim.g.copilot_telemetry = false
  end },

  -- mason
  { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        handlers = { function(s)
          require("lspconfig")[s].setup({
            settings = { Lua = { telemetry = { enable = false } } },
          })
        end },
      })
    end },

}, { ui = { border = "rounded" }, checker = { enabled = false } })

-- lsp
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
vim.diagnostic.config({ virtual_text = false, float = { border = "rounded" }, signs = true })
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local b = args.buf
    local map = function(m, k, f) vim.keymap.set(m, k, f, { buffer = b }) end
    map("n", "gd", vim.lsp.buf.definition)
    map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end)
    map("n", "<leader>rn", vim.lsp.buf.rename)
    map("n", "<leader>ca", vim.lsp.buf.code_action)
    map("n", "<leader>lf", vim.lsp.buf.format)
    vim.bo[b].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end,
})

-- keymaps
local map = vim.keymap.set
map("n", "<leader>", "<cmd>nohl<cr>")
map("i", "jj", "<Esc>")
map("n", "<leader>q", "<cmd>quit<cr>")
map("n", "<leader>w", "<cmd>write<cr>")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<leader>e", "<cmd>Oil<cr>")
map("n", "<leader>f", "<cmd>Pick files<cr>")
map("n", "<leader>b", "<cmd>Pick buffers<cr>")
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>")
map("n", "<leader>sr", "<cmd>vsplit<cr>")
map("n", "gl", vim.diagnostic.open_float)
map("n", "<leader>h", "<cmd>wincmd h<cr>")
map("n", "<leader>l", "<cmd>wincmd l<cr>")
map("n", "<leader>H", ":vsplitresize +5")
map("n", "<leader>L", ":vsplitresize -5")


