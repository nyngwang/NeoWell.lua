NeoWell.lua
===

### Features

- Toggle the only NeoWell list
  - Leave existing ones **intact**
  - List shown in the very bottom (to put emphasis on that it's global)


### Usage

#### Toggle the list

```lua
vim.keymap.set('n', '\\', function () vim.cmd('NeoWellToggle') end, NOREF_NOERR_TRUNC)
-- :NeoWellToggle
```

### TODO list

- [x] toggle the list
  - [x] move to the bottom window
- [ ] prompt: to add the current line into items
- [ ] buffer command:
  - [ ] goto item
    - [ ] the cursor should stay in the list
  - [ ] prompt: edit list title
  - [ ] prompt: edit item text
    - [ ] should reflect the change immediately
  - [ ] prompt: confirm delete current item
    - [ ] should reflect the change immediately
    - [ ] the cursor move to the next item
    - [ ] close the list on empty
  - [ ] filter via text (probably get postponed, qq)
  - [ ] prompt: confirm delete the entire list
    - [ ] should only delete lists I created


