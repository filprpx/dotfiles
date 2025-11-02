return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "netcoredbg" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "coreclr" })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<S-F9>",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "DAP Conditional Breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<S-F11>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<leader>dR",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "DAP Run to Cursor",
      },
      {
        "<leader>dr",
        function()
          local dap = require("dap")
          if dap.restart then
            dap.restart()
            return
          end
          if dap.session() then
            dap.terminate()
          end
          dap.run_last()
        end,
        desc = "DAP Restart",
      },
      {
        "<leader>dT",
        function()
          require("dap").terminate()
        end,
        desc = "DAP Terminate",
      },
    },
    config = function()
      local dap = require("dap")
      local mason = vim.fn.stdpath("data") .. "/mason"
      local netcoredbg = mason .. "/packages/netcoredbg/netcoredbg"
      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
      }

      local function add_configuration(lang)
        dap.configurations[lang] = dap.configurations[lang] or {}
        for _, cfg in ipairs(dap.configurations[lang]) do
          if cfg.name == "Launch .NET" then
            return
          end
        end
        table.insert(dap.configurations[lang], {
          type = "coreclr",
          name = "Launch .NET",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        })
      end

      add_configuration("cs")
      add_configuration("fsharp")
    end,
  },
}
