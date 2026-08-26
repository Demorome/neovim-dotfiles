-- Enable faster startup by caching compiled Lua modules
vim.loader.enable()

vim.opt.wrap = false

-- Enable break indent
-- Only relevant if line wrap is enabled
vim.o.breakindent = true

vim.opt.tabstop = 4 -- tab width
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- no idea?
vim.opt.expandtab = true -- use spaces instead of tab
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Folding options
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 4

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
--  See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- Enable undo/redo changes even after closing and reopening a file
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true --show matches as you type

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'
vim.opt.colorcolumn = "100" --show a column to discourage long lines

--vim.opt.cmdheight = 1
--vim.opt.pumheight = 5

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10
vim.opt.sidescrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Automatically change working dir to folder for the active file.
vim.opt.autochdir = true

-- vim: ts=2 sts=2 sw=2 et
