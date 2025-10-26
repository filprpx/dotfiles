return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "omnisharp" })
      opts.automatic_installation = true
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.omnisharp = vim.tbl_deep_extend(
        "force",
        opts.servers.omnisharp or {},
        {
          enable_roslyn_analyzers = true,
          enable_import_completion = true,
          organize_imports_on_format = true,
        }
      )
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "c_sharp" })
    end,
  },
}
