local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local mason_nvim_dap_status_ok, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if not mason_nvim_dap_status_ok then
  return
end

mason_nvim_dap.setup({
    automatic_setup = true,
    ensure_installed = {'cppdbg', 'python'}
})

mason_nvim_dap.setup_handlers {
    function(source_name)
      -- all sources with no handler get passed here

      -- Keep original functionality of `automatic_setup = true`
      require('mason-nvim-dap.automatic_setup')(source_name)
    end,
    python = function(source_name)
        dap.adapters.python = {
	        type = "executable",
	        command = "/usr/bin/python3",
	        args = {
		        "-m",
		        "debugpy.adapter",
	        },
        }
        dap.configurations.python = {
	        {
		        type = "python",
		        request = "launch",
		        name = "Launch file",
		        program = "${file}", -- This configuration will launch the current file if used.
	        },
        }
    end,

    cppdbg = function(source_name)
        require('mason-nvim-dap.automatic_setup')(source_name)
        dap.configurations.cpp = {
	        {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = "a.out",
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
          },
        }
    end,
}
function _G.cppCompileFileToDebug()
  vim.cmd("!g++ -g " .. vim.api.nvim_buf_get_name(0))
end
vim.api.nvim_set_keymap('n', '<leader>dd', ':lua cppCompileFileToDebug()<CR>', {noremap = true})
dapui.setup {
  expand_lines = true,
  icons = { expanded = "", collapsed = "", circular = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl", size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5, -- Floats will be treated as percentage of your screen.
    border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
