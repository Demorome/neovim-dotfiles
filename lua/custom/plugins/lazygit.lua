vim.pack.add { 'https://github.com/kdheepak/lazygit.nvim' }

vim.keymap.set('n', '<leader>g', function() vim.cmd ':LazyGit' end, { desc = 'LazyGit' })

require 'lazygit'
