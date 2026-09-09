-- Load plugin modules in order.

-- Purely visual tweaks.
require 'custom.plugins.theme' -- set visual theme.
require 'kickstart.plugins.todo-comments' -- highlight TODO etc. comments

-- Enable built-in :UndoTree.
-- This is useful to view different 'branches' of changes, if we accidentally clobber our undo/redo history.
vim.cmd 'packadd nvim.undotree'
vim.keymap.set('n', '<leader>u', require('undotree').open, { desc = 'Undotree' })

require 'kickstart.plugins.gitsigns'

require 'custom.plugins.mini' -- a bunch of mini plugins
require 'kickstart.plugins.telescope' -- fuzzy-finding tools
require 'custom.plugins.lspconfig'

require 'kickstart.plugins.conform'
require 'custom.plugins.autocomplete'
require 'kickstart.plugins.treesitter'

require 'custom.plugins.debug'
require 'custom.plugins.easy-dotnet-nvim'

require 'custom.plugins.directory-viewer'

-- Load order for these shouldn't matter
require 'custom.plugins.nvim-orgmode' -- TODO: Replace with a simple markdown alternative, w/ task support?
require 'custom.plugins.lazygit' -- TODO: Replace with futigive?
require 'custom.plugins.bookmarks'

require 'kickstart.plugins.guess-indent'
require 'kickstart.plugins.indent_line'
require 'kickstart.plugins.autopairs'
require 'custom.plugins.better_quick_fix'

-- A linter can do: style enforcement, error detection, code quality checks.
require 'kickstart.plugins.lint'

-- vim: ts=2 sts=2 sw=2 et
