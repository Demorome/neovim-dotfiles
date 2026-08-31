local function gh(repo) return 'https://github.com/' .. repo end

-- [[ Colorscheme ]]
-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command under that to load whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.

-- Fallout terminal-themed color palette.
local palette = {
  -- UI color options from Fallout: New Vegas, mostly for inspiration.
  fnv_orange = '#ffb642',
  fnv_blue = '#2ecfff',
  fnv_green = '#1bff80',
  fnv_white = '#c0ffff',

  -- Mostly base colors from Vault theme, tweaked to remove blues and darkened in some places.
  near_black = '#0a0a00', -- near-black, warm tinted background
  amber_phosphor = '#c8b400', -- amber phosphor — primary text
  full_green = '#00ff00',
  matrix_green = '#00f000', -- Matrix green — keyword accent (≤15% of visible tokens)
  green = '#00cf00', -- Muted matrix green — keyword accent (≤15% of visible tokens)
  dim_green = '#4aa000', -- Other key accents
  dim_amber = '#5a5200', -- dim amber — comments (italic, muted)
  -- string = "#7aff00", -- brighter lime-green — strings (distinct from keyword green)
  rusty_beige = '#b78a00', -- rusty beige - strings, so they don't stand out too much
  warm_near_black_ui_bg = '#2a2800', -- warm near-black — UI chrome, floats, inactive zones

  -- Derived semantic colors (Phase 2) — stay in amber-green-black space
  amber_phosphor_dim = '#918200',
  fnv_orange_dim = '#Ff9000',
  fnv_orange_quite_dim = '#bf6e00',
  fnv_orange_very_dim = '#8c6e00', -- VERY dim, useful for grayed-out text
  warm_rust = '#cc4400', -- warm rust-red — DiagnosticError, git delete
  dim_rust = '#892d00',
  amber_orange = '#c87000', -- amber-orange — DiagnosticWarn
  muted_lime = '#7aaa00', -- muted lime — DiagnosticInfo
  dark_green = '#2a3a00', -- dark green-tinted bg — Visual, selection bg
  warm_mid_amber = '#4a4200', -- warm mid-amber bg — Search highlight bg
  pure_black = '#000000',

  -- Derived git diff tints (Phase 3) — very subtle near-black bg tints for gitsigns line/word highlights
  near_black_faint_green = '#0a1200', -- near-black, faint green cast  — GIT-02 (GitSignsAddLn)
  near_black_faint_amber = '#120f00', -- near-black, faint amber cast  — GIT-02 (GitSignsChangeLn)
  near_black_faint_rust = '#130500', -- near-black, faint rust cast   — GIT-02 (GitSignsDeleteLn)
}

vim.pack.add { gh 'rebelot/kanagawa.nvim' }
require('kanagawa').setup {
  -- NOTE: If you enable compilation, make sure to run :KanagawaCompile command every time you make changes to your config, AFTER restarting Neovim.
  compile = false, -- enable compiling the colorscheme
  undercurl = true, -- enable undercurls
  commentStyle = { italic = false, bold = false },
  functionStyle = { italic = false, bold = true }, -- make function names and calls stand out more
  keywordStyle = { italic = false, bold = false },
  statementStyle = { italic = false, bold = false },
  typeStyle = { italic = false, bold = false },
  --transparent = false, -- do not set background color
  dimInactive = true, -- dim inactive window `:h hl-NormalNC`
  terminalColors = true, -- define vim.g.terminal_color_{0,17}
  background = { -- map the value of 'background' option to a theme
    dark = 'wave',
    light = 'wave',
  },
  colors = { -- add/modify theme and palette colors
    palette = {},
    theme = {
      wave = {
        -- Override this theme to implement our Fallout terminal theme.
        ui = {
          fg = palette.amber_phosphor,
          fg_dim = palette.amber_phosphor_dim,
          fg_reverse = palette.green,

          bg_dim = palette.pure_black, -- bg when window is inactive and dimming for inactive windows is enabled
          bg_gutter = palette.near_black,

          -- bg_m3 = palette.fnv_orange, -- darkest. Affects fg color of some text in taskline (wtf?)
          -- bg_m2 = palette.fnv_orange, -- less dark
          -- bg_m1 = palette.fnv_orange, -- even less dark. No idea what this even changes.
          bg = palette.near_black,
          bg_p1 = palette.warm_near_black_ui_bg, -- even less dark x2. Affects line-limit-column-guide color and bg color of some taskline stuff.
          bg_p2 = palette.warm_near_black_ui_bg, -- even less dark x3. Affects cursor highlight color.

          special = palette.dark_green, -- was: dragongray3
          whitespace = palette.near_black_faint_green, -- least dark
          nontext = palette.dim_amber, -- least dark

          bg_visual = palette.dark_green,
          bg_search = palette.warm_mid_amber,

          -- Mostly seems to affect the completions menu.
          pmenu = {
            fg = palette.amber_phosphor, -- was: fujiWhite
            fg_sel = 'none', -- setting it to 'none' makes highlights pass-through (default).
            bg = palette.near_black,
            bg_sel = palette.near_black_faint_green, -- was: waveBlue2. 'sel' for Selection (highlight).
            bg_thumb = palette.dim_green, -- was: waveBlue2. The selection bar's thumb-dragger.
            bg_sbar = palette.near_black_faint_green, -- was: waveBlue1. The selection bar's color.
          },

          float = {
            fg = palette.amber_phosphor,
            bg = palette.near_black, -- darkest
            fg_border = palette.dim_amber,
            bg_border = palette.near_black, -- darkest
          },
        },
        syn = {
          string = palette.rusty_beige,
          variable = palette.orange_dim,
          number = palette.amber_phosphor, -- setting this to be the same as regular fg color, cuz idc
          constant = palette.amber_phosphor, -- TODO: Set a bit brighter?
          identifier = palette.amber_phosphor, -- was: dragonYellow
          parameter = palette.amber_phosphor, -- was: dragonGray
          fun = palette.fnv_orange_dim,
          statement = palette.amber_phosphor, -- was: dragonViolet. Doesn't seem to do anything, at least in C# code?
          keyword = palette.matrix_green, -- was: dragonViolet
          operator = palette.fnv_orange_quite_dim, -- was: dragonRed (more of light pink-ish orange)
          preproc = palette.dim_rust, -- was: dragonRed
          type = palette.green, -- was: dragonAqua
          regex = palette.dim_rust, -- was: dragonRed
          deprecated = palette.dim_rust, -- was: katanaGray
          punct = palette.amber_phosphor_dim,
          comment = palette.dim_amber, -- FIXME: This applies to lines with hints, making them barely visible
          special1 = palette.full_green, -- was: dragonTeal. Affects basic "Special" highlight group.
          special2 = palette.full_green, -- was: dragonRed. Affects only the "Exception" highlight group rn (try, catch, throw).
          special3 = palette.full_green, -- was: dragonRed. Affects "return" and similar constructs.
        },
        diag = {
          error = palette.warm_rust, -- was: samuraiRed
          warning = palette.amber_orange, --FIXME: This doesn't seem to apply in the statusline!
          ok = palette.green,
          info = palette.muted_lime,
          hint = palette.dim_amber,
        },
        diff = {
          -- These default 'winter' colors are subdued enough to fit the theme.
          -- add = palette.winterGreen,
          -- delete = palette.winterRed,
          change = palette.dim_green,
          text = palette.dark_green, -- NOTE: Also affects LSP highlighting.
        },
        vcs = {
          -- The default ones fit the theme well.
          -- added = palette.autumnGreen,
          -- removed = palette.autumnRed,
          -- changed = palette.autumnYellow,
        },
        term = {
          -- Mostly copied from Vault theme.
          -- Slots 0-7: normal ANSI; slots 8-15: bright variants
          -- No true blue or purple — blue/magenta slots use amber tones (GHOST-04)
          palette.near, -- black → terminal bg
          palette.warm_rust, -- red → warm rust-red
          palette.green, -- green → Matrix green
          palette.fnv_orange_dim, -- yellow → amber primary
          palette.dim_amber, -- blue slot → dim amber (in-palette)
          palette.dim_amber, -- magenta slot → dim amber (in-palette)
          palette.muted_lime, -- cyan slot → lime string green
          palette.amber_phosphor, -- white → amber fg
          palette.warm_near_black_ui_bg, -- bright black → UI chrome
          palette.warm_rust, -- bright red → warm rust-red
          palette.full_green, -- bright green
          palette.amber_phosphor, -- bright yellow → amber
          palette.dim_amber, -- bright blue → dim amber (in-palette)
          palette.dim_amber, -- bright magenta → dim amber (in-palette)
          palette.green, -- bright cyan → Matrix green
          '#e8d400', -- bright white → brighter amber
        },
      },
      lotus = {},
      dragon = {},
      all = {},
    },
  },
  overrides = function(colors) -- add/modify highlights
    return {}
  end,
  theme = 'wave', --'dragon' is pretty good, but our custom one is cooler.
}
vim.cmd 'colorscheme kanagawa'

--vim.pack.add { gh 'folke/tokyonight.nvim' }
---@diagnostic disable-next-line: missing-fields
-- require('tokyonight').setup {
--   styles = {
--     comments = { italic = false }, -- Disable italics in comments
--   },
-- }

vim.pack.add {
  'https://github.com/mrpbennett/vault',
}
--
-- require('vault').setup({
--      overrides = {
--      Comment = { italic = false }, -- Disable italics in comments
--    },
-- })
--
-- vim.cmd.colorscheme 'vault'

-- vim: ts=2 sts=2 sw=2 et
