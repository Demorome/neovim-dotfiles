local function gh(repo) return 'https://github.com/' .. repo end

-- [[ mini.nvim ]]
--  A collection of various small independent plugins/modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }

-- If a nerd font is available, load the icons module for pretty icons in various plugins.
if vim.g.have_nerd_font then
  require('mini.icons').setup()
  -- Used for backwards compatibility with plugins that require `nvim-web-devicons` (e.g. telescope.nvim)
  MiniIcons.mock_nvim_web_devicons()
end

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

local statusline = require 'mini.statusline'
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  content = {
    --content for active window
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics {
        trunc_width = 75,
        signs = { ERROR = '!', WARN = '?', INFO = '@', HINT = '*' },
      }
      -- local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      --local filename = MiniStatusline.section_filename { trunc_width = 140 }
      local getFileDirectory = function()
        if !MiniStatusline.is_truncated(120) then
          -- Show full directory, with home dir shortened to '~/'
          return vim.fn.expand '%:p:~:h' .. '/'
        else
          -- Show relative directory.
          return vim.fn.expand '%:h' .. '/'
        end
      end
      -- local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
      local fileInfo = function()
          -- Return empty string if truncated or buffer is not normal.
          if MiniStatusline.is_truncated(120) or vim.bo.buftype ~= '' then
        return
        end
          local encoding = vim.bo.fileencoding or vim.bo.encoding
          local format = vim.bo.fileformat
          return string.format("%s[%s]", encoding, format)
      end
      local location = MiniStatusline.section_location { trunc_width = 75 }
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { string.upper(mode) } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
        '%<', -- Mark general truncate point
        -- Show file's directory in grayed-out text.
        { hl = 'MiniStatuslineFilename', strings = { getFileDirectory() } },
        -- Show filename in brighter text.
        -- TODO: Convince plugin author to allow overriding spacing here, since two spaces are currently introduced.
        { hl = 'MiniStatuslineFileinfo', strings = { vim.fn.expand '%:t' } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileInfo() } },
        { hl = mode_hl, strings = { search, location } },
      }
    end,
  },
}

-- You can configure sections in the statusline by overriding their
-- default behavior. For example, here we set the section for
-- cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- vim: ts=2 sts=2 sw=2 et
