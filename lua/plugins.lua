-- Load plugin modules in order.

require 'kickstart.plugins.guess-indent'
require 'kickstart.plugins.gitsigns'
require 'kickstart.plugins.which-key' -- show hints about what key combinations are possible
require 'custom.plugins.theme' -- set visual theme.
require 'kickstart.plugins.todo-comments' -- highlight TODO etc. comments

require 'custom.plugins.mini' -- a bunch of mini plugins
require 'kickstart.plugins.telescope' -- fuzzy-finding tools
require 'custom.plugins.lspconfig'

require 'kickstart.plugins.conform'
require 'custom.plugins.autocomplete'
require 'kickstart.plugins.treesitter'
require 'kickstart.plugins.debug'
require 'kickstart.plugins.indent_line'
require 'kickstart.plugins.lint'
require 'kickstart.plugins.autopairs'

require 'custom.plugins.directory-viewer'
require 'kickstart.plugins.gitsigns' -- also adds gitsigns recommended keymaps

require 'custom.plugins.easy-dotnet-nvim'

-- Load order for these shouldn't matter
require 'custom.plugins.project' -- make file searching go through entire project, instead of current subdirectory
require 'custom.plugins.nvim-orgmode'
require 'custom.plugins.lazygit'
require 'custom.plugins.bookmarks' -- adds bookmarks

-- TODO: Set up rainbow delimiters plugin

-- vim: ts=2 sts=2 sw=2 et
