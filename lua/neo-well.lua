local NOREF_NOERR_TRUNC = { noremap = true, silent = true, nowait = true }
local NOREF_NOERR = { noremap = true, silent = true }
local EXPR_NOREF_NOERR_TRUNC = { expr = true, noremap = true, silent = true, nowait = true }
---------------------------------------------------------------------------------------------------
local M = {}

---------------------------------------------------------------------------------------------------
function M.neo_well_toggle()
end

local function setup_vim_commands()
  vim.cmd [[
    command! NeoWellToggle lua require'neo-well'.neo_well_toggle()
  ]]
end

setup_vim_commands()

return M
