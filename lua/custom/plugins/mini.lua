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
      --['@parameter.outer'] = 'v', -- charwise
      --['@function.outer'] = 'V', -- linewise
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

-- ... and there is more!
--  Check out: https://github.com/nvim-mini/mini.nvim

-- vim: ts=2 sts=2 sw=2 et
