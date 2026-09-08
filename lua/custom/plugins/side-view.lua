vim.pack.add { 'https://github.com/stevearc/aerial.nvim' }

require('aerial').setup {
  open_automatic = true,

  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}

vim.keymap.set('n', '<leader>es', '<cmd>AerialToggle!<CR>', { desc = 'Side view' })
