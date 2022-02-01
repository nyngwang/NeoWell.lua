if vim.fn.has("nvim-0.5") == 0 then
  return
end

if vim.g.loaded_neowell_nvim ~= nil then
  return
end

require('neo-well')

vim.g.loaded_neowell_nvim = 1
