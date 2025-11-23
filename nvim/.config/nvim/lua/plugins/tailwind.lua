return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          filetypes = {
            "html",
            "htmldjango",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescriptreact",
            "svelte",
            "vue",
            "rust",
            "eruby", -- for Rails .html.erb
          },
        },
      },
    },
  },
}
