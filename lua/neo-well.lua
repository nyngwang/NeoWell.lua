local NOREF_NOERR_TRUNC = { noremap = true, silent = true, nowait = true }
local NOREF_NOERR = { noremap = true, silent = true }
local EXPR_NOREF_NOERR_TRUNC = { expr = true, noremap = true, silent = true, nowait = true }
---------------------------------------------------------------------------------------------------
NAME_OF_THE_LIST = 'NeoWell'

local M = {}


local function total_qflists()
  return vim.fn.getqflist({ nr = '$' })
end

local function get_the_qflist_id()
  for i = 1, total_qflists() do
    if vim.fn.getqflist({ nr = i, title = 0 }).title == NAME_OF_THE_LIST then -- the list has been initialized.
      return vim.fn.getqflist({ nr = i, id = 0 }).id
    end
  end
  -- init
  local signal = vim.fn.setqflist({}, ' ', { nr = '$', title = NAME_OF_THE_LIST })
  if signal ~= 0 then
    print('NeoWell: Failed in creation...!')
  end
  return get_the_qflist_id()
end

local function qflist_is_open()
end

---------------------------------------------------------------------------------------------------
function M.neo_well_toggle()
  vim.cmd()
end

local function setup_vim_commands()
  vim.cmd [[
    command! NeoWellToggle lua require'neo-well'.neo_well_toggle()
  ]]
end

setup_vim_commands()

return M
