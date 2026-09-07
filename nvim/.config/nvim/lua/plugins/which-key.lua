return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      opts.plugins = opts.plugins or {}
      opts.plugins.registers = false
    end,
  },
}
