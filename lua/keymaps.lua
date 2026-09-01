-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Useful plugin to show you pending keybinds.
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }
local miniclue = require 'mini.clue'
miniclue.setup {
  window = {
    delay = 0,
  },
  triggers = {
    -- Leader triggers
    { mode = { 'n', 'x' }, keys = '<Leader>' },

    -- `[` and `]` keys
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = { 'n', 'x' }, keys = 'g' },

    -- Marks
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },

    -- Registers
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups.
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
    { mode = 'n', keys = '<Leader>s', desc = '+Search' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+Language' },
    -- { mode = 'n', keys = '<Leader>m', desc = '+Map' },
    { mode = 'n', keys = '<Leader>o', desc = '+Other' },
    -- { mode = 'n', keys = '<Leader>s', desc = '+Session' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
    -- { mode = 'n', keys = '<Leader>v', desc = '+Visits' },

    { mode = 'x', keys = '<Leader>g', desc = '+Git' },
    { mode = 'x', keys = '<Leader>l', desc = '+Language' },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
}

-- Some keymaps from MiniMax: https://github.com/nvim-mini/MiniMax/blob/main/configs/nvim-0.13/plugin/20_keymaps.lua
vim.keymap.set('n', '[p', '<Cmd>exe "iput! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set('n', ']p', '<Cmd>exe "iput "  . v:register<CR>', { desc = 'Paste Below' })

-- t is for 'Toggle' (and toggleterm / toggling terminals).
vim.keymap.set('n', '<leader>tT', '<Cmd>horizontal term<CR>', { desc = 'Terminal (horizontal)' })
vim.keymap.set('n', '<leader>tt', '<Cmd>vertical term<CR>', { desc = 'Terminal (vertical)' })

-- e is for 'Explore' and 'Edit'.
--
-- I think the location list is more intended for manually inserted / grep'd lines?
vim.keymap.set('n', '<leader>eQ', vim.diagnostic.setloclist, { desc = 'Location [Q]uickfix list' })

-- TIP: use `:colder` and `:cnewer` to manage multiple error list
-- WARN: This replaces the current error quick-fix list with the latest diagnostics (i.e. replaces compilation failure errors).
-- This should rarely matter, unless you're building in a different configuration than the diagnostics is parsing for.
vim.keymap.set('n', '<leader>eq', vim.diagnostic.setqflist, { desc = 'Diagnostics [Q]uickfix list' })

local explore_quickfix = function()
  -- `h: cope` (unironically)
  vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and 'cclose' or 'copen')
end

vim.keymap.set('n', '<leader>ee', explore_quickfix, { desc = '[E]rrors quickfix list' })
vim.keymap.set('n', '<leader>ed', '<Cmd>lua MiniFiles.open()<CR>', { desc = 'Directory' })
vim.keymap.set('n', '<leader>ef', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', { desc = 'File directory' })

-- l is for 'Language'. Common usage:
-- - `<Leader>ld` - show more diagnostic details in a floating window
-- - `<Leader>lr` - perform rename via LSP
-- - `<Leader>ls` - navigate to source definition of symbol under cursor
--
-- NOTE: most LSP mappings represent a more structured way of replacing built-in
-- LSP mappings (like `:h gra` and others). This is needed because `gr` is mapped
-- by an "replace" operator in 'mini.operators' (which is more commonly used).
-- Also it's more intuitive and discoverable, personally.
vim.keymap.set('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions' })
vim.keymap.set('n', '<leader>ld', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Diagnostic popup' })
vim.keymap.set({ 'n', 'v' }, '<leader>lf', function() require('conform').format { async = true } end, { desc = 'Format buffer' })
vim.keymap.set('n', '<leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>', { desc = 'Implementation' })
vim.keymap.set('n', '<leader>lh', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Hover' })
vim.keymap.set('n', '<leader>ll', '<Cmd>lua vim.lsp.codelens.run()<CR>', { desc = 'Lens' })
vim.keymap.set('n', '<leader>lr', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename' })
vim.keymap.set('n', '<leader>lR', '<Cmd>lua vim.lsp.buf.references()<CR>', { desc = 'References' })
vim.keymap.set('n', '<leader>ls', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Source definition' })
vim.keymap.set('n', '<leader>lt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Type definition' })

vim.keymap.set('x', '<leader>lf', '<Cmd>lua require("conform").format()<CR>', { desc = 'Format selection' })

-- Non-leader shortcut for toggling LSP hover.
vim.keymap.set('n', 'K', function()
  vim.lsp.buf.hover {
    max_width = 80,
    max_height = 20,
    --border = 'rounded',  -- or 'single', 'double', 'solid', 'shadow', none'
  }
end, { desc = 'LSP Info (Function docs, etc.)' })

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

--vim.keymap.set('', '<leader>y', '"+y', { desc = 'Yank to clipboard' }) -- E.g: <leader>yy will yank current line to os clipboard
vim.keymap.set('', '<leader>Y', '"+y$', { desc = 'Yank until EOL to clipboard' })
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste after cursor from clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste before cursor from clipboard' })

-- Paste linewise before/after current line
-- Usage: `yiw` to yank a word and `]p` to put it on the next line.
-- Taken from MiniMax.
vim.keymap.set('n', '[p', '<Cmd>exe "iput! " . v:register<CR>', { desc = 'Paste Above' })
vim.keymap.set('n', ']p', '<Cmd>exe "iput "  . v:register<CR>', { desc = 'Paste Below' })

-- vim: ts=2 sts=2 sw=2 et
