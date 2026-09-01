-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Disable copying for simple deletions.
-- Credits to this blog post for this trick: https://vale.rocks/posts/neovim
vim.keymap.set({ 'n', 'v' }, 'x', '"_x')
vim.keymap.set({ 'n', 'v' }, 'X', '"_X')

-- Quick-saving keybind.
-- Calling update has the advantage of not doing anything if the file wasn't changed.
vim.keymap.set('n', '<leader>w', '<cmd>:echo "Saved file (no changes)"<CR><cmd>:update<CR>', { desc = 'Save the file' })

--  Map CTRL+Z to undo.
vim.keymap.set('n', '<C-z>', 'u')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open location [Q]uickfix list' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist, { desc = 'Open [Q]uickfix list' })
-- "h: cope" (unironically)
vim.keymap.set('n', '<leader>e', '<cmd>cope<CR>/error', { desc = 'Open [E]rrors quickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.keymap.set('', '<leader>y', '"+y', { desc = 'Yank to clipboard' }) -- E.g: <leader>yy will yank current line to os clipboard
vim.keymap.set('', '<leader>Y', '"+y$', { desc = 'Yank until EOL to clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste after cursor from clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste before cursor from clipboard' })

-- vim: ts=2 sts=2 sw=2 et
