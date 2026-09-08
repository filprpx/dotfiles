return {
  "stevearc/oil.nvim",
  cmd = { "Oil" },
  opts = {
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
    },
  },
  keys = {
    {
      "<leader>o",
      function()
        if vim.bo.filetype == "oil" then
          require("oil").close()
        else
          require("oil").open()
        end
      end,
      desc = "Toggle Oil file browser",
    },
  },
}
