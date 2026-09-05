return {
  "mfussenegger/nvim-lint",
  opts = {
    linters = {
      golangcilint = {
        prepend_args = {
          "--config",
          vim.fn.expand("~/.config/nvim/.golangci.yml"),
        },
      },
    },
  },
}
