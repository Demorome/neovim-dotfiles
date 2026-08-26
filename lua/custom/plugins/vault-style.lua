
vim.pack.add({
  'https://github.com/mrpbennett/vault'
})

require('vault').setup({
     overrides = {
     Comment = { italic = false }, -- Disable italics in comments
   },
})

vim.cmd.colorscheme 'vault'
