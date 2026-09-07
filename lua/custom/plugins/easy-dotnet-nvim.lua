vim.pack.add {
  --Add dependencies first, then main plugin.
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-telescope/telescope.nvim',

  { src = 'https://github.com/GustavEikaas/easy-dotnet.nvim', version = 'feat/build-configuration' },
}

require('easy-dotnet').setup {
  managed_terminal = {
    auto_hide = false,
  },
  lsp = {
    easy_dotnet_extension_enabled = true,
    enhanced_rename = false, -- auto rename file when renaming class
  },
}

vim.keymap.set('n', '<leader>dt', '<cmd>Dotnet terminal toggle<CR>', { desc = 'Toggle Dotnet terminal' })
