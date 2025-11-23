return {
  -- Enable ruby-lsp support via mason + nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ruby_lsp" },
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
}
