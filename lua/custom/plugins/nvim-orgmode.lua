vim.pack.add {
  { src = 'https://github.com/nvim-orgmode/orgmode' },
}

local baseDir = '~/Documents/Notes/orgfiles/'

require('orgmode').setup {
  org_agenda_files = baseDir .. '**/*',
  org_default_notes_file = baseDir .. 'refile.org',
  org_todo_keywords = { 'TODO', 'NEXT', 'WAITING', '|', 'DONE', 'DELEGATED' },
}
-- Experimental LSP support
vim.lsp.enable 'org'
