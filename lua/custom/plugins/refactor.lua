vim.pack.add {
  'https://github.com/lewis6991/async.nvim',
  'https://github.com/theprimeagen/refactoring.nvim',
}
-- calling `require("refactoring").setup()` is not required for the plugin to work

local keymap = vim.keymap

keymap.set({ 'n', 'x' }, '<leader>lA', function()
  -- this keymap doesn't select any textobject by default, so you may need to provide one each time you use it.
  require('refactoring').select_refactor()
end, { desc = 'Refactor Actions' })
