vim.pack.add({
  { src = 'https://github.com/nvim-orgmode/orgmode'}
})
require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
  org_todo_keywords = {'TODO', 'NEXT', 'WAITING', '|', 'DONE', 'DELEGATED'}
})
-- Experimental LSP support
vim.lsp.enable('org')
