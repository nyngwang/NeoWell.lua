local NOREF_NOERR_TRUNC = { noremap = true, silent = true, nowait = true }
local NOREF_NOERR = { noremap = true, silent = true }
local EXPR_NOREF_NOERR_TRUNC = { expr = true, noremap = true, silent = true, nowait = true }
---------------------------------------------------------------------------------------------------
NAME_OF_THE_LIST = 'NeoWell'

local M = {}


local function total_qflists()
  return vim.fn.getqflist({ nr = '$' }).nr
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

local function switch_to_the_qflist()
  vim.cmd('chi ' .. vim.fn.getqflist({ id = get_the_qflist_id(), nr = 0 }).nr)
end

local function get_qflist_winid(id) -- return `nil` if not opened.
  local winid = vim.fn.getqflist({ id = (id and id or 0), winid = 0 }).winid
  return winid > 0 and winid or nil
end
---------------------------------------------------------------------------------------------------

function M.setup(opts)
  M.height = opts.height and opts.height or 7
end

---------------------------------------------------------------------------------------------------
function M.neo_well_toggle()
  if get_qflist_winid() and vim.fn.getqflist({ title = 0 }).title == NAME_OF_THE_LIST then
    vim.cmd('cclose')
    vim.cmd('wincmd p')
    return
  end
  if not get_qflist_winid() then -- open the qflist first.
    vim.cmd('copen')
    vim.cmd('wincmd J')
    vim.cmd(M.height .. ' wincmd _')
  end
  switch_to_the_qflist()
end

local function setup_vim_commands()
  vim.cmd [[
    command! NeoWellToggle lua require'neo-well'.neo_well_toggle()
  ]]
end

setup_vim_commands()

return M
