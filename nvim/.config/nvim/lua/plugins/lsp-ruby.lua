return {
  -- Enable ruby-lsp support via mason + nvim-lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "ruby_lsp" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          -- Explicitly use mise's Ruby 4.0.0 which has bundler
          cmd = { "/home/filprpx/.local/share/mise/installs/ruby/4.0.0/bin/ruby-lsp" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ruby", "eruby" })
    end,
  },
}
