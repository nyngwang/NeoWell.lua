NeoWell.lua
===

### Features

- Toggle the only NeoWell list
  - Leave existing ones **intact**
  - List shown in the very bottom (to put emphasis on that it's global)
- Goto the target brainlessly via `<CR>`(see the default settings below)
  - Just type `\` twice to back to the list, no need to use command
- Prompt, _user-friendly-ly_
  - for the comment at the current line
  - to confirm **comment rewording** :)
  - to confirm deletion of the hovered item
  - to confirm deletion of **ALL** items
- Filtering is on the schedule


### Example Config



```lua
local NOREF_NOERR_TRUNC = { noremap = true, silent = true, nowait = true }
----
use {
  'nyngwang/NeoWell.lua',
  config = function ()
    require('neo-well').setup {
      height = 10
    }
  end
}
vim.keymap.set('n', '\\', function () vim.cmd('NeoWellToggle') end, NOREF_NOERR_TRUNC)
vim.keymap.set('n', '<Leader>/', function () vim.cmd('NeoWellAppend') end, NOREF_NOERR_TRUNC)
vim.keymap.set('n', '<CR>', function ()
  -- vim.cmd('NeoZoomToggle') -- remove this if you don't know what it is
  vim.cmd('NeoWellJump')
end, NOREF_NOERR_TRUNC)
vim.keymap.set('n', '<Leader>r', function () vim.cmd('NeoWellEdit') end, NOREF_NOERR_TRUNC)
vim.keymap.set('n', '<Leader>d', function () vim.cmd('NeoWellOut') end, NOREF_NOERR_TRUNC)
vim.keymap.set('n', '<Leader>D', function () vim.cmd('NeoWellWipeOut') end, NOREF_NOERR_TRUNC)
```

### TODO list

- [x] toggle the list
  - [x] move to the bottom window
- [x] prompt: to add the current line into items
- [x] buffer command:
  - [x] goto item (TODO preview: postponed because need to select window, too hard)
  - [x] prompt: edit item text (the change reflected immediately by default :) )
  - [x] prompt: confirm delete current item (the change reflected immediately by default :) )
    - [x] should reflect the change immediately
    - [x] the cursor move to the next item
  - [x] prompt: confirm delete all items


### Future

- [ ] filter via text
- [ ] prompt: edit list title (not important so far)
- [ ] wrap-around on the first/last item (not important so far)

