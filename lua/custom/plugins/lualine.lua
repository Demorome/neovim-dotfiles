vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})

require('lualine').setup({
  sections = {

    lualine_c = {
        {
          'filename',
          path = 1, --show relative path
      }
    },
    
   lualine_x = {'encoding', 'fileformat'},

    lualine_y = {'progress'},
  }
})
