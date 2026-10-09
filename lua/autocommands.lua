local gr = vim.api.nvim_create_augroup('BasicAutocommands', {})

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Credits to Mini.Basics: https://github.com/nvim-mini/mini.basics/blob/main/lua/mini/basics.lua
local start_terminal_insert = vim.schedule_wrap(function(data)
  -- Try to start terminal mode only if target terminal is current
  if not (vim.api.nvim_get_current_buf() == data.buf and vim.bo.buftype == 'terminal') then return end
  vim.cmd 'startinsert'
end)
vim.api.nvim_create_autocmd('TermOpen', {
  group = gr,
  pattern = { 'term://*' },
  callback = start_terminal_insert,
  desc = 'Start builtin terminal in Insert mode',
})

-- Auto-save file when running project commands.
-- TODO: Vim has a built-in option for this that runs for :make and others: `h `
-- TODO: Save ALL files in open buffers!
local projectCommands = { 'Dotnet', 'make', 'Git' }
vim.api.nvim_create_autocmd('CmdlineLeave', {
  group = gr,
  callback = function()
    local cmd = vim.fn.getcmdline()
    cmd = vim.fn.fullcommand(cmd)
    for _, possibleMatch in ipairs(projectCommands) do
      if string.find(cmd, possibleMatch, 1) then vim.cmd 'silent! update' end
    end
  end,
})

-- turn on spell check for markdown and text file
vim.api.nvim_create_autocmd('BufEnter', {
  group = gr,
  pattern = { '*.md' },
  callback = function() vim.opt_local.spell = true end,
})

-- Automatically trim trailing whitespace.
-- WARNING: In some jank languages, like VimScript, trailing whitespace can have meaning!
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = gr,
  pattern = '*',
  command = [[%s/\s\+$//e]], -- /e to suppress errors if no matches were found.
  desc = 'Automatically trim trailing whitespace',
})

-- Don't get rid of autoindent when switching to normal mode or moving cursor.
--
-- Credits: u/dropdtech and u/catphish_ :
-- https://www.reddit.com/r/neovim/comments/1qu6060/how_can_i_disable_the_feature_that_gets_rid_of/
local function apply_ts_indent_if_blank()
  local buf = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
  if line ~= '' then return end
  -- check if indentexpr is set before evaluating
  local indentexpr = vim.bo.indentexpr
  if indentexpr == '' or indentexpr == nil then return end
  -- get indent from indentexpr (Tree-sitter or fallback)
  local old_lnum = vim.v.lnum
  vim.v.lnum = lnum
  local indent = vim.fn.eval(vim.bo.indentexpr)
  vim.v.lnum = old_lnum
  if indent > 0 then vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { string.rep(' ', indent) }) end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('$', true, false, true), 'n', true)
end
-- apply indent on InsertLeave
vim.api.nvim_create_autocmd('InsertLeave', {
  callback = apply_ts_indent_if_blank,
})
-- apply indent in insert cursor move
vim.api.nvim_create_autocmd('CursorMovedI', {
  callback = function()
    -- store the line we're leaving
    local buf = vim.api.nvim_get_current_buf()
    local prev_line = vim.b.previous_insert_line or 0
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    -- if moved, restore on previous line
    if prev_line ~= current_line and prev_line > 0 then
      local line = vim.api.nvim_buf_get_lines(buf, prev_line - 1, prev_line, false)[1]
      if line == '' then
        local old_lnum = vim.v.lnum
        vim.v.lnum = prev_line

        -- Fix by Demorome: an error here occured when doing backspace/enter around empty lines;
        -- vim.bo.indentexpr becomes "" for some reason (could be my setup).
        local indent
        local indentexpr = vim.bo.indentexpr
        if indentexpr == '' or indentexpr == nil then
          indent = 0
        else
          indent = vim.fn.eval(vim.bo.indentexpr)
        end

        vim.v.lnum = old_lnum
        if indent > 0 then vim.api.nvim_buf_set_lines(buf, prev_line - 1, prev_line, false, { string.rep(' ', indent) }) end
      end
    end
    -- store current line for future
    vim.b.previous_insert_line = current_line
  end,
})
