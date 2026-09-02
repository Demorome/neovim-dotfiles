local gr = vim.api.nvim_create_augroup('BasicAutocommands', {})

-- Update the current file when entering Terminal mode,
-- since I've probably already forgotten to save the file.
vim.api.nvim_create_autocmd({ 'TermEnter' }, {
  group = gr,
  command = 'silent! update',
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
