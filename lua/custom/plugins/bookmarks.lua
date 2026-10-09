vim.pack.add { 'https://github.com/otavioschwanck/arrow.nvim' }

require('arrow').setup {
  show_icons = true,
  leader_key = ';', -- Recommended to be a single key
  buffer_leader_key = 'm', -- Per Buffer Mappings
}

-- Quicker keymaps
-- Cross-buffer mappings.
vim.keymap.set('n', '<C-s>', require('arrow.persist').toggle)
vim.keymap.set('n', '<C-h>', require('arrow.persist').previous)
vim.keymap.set('n', '<C-l>', require('arrow.persist').next)

-- Per-buffer mappings
vim.keymap.set('n', 'S', function() vim.cmd 'Arrow toggle_current_line_for_buffer' end, { desc = 'Arrow: Toggle current line' })
vim.keymap.set('n', 'H', function() vim.cmd 'Arrow next_buffer_bookmark' end)
vim.keymap.set('n', 'L', function() vim.cmd 'Arrow prev_buffer_bookmark' end)
