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
            "eruby",
          },
          init_options = {
            userLanguages = {
              eruby = "erb",
            },
          },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                erb = "html",
              },
            },
          },
        },
      },
    },
  },
}
