return {
  -- Enable ruby-lsp support via mason + nvim-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ruby_lsp", "herb_ls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {},
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.lsp.enable("herb_ls")
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ruby", "eruby" })
    end,
  },
}
