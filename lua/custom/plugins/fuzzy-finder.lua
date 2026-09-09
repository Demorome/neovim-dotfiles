local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Fuzzy Finder (files, lsp, etc) ]]
--
-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- There are lots of other alternative pickers (like snacks.picker, or fzf-lua)
-- so feel free to experiment and see what you like!
--
-- The easiest way to use Telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of `help_tags` options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in Telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- Telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

---@type (string|vim.pack.Spec)[]
local telescope_plugins = {
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-telescope/telescope.nvim',
  gh 'nvim-telescope/telescope-ui-select.nvim',
}
if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end

-- NOTE: You can install multiple plugins at once
vim.pack.add(telescope_plugins)

-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  -- You can put your default mappings / updates / etc. in here
  --  All the info you're looking for is in `:help telescope.setup()`
  --
  -- defaults = {
  --   mappings = {
  --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
  --   },
  -- },
  -- pickers = {}
  extensions = {
    ['ui-select'] = { require('telescope.themes').get_dropdown() },
  },
}

-- Enable Telescope extensions if they are installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'ui-select')

-- See `:help telescope.builtin`
local builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Select' }) -- select a built-in picker
vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = 'Current Word' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent Files' })
vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = 'Commands' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Buffers' })

-- Override default behavior and theme when searching
vim.keymap.set('n', '<leader>sb', function()
  -- You can pass additional configuration to Telescope to change the theme, layout, etc.
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'In Buffer' })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set(
  'n',
  '<leader>s/',
  function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end,
  { desc = 'Grep In Open Files' }
)
-- vim: ts=2 sts=2 sw=2 et
