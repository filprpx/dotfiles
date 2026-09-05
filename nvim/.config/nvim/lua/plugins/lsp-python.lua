return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              -- Pick ONE of these approaches:

              -- A) Point directly to interpreter (works for any manager)
              pythonPath = vim.fn.getcwd() .. "/.venv/bin/python",

              -- B) Or let Pyright find it by venv name + search path:
              -- venv = ".venv",
              -- venvPath = vim.fn.getcwd(), -- or "~/.virtualenvs", "~/.pyenv/versions", etc.
            },
          },
        },
      },
    },
  },
}
