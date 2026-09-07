-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

vim.pack.add {
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
  -- 'https://github.com/rcarriga/nvim-dap-ui',

  'https://github.com/nvim-neotest/nvim-nio',

  'https://github.com/mason-org/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  --'https://github.com/leoluz/nvim-dap-go',
}

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<leader>dc', function() require('dap').continue() end, { desc = 'DAP Continue' })
vim.keymap.set('n', '<leader>dd', function() require('dap').toggle_breakpoint() end, { desc = 'DAP Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dx', function() require('dap').terminate() end, { desc = 'DAP Terminate' })

vim.keymap.set('n', '<C-Up>', function() require('dap').restart_frame() end, { desc = 'DAP Restart Frame' })
vim.keymap.set('n', '<C-Right>', function() require('dap').step_into() end, { desc = 'DAP Step Into' })
vim.keymap.set('n', '<C-Down>', function() require('dap').step_over() end, { desc = 'DAP Step Over' })
vim.keymap.set('n', '<C-Left>', function() require('dap').step_out() end, { desc = 'DAP Step Out' })

-- Traverse the stacktrace without stepping.
vim.keymap.set('n', '<S-Up>', function() require('dap').up() end, { desc = 'DAP Up' })
vim.keymap.set('n', '<S-Down>', function() require('dap').down() end, { desc = 'DAP Down' })

local dap = require 'dap'
local dapview = require 'dap-view'

-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<leader>dr', function() dapview.toggle() end, { desc = 'DAP Last session result' })

-- Taken from https://github.com/igorlfs/dotfiles/blob/main/nvim/.config/nvim/plugin/nvim-dap-view.lua
vim.keymap.set('n', '<A-m>', '<CMD>DapViewToggle<CR>', { desc = 'Toggle DAP UI' })
vim.keymap.set('n', '<A-v>', '<CMD>DapViewVirtualTextToggle<CR>', { desc = 'Toggle DAP Virtual Text' })

-- Mirrors how I have shift-k to see LSP hover.
vim.keymap.set({ 'n', 'x' }, '<C-k>', '<CMD>DapViewHover!<CR>', { desc = 'DAP Hover' })

require('mason-nvim-dap').setup {
  -- Makes a best effort to setup the various debuggers with
  -- reasonable debug configurations
  automatic_installation = true,

  -- You can provide additional configuration to the handlers,
  -- see mason-nvim-dap README for more information
  handlers = {},

  -- You'll need to check that you have the required things installed
  -- online, please don't ask me how to install them :)
  ensure_installed = {
    -- Update this to ensure that you have the debuggers for the langs you want
    -- 'delve',
  },
}

-- Defaults: https://igorlfs.github.io/nvim-dap-view/configuration
dapview.setup {
  winbar = {
    show_keymap_hints = true,
    sections = {
      'watches',
      'scopes',
      'exceptions',
      -- 'repl',
      'breakpoints',
      'threads',
      'console',
    },
    default_section = 'scopes',
  },
  virtual_text = {
    -- Control with `DapViewVirtualTextToggle`
    enabled = true,
    format = function(variable) return ' ' .. (variable.value:gsub('\n+', '')) end,

    -- Supported options include "inline", "eol", and "eol_right_align"
    position = 'eol',
  },
}

-- Change breakpoint icons
vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
local breakpoint_icons = vim.g.have_nerd_font
    and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
  or { breakpoint = '●', breakpointcondition = '⊜', breakpointrejected = '⊘', logpoint = '◆', stopped = '⭔' }
for type, icon in pairs(breakpoint_icons) do
  local tp = 'Dap' .. type
  local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
  vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized['dapui_config'] = dapview.open
dap.listeners.before.event_terminated['dapui_config'] = dapview.close
dap.listeners.before.event_exited['dapui_config'] = dapview.close

-- Install golang specific config
--require('dap-go').setup {
--  delve = {
--    -- On Windows delve must be run attached or it crashes.
--    -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
--    detached = vim.fn.has 'win32' == 0,
--  },
--}
