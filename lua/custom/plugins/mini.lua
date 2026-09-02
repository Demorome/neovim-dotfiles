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
--
--  See `:h MiniAi-builtin-textobjects` for more, like going around a function call.
local gen_spec = require('mini.ai').gen_spec
require('mini.ai').setup {
  -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  custom_textobjects = {
    -- Tweak argument to be recognized only inside `()` between `;`
    --a = gen_spec.argument({ brackets = { '%b()' }, separator = ';' }),

    -- Tweak function call to not detect dot in function name
    f = gen_spec.function_call { name_pattern = '[%w_]' },

    -- Function definition (needs treesitter queries with these captures)
    F = gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, { use_nvim_treesitter = true }),

    -- Make `|` select both edges in non-balanced way
    -- ['|'] = gen_spec.pair('|', '|', { type = 'non-balanced' }),
  },
  n_lines = 500,
}

-- More advanced textobjects, based on treesitter queries.
vim.pack.add { 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects' }
require('nvim-treesitter-textobjects').setup {
  select = {
    -- Automatically jump forward to textobj, similar to targets.vim
    lookahead = true,
    -- You can choose the select mode (default is charwise 'v')
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * method: eg 'v' or 'o'
    -- and should return the mode ('v', 'V', or '<c-v>') or a table
    -- mapping query_strings to modes.
    selection_modes = {
      ['@parameter.outer'] = 'v', -- charwise
      ['@function.outer'] = 'V', -- linewise
      -- ['@class.outer'] = '<c-v>', -- blockwise
    },
    -- If you set this to `true` (default is `false`) then any textobject is
    -- extended to include preceding or succeeding whitespace. Succeeding
    -- whitespace has priority in order to act similarly to eg the built-in
    -- `ap`.
    --
    -- Can also be a function which gets passed a table with the keys
    -- * query_string: eg '@function.inner'
    -- * selection_mode: eg 'v'
    -- and should return true of false
    include_surrounding_whitespace = false,
  },
}

-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set(
  { 'x', 'o' },
  'af',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
  { desc = 'Around [F]unction' }
)
vim.keymap.set(
  { 'x', 'o' },
  'if',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
  { desc = 'Inside [F]unction' }
)
vim.keymap.set(
  { 'x', 'o' },
  'ac',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
  { desc = 'Around [C]lass' }
)
vim.keymap.set(
  { 'x', 'o' },
  'ic',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
  { desc = 'Inside [C]lass' }
)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set(
  { 'x', 'o' },
  'as',
  function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,
  { desc = 'Around [S]cope' }
)

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require('mini.surround').setup()

local diagnosticSigns = { ' ', ' ', ' ', '󰴲 ' }
diagnosticSigns[1] = '%#DiagnosticError#' .. diagnosticSigns[1]
diagnosticSigns[2] = '%#DiagnosticWarning#' .. diagnosticSigns[2]
diagnosticSigns[3] = '%#DiagnosticInfo#' .. diagnosticSigns[3]
diagnosticSigns[4] = '%#DiagnosticHint#' .. diagnosticSigns[4]

local statusline = require 'mini.statusline'
if vim.g.colors_name == 'kanagawa' then
  -- Override highlight groups to better fit this theme.
  -- NOTE: That theme was overriden to house my Fallout theme.
  vim.api.nvim_set_hl(0, 'MiniStatuslineFileDirectory', { fg = '#5a5200', bg = '#2a2800' })
  vim.api.nvim_set_hl(0, 'MiniStatuslineFilename', { fg = '#c8b400', bg = '#2a2800', bold = true })
  vim.api.nvim_set_hl(0, 'MiniStatuslineFileinfo', { fg = '#5a5200', bg = '#2a2800' })
end
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  content = {
    --content for active window
    -- See `:h statusline` for details on what all these weird `%# .. #' and %f/%F formatting symbols mean.
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git = MiniStatusline.section_git { trunc_width = 40 }
      local diff = MiniStatusline.section_diff { trunc_width = 75 }
      local diagnostics = MiniStatusline.section_diagnostics {
        trunc_width = 75,
        signs = { ERROR = diagnosticSigns[1], WARN = diagnosticSigns[2], INFO = diagnosticSigns[3], HINT = diagnosticSigns[4] },
      }
      -- local lsp           = MiniStatusline.section_lsp({ trunc_width = 75 })
      local getFileDirectory = function()
        -- In terminal, don't show a directory.
        if vim.bo.buftype == 'terminal' then
          return ''
        elseif !MiniStatusline.is_truncated(120) then
          -- Show full directory, with home dir shortened to '~/'
          return vim.fn.expand '%:p:~:h' .. '/'
        else
          -- Use fullpath if not truncated
          return vim.fn.expand '%:h' .. '/'
        end
      end

      local getFileName = function()
        -- In terminal, always use plain name.
        if vim.bo.buftype == 'terminal' then
          return '%t'
        else
          -- '%t' for filename, '%m' for Modified flag, '%r' for Readonly flag (shows [RO] if readonly)
          return '%t%m%r'
        end
      end

      local fileInfo = function()
        -- Return empty string if truncated or buffer is not normal.
        if MiniStatusline.is_truncated(120) or vim.bo.buftype ~= '' then return end
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        local format = vim.bo.fileformat
        return string.format('%s[%s]', encoding, format)
      end

      local filepathWithHighlights = function()
            -- Aside: did a quick research and Lua `..` string concat is probably faster than string.format, neat.
          local result = '%#MiniStatuslineFileDirectory#' .. getFileDirectory() .. '%#MiniStatuslineFilename#' .. getFileName()
          return result
      end

      -- Set cursor location to LINE:COLUMN
      local location = function() return '%2l:%-2v' end
      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { string.upper(mode) } },
        { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics } },
        '%<', -- Mark general truncate point
        -- Show file's directory in grayed-out text, then filename in brighter text.
        {
          hl = nil,
          strings = { filepathWithHighlights() },
        },
        '%=', -- End left alignment
        -- Show file info in grayed-out text.
        { hl = 'MiniStatuslineFileinfo', strings = { fileInfo() } },
        { hl = mode_hl, strings = { search, location() } },
      }
    end,
  },
}

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- vim: ts=2 sts=2 sw=2 et
