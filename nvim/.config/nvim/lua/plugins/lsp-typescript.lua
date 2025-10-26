return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vtsls" })
      opts.automatic_installation = true
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.vtsls = vim.tbl_deep_extend(
        "force",
        opts.servers.vtsls or {},
        {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "none" },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
              },
            },
          },
        }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "tsx", "typescript" })
    end,
  },
}
