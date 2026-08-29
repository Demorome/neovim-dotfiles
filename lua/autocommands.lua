-- Update the current file when entering Terminal mode, 
-- since I've probably already forgotten to save the file.
vim.api.nvim_create_autocmd({ "TermEnter" }, {
  command = "silent! update",
})

-- Auto-save file when running project commands.
projectCommands = { "Dotnet", "make", "Git" }
vim.api.nvim_create_autocmd("CmdlineLeave", {
   callback = function()
      local cmd = vim.fn.getcmdline()
      cmd = vim.fn.fullcommand(cmd)
      for _, possibleMatch in ipairs(projectCommands) 
      do
         if (string.find(cmd, possibleMatch, 1)) then
            vim.cmd "silent! update"
         end
      end
   end
})

-- turn on spell check for markdown and text file
vim.api.nvim_create_autocmd("BufEnter", {
   pattern = { "*.md" },
   callback = function()
      vim.opt_local.spell = true
   end,
})
