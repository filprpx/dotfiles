return {
  {
    "mason-org/mason.nvim",
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
      local remote_host = vim.env.NETCOREDBG_HOST or "127.0.0.1"
      local remote_port = tonumber(vim.env.NETCOREDBG_PORT) or 4711

      dap.adapters.coreclr = function(callback, config)
        if config.remoteAdapter then
          callback({
            type = "server",
            host = config.remoteAdapter.host or remote_host,
            port = config.remoteAdapter.port or remote_port,
          })
          return
        end

        callback({
          type = "executable",
          command = netcoredbg,
          args = { "--interpreter=vscode" },
        })
      end

      local pick_process = require("dap.utils").pick_process
      local root = require("lazyvim.util").root.get() or vim.fn.getcwd()
      root = vim.fs.normalize(root)

      ---Resolve the dotnet PID inside the docker compose `web-debug` service.
      local function docker_compose_dotnet_pid()
        local cmd = "docker compose --profile debug exec web-debug pidof dotnet"
        local output = vim.fn.systemlist(cmd)
        if vim.v.shell_error ~= 0 then
          error(string.format("Failed to resolve dotnet PID via `%s`: %s", cmd, table.concat(output, "\n")))
        end

        local line = output[1]
        if not line or line == "" then
          error("No dotnet process found in web-debug container (pid lookup returned empty output)")
        end

        local pid = line:match("(%d+)")
        if not pid then
          error("Unable to parse dotnet PID from output: " .. table.concat(output, "\n"))
        end

        return tonumber(pid)
      end

      local function ensure_config(lang, name, config)
        dap.configurations[lang] = dap.configurations[lang] or {}
        for idx, cfg in ipairs(dap.configurations[lang]) do
          if cfg.name == name then
            dap.configurations[lang][idx] = vim.tbl_deep_extend("force", cfg, config)
            return
          end
        end
        table.insert(dap.configurations[lang], config)
      end

      local function add_configuration(lang)
        ensure_config(lang, "Launch .NET", {
          type = "coreclr",
          name = "Launch .NET",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
        })
        ensure_config(lang, "Attach .NET (host PID)", {
          type = "coreclr",
          request = "attach",
          name = "Attach .NET (host PID)",
          processId = pick_process,
        })
        ensure_config(lang, "Attach web-debug (Docker)", {
          type = "coreclr",
          request = "attach",
          name = "Attach web-debug (Docker)",
          remoteAdapter = {
            host = remote_host,
            port = remote_port,
          },
          sourceFileMap = {
            [vim.env.NETCOREDBG_CONTAINER_ROOT or "/workspace"] = root,
          },
          processId = docker_compose_dotnet_pid,
        })
      end

      add_configuration("cs")
      add_configuration("fsharp")
    end,
  },
}
