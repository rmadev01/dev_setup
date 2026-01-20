-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  end },

  -- mini
  { "echasnovski/mini.nvim", config = function()
    require("mini.basics").setup({ options = { basic = false }, mappings = { basic = true, windows = true }, autocommands = { basic = true } })
    for _, m in ipairs({ "ai", "surround", "pairs", "comment", "cursorword" }) do require("mini." .. m).setup() end
    
    require("mini.pick").setup({ window = { config = { border = "rounded" } } })
    require("mini.statusline").setup({ use_icons = true, set_vim_settings = false })
    require("mini.indentscope").setup({ symbol = "▎", draw = { delay = 0, animation = require("mini.indentscope").gen_animation.none() } })
    require("mini.completion").setup({ window = { info = { border = "rounded" }, signature = { border = "rounded" } }, lsp_completion = { source_func = "omnifunc", auto_setup = false } })
  end },

  -- file explorer & treesitter
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true }, float = { border = "rounded" }, keymaps = { ["<BS>"] = "actions.parent", ["q"] = "actions.close" } } },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", opts = { auto_install = true, highlight = { enable = true }, indent = { enable = true } }, config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end },

  -- copilot
  { "github/copilot.vim" },

  -- lsp via mason (telemetry disabled)
  { "williamboman/mason.nvim", opts = { telemetry = { enabled = false } } },
  { "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig", "williamboman/mason.nvim" },
    config = function()
      vim.diagnostic.config({ virtual_text = false, float = { border = "rounded" }, signs = true })
      require("mason-lspconfig").setup({
        handlers = { function(s)
          require("lspconfig")[s].setup({
            on_attach = function(c, b)
              vim.bo[b].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
              if c.server_capabilities.inlayHintProvider then vim.lsp.inlay_hint.enable(true, { bufnr = b }) end
            end,
            settings = { Lua = { telemetry = { enable = false } } },
          })
        end },
      })
    end,
  },
}, {
  ui = { border = "rounded" },
  checker = { enabled = false },
})
