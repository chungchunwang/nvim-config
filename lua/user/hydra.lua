local Hydra = require "hydra"
local cmd = require("hydra.keymap-util").cmd
Hydra {
  name = "Hydra's name",
  hint = [[
  _C_: continue
  _I_: step into
  _o_: step over
  _O_: step out
  _b_: toggle breakpoint
  _U_: toggle ui
  _e_: evaluate
  _t_: terminate
  ----------------------
  _L_: run last
  _R_: toggle repl

  ]],
  config = {
    color = 'pink',
    invoke_on_body = true,
  },
  mode = "n",
  body = "<leader>d",
  heads = {
    { "b", cmd "lua require'dap'.toggle_breakpoint()<cr>" },
    { "C", cmd "lua require'dap'.continue()<cr>" },
    { "I", cmd "lua require'dap'.step_into()<cr>" },
    { "o", cmd "lua require'dap'.step_over()<cr>" },
    { "O", cmd "lua require'dap'.step_out()<cr>" },
    { "R", cmd "lua require'dap'.repl.toggle()<cr>" },
    { "L", cmd "lua require'dap'.run_last()<cr>" },
    { "U", cmd "lua require'dapui'.toggle()<cr>" },
    { "t", cmd "lua require'dap'.terminate()<cr>" },
    { "e", cmd "lua require'dapui'.eval(nil,{enter = true})<cr>" }
  },
}
vim.cmd("Alpha")
