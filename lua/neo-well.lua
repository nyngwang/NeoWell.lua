---------------------------------------------------------------------------------------------------
local M = {}
NAME_OF_THE_LIST = 'NeoWell'


local function total_qflists()
  return vim.fn.getqflist({ nr='$' }).nr
end

local function get_the_menu_id()
  for i = 1, total_qflists() do
    if vim.fn.getqflist({ nr=i, title=0 }).title == NAME_OF_THE_LIST
      then return vim.fn.getqflist({ nr=i, id=0 }).id end
  end
  local signal = vim.fn.setqflist({}, ' ', { nr='$', title=NAME_OF_THE_LIST })
  if signal ~= 0 then
    print('NeoWell: Failed to create the menu!')
    return nil
  end
  return get_the_menu_id()
end

local function the_menu_did_build()
  return get_the_menu_id()
end

local function switch_to_the_menu()
  vim.cmd('chi ' .. vim.fn.getqflist({ id=get_the_menu_id(), nr=0 }).nr)
end

local function get_the_menu_winid() -- return `nil` if not opened.
  local id = get_the_menu_id()
  if not id then return nil end
  local winid = vim.fn.getqflist({ id=id, winid=0 }).winid
  return winid > 0 and winid or nil
end

local function the_menu_is_open()
  return get_the_menu_winid()
end

local function cursor_is_at_the_menu()
  if get_the_menu_winid() == vim.api.nvim_get_current_win() then return true end
  return false
end

---------------------------------------------------------------------------------------------------
function M.setup(opts)
  M.menu_height = opts.height or 7
  M.split_on_top = opts.split_on_top
    if M.split_on_top == nil then M.split_on_top = true end
end
---------------------------------------------------------------------------------------------------
function M.neo_well_toggle()
  if the_menu_is_open() then vim.cmd('ccl') return end
  if the_menu_did_build() then
    local pos = M.split_on_top and 'top' or 'bot'
    vim.cmd(string.format('%s copen %d', pos, M.menu_height))
    switch_to_the_menu()
  end
end

function M.neo_well_append()
  if vim.bo.buftype == 'quickfix' then return end
  local input = vim.fn.input('NeoWell: Well, I think this line ... ')
  if input == '' or input:match('^%s+$') then -- nothing added.
    print('cancelled.')
  end
  vim.fn.setqflist({}, 'a', {
    id = get_the_menu_id(),
    items = {
      {
        filename = vim.fn.bufname(),
        lnum = vim.fn.line('.'),
        col = vim.fn.col('.'),
        text = input
      }
    }
  })
end

function M.neo_well_edit()
  if not cursor_is_at_the_menu() then return end
  local idx = vim.fn.line('.')
  local items = vim.fn.getqflist({ items=0 }).items
  local input = vim.fn.input('Enter your new comment: ')
  if input == '' or input:match('^%s+$') then -- nothing added.
    print('cancelled.')
  end
  items[idx].text = input
  vim.fn.setqflist({}, 'r', { items=items })
end

function M.neo_well_out()
  if not cursor_is_at_the_menu() then return end
  local idx = vim.fn.line('.')
  local items = vim.fn.getqflist({ items = 0 }).items
  if not vim.fn.input('Confirm delete item ' .. idx .. '([Yy]/n): '):match('^[Yy]$') then return end
  local new_items = {}
  for _idx, item in ipairs(items) do
    if _idx ~= idx then
      table.insert(new_items, item)
    end
  end
  vim.fn.setqflist({}, 'r', { items = new_items })
  vim.cmd('normal! j') -- move the the next item
end

function M.neo_well_wipeout()
  if not cursor_is_at_the_menu() then return end
  if not vim.fn.input('[WARNING] Confirm delete ALL items ([Yy]/n): '):match('^[Yy]$') then return end
  vim.fn.setqflist({}, 'r', { items = {} })
end

local function setup_vim_commands()
  vim.cmd [[
    command! NeoWellToggle lua require'neo-well'.neo_well_toggle()
    command! NeoWellAppend lua require'neo-well'.neo_well_append()
    command! NeoWellOut lua require'neo-well'.neo_well_out()
    command! NeoWellEdit lua require'neo-well'.neo_well_edit()
    command! NeoWellWipeOut lua require'neo-well'.neo_well_wipeout()
  ]]
end

setup_vim_commands()

return M
