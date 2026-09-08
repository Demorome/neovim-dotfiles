vim.pack.add { 'https://github.com/stevearc/aerial.nvim' }

local aerial = require 'aerial'
aerial.setup {
  open_automatic = function(bufnr)
    -- Enforce a minimum line count
    return vim.api.nvim_buf_line_count(bufnr) > 80
      -- Enforce a minimum symbol count
      and aerial.num_symbols(bufnr) > 4
      -- A useful way to keep aerial closed when closed manually
      and not aerial.was_closed()
  end,

  close_automatic_events = {
    'unsupported',
    'unfocus',
  },

  layout = {
    max_width = { 20, 0.15 },
    default_direction = 'prefer_right',
    -- Determines where the aerial window will be opened
    --   edge   - open aerial at the far right/left of the editor
    --   window - open aerial to the right/left of the current window
    placement = 'window',

    -- When the symbols change, resize the aerial window (within min/max constraints) to fit
    resize_to_content = true,

    -- Preserve window size equality with (:help CTRL-W_=)
    preserve_equality = false,
  },

  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}

vim.keymap.set('n', '<leader>es', '<cmd>AerialToggle!<CR>', { desc = 'Side view' })
