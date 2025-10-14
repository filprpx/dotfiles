return {
  { "mason-org/mason.nvim", config = true },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = { ensure_installed = { "ts_ls" }, automatic_installation = true },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              inlayHints = {
                parameterNames = { enabled = "none" },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
