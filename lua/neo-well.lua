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

local function cursor_on_the_qflist()
  if vim.bo.buftype ~= 'quickfix' -- if not hover
    or vim.fn.getqflist({ id = 0 }).id ~= vim.fn.getqflist({ id = get_the_qflist_id() }).id -- or not on NeoWell
    then return false end
  return true
end

local function pin_to_80_percent_height()
  local scrolloff = 7
  local cur_line = vim.fn.line('.')
  vim.cmd("normal! zt")
  if (cur_line > scrolloff) then
    vim.cmd("normal! " .. scrolloff .. "k" .. scrolloff .. "j")
  end
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
    vim.cmd('wincmd H | wincmd J')
    vim.cmd(M.height .. ' wincmd _')
  end
  switch_to_the_qflist()
end

function M.neo_well_append()
  if vim.bo.buftype == 'quickfix' then return end
  local input = vim.fn.input('Well ... ')
  if input == '' or input:match('^%s+$') then -- nothing added.
    print('cancelled.')
  end
  vim.fn.setqflist({}, 'a', {
    id = get_the_qflist_id(),
    items = {
      {
        filename = vim.fn.bufname(),
        lnum = vim.fn.line('.'),
        col = vim.api.nvim_win_get_cursor(0)[2]+1,
        text = input
      }
    }
  })
end

function M.neo_well_jump()
  if not cursor_on_the_qflist() then return end
  vim.cmd('cc ' .. vim.fn.line('.'))
  pin_to_80_percent_height()
  pin_to_80_percent_height() -- we need to do it fucking twice ¯\_(ツ)_/¯.
end

function M.neo_well_edit()
  if not cursor_on_the_qflist() then return end
  local idx = vim.fn.line('.')
  local items = vim.fn.getqflist({ items = 0 }).items
  local input = vim.fn.input('Enter your new comment: ')
  if input == '' or input:match('^%s+$') then -- nothing added.
    print('cancelled.')
  end
  items[idx].text = input
  vim.fn.setqflist({}, 'r', { items = items })
end

function M.neo_well_out()
  if not cursor_on_the_qflist() then return end
  local idx = vim.fn.line('.')
  local items = vim.fn.getqflist({ items = 0 }).items
  if #items == 0 then
    vim.cmd('cclose')
    return
  end
  if not vim.fn.input('Confirm delete item ' .. idx .. '(y/n): '):match('[Yy](es)?') then return end
  local new_items = {}
  for _idx, item in ipairs(items) do
    if _idx ~= idx then
      table.insert(new_items, item)
    end
  end
  vim.fn.setqflist({}, 'r', { items = new_items })
end

local function setup_vim_commands()
  vim.cmd [[
    command! NeoWellToggle lua require'neo-well'.neo_well_toggle()
    command! NeoWellAppend lua require'neo-well'.neo_well_append()
    command! NeoWellJump lua require'neo-well'.neo_well_jump()
    command! NeoWellEdit lua require'neo-well'.neo_well_edit()
    command! NeoWellOut lua require'neo-well'.neo_well_out()
  ]]
end

setup_vim_commands()

return M
