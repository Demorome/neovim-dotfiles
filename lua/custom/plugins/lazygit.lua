vim.pack.add { 'https://github.com/kdheepak/lazygit.nvim' }

vim.keymap.set('n', '<leader>gg', function() vim.cmd ':LazyGit' end, { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>lg', function() vim.cmd ':LazyGit' end, { desc = 'LazyGit' })

require 'lazygit'
