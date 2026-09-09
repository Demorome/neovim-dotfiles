-- Likely redundant pack.add, but w/e.
vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

-- Note the extra space at the end of each string: it allows the symbol to 'grow'.
local diagnosticSigns = { ' ', ' ', ' ', '󰴲 ' }
-- Use $ instead of # to inherit the background of the previous highlight groups.
-- Was introduced with https://github.com/neovim/neovim/pull/37153
diagnosticSigns[1] = '%$DiagnosticError$' .. diagnosticSigns[1]
diagnosticSigns[2] = '%$DiagnosticWarning$' .. diagnosticSigns[2]
diagnosticSigns[3] = '%$DiagnosticInfo$' .. diagnosticSigns[3]
diagnosticSigns[4] = '%$DiagnosticHint$' .. diagnosticSigns[4]

-- Define generic git diff status groups, to avoid hard-coding a reliance on a plugin somewhere obscure.
vim.api.nvim_set_hl(0, "StatusDiffAdd", { link = 'DiagnosticInfo' })
vim.api.nvim_set_hl(0, "StatusDiffChange", { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, "StatusDiffDelete", { link = 'DiagnosticError' }) -- TODO: Less intense red, or no red at all?

require('mini.statusline').setup {
  use_icons = vim.g.have_nerd_font,
  content = {
    --content for active window
    -- See `:h statusline` for details on what all these weird `%# .. #' and %f/%F formatting symbols mean.
    active = function()
      local MiniStatusline = require('mini.statusline')

      local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
      local git_branch = MiniStatusline.section_git { trunc_width = 40 }

      local git_diff = function()
        if MiniStatusline.is_truncated(75) then return '' end

        local added = 0
        local changed = 0
        local removed = 0

        --- - `vim.b.minidiff_summary` is a table with the following fields:
        ---     - `source_name` - name of the active source. This is the only present field
        ---       if buffer's reference text is not (yet) set.
        ---     - `n_ranges` - number of hunk ranges (sequences of contiguous hunks).
        ---     - `add` - number of added lines.
        ---     - `change` - number of changed lines.
        ---     - `delete` - number of deleted lines.
        -- Credits to this blog post for the idea: https://tduyng.com/blog/neovim-statusline-native/
        if vim.b.minidiff_summary ~= nil then
          local summary = vim.b.minidiff_summary
          added = summary.add or 0
          changed = summary.change or 0
          removed = summary.delete or 0
        elseif vim.b.gitsigns_status_dict ~= nil then
          local summary = vim.b.gitsigns_status_dict
          added = summary.added or 0
	        changed = summary.changed or 0
	        removed = summary.removed or 0
        else
          return ''
        end

        local diff_str = ''
        	if added > 0 then
        		diff_str = diff_str .. "%$StatusDiffAdd$+" .. added
        	end
        	if changed > 0 then
        		diff_str = diff_str .. (string.len(diff_str) > 0 and ' ' or '') .. "%$StatusDiffChange$~" .. changed
        	end
        	if removed > 0 then
        		diff_str = diff_str .. (string.len(diff_str) > 0 and ' ' or '') .. "%$StatusDiffDelete$-" .. removed
        	end

        local use_icons = MiniStatusline.use_icons or MiniStatusline.config.use_icons
        local icon = use_icons and '' or 'Diff'
        return icon .. ' ' .. (diff_str == '' and '-' or diff_str)
      end

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

      local getFileNameUnexpanded = function()
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
        if MiniStatusline.is_truncated(120) or vim.bo.buftype ~= '' then return '' end
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        local format = vim.bo.fileformat
        return string.format('%s[%s]', encoding, format)
      end

      local filepathWithHighlights = function()
          -- Using $ instead of # for the highlight groups to inherit the previous BG color.
          -- Aside: did a quick research and Lua `..` string concat is probably faster than string.format, neat.
            local fileName = getFileNameUnexpanded()
            local fileDirectory = getFileDirectory()

          local result = '%$MiniStatuslineFileDirectory$' .. fileDirectory
            if vim.bo.modified ~= true then -- bo = 'Buffer Options'
                result = result .. '%$MiniStatuslineFilename$'
            else
                result = result .. '%$MiniStatuslineFilenameChanged$'
            end
            result = result .. fileName

            -- Check if there are any other unsaved buffers, and warn about it.
            local numUnsavedBuffers = 0
            local bufs = vim.api.nvim_list_bufs() -- TODO: Add a check for unloaded buffers?
            for _, buf in ipairs(bufs) do

                if buf ~= vim.api.nvim_get_current_buf() then

                        if vim.bo[buf].modified == true then
                            numUnsavedBuffers = numUnsavedBuffers + 1
                        end
                end
            end
            if numUnsavedBuffers ~= 0 then
                    result = result .. '%$Error$' .. '[!!]'

            end
          return result
      end

      local search = MiniStatusline.section_searchcount { trunc_width = 75 }

      return MiniStatusline.combine_groups {
        { hl = mode_hl, strings = { string.upper(mode) } },
        { hl = 'MiniStatuslineDevinfo', strings = { git_branch, git_diff(),
          -- Clear foreground color that might've been set in git_diff.
          '%#MiniStatuslineDevinfo#' .. diagnostics }
        },
        '%<', -- Mark general truncate point
        -- Show file's directory in grayed-out text, then filename in brighter text.
        {
          hl = nil, -- we're formatting our string with the highlight info ourselves.
          strings = { filepathWithHighlights() },
        },
        '%=', -- End left alignment
        -- Show file info in grayed-out text.
        { hl = 'MiniStatuslineDevinfo', strings = {
            '%$MiniStatuslineFileinfo$' .. fileInfo()
          }
        },
        { hl = mode_hl, strings = { search } },
      }
    end,
  },
}
