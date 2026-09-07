-- Credits to Alex Sokol:  https://www.youtube.com/watch?v=Vxc1QWhQLpc

-- NOTE: Relies on arg list, which doesn't persist on restarts!

vim.keymap.set('n', '<leader>aa', function()
  vim.cmd '0argadd %' -- '0' to prepend, '%' for current file.
  vim.cmd 'argdedup' -- remove potential dupplicate

  -- Auto-print new args list.
  vim.cmd.args()
end, { desc = 'Add' })

vim.keymap.set('n', '<leader>al', function() vim.cmd.args() end, { desc = 'Print' })
vim.keymap.set('n', '<leader>ad', ':argdelete %<CR>', { desc = 'Remove' })
vim.keymap.set('n', '<leader>ac', ':argdelete *<CR>', { desc = 'Clear' })

-- Quick-switch to most recent bookmarks

vim.keymap.set('n', '<C-h>', function() vim.cmd 'silent! 1argument' end, { desc = 'Bookmark 1' })

vim.keymap.set('n', '<C-j>', function() vim.cmd 'silent! 2argument' end, { desc = 'Bookmark 2' })

vim.keymap.set('n', '<C-k>', function() vim.cmd 'silent! 3argument' end, { desc = 'Bookmark 3' })

vim.keymap.set('n', '<C-l>', function() vim.cmd 'silent! 4argument' end, { desc = 'Bookmark 4' })
