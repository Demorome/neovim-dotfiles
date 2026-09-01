local function gh(repo) return 'https://github.com/' .. repo end

-- Note the extra space for each string: it allows the icon to take more width.
local diagnosticSymbols = { ' ', ' ', ' ', '󰴲 ' }

-- See ":h diagnostic-defaults" for default diagnostic keybinds.
-- Notably, <C-w>d shows diagnostics at cursor in a floating window.
vim.diagnostic.config {
  severity_sort = true,
  underline = true, -- call attention to diagnostics
  virtual_text = false, -- disable inline diagnostics display (it usually makes for lines that are too long to read anyways)
  -- Use icons instead of the default text ("E" for Errors, etc.).
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnosticSymbols[1],
      [vim.diagnostic.severity.WARN] = diagnosticSymbols[2],
      [vim.diagnostic.severity.INFO] = diagnosticSymbols[3],
      [vim.diagnostic.severity.HINT] = diagnosticSymbols[4],
    },
  },
  update_in_insert = true,
}

local get_num_floating_windows = function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local num = 0
  for _, window in ipairs(windows) do
    if vim.api.nvim_win_get_config(window).relative ~= '' then num = num + 1 end
  end
  return num
end

-- Auto-open diagnostics popup when hovering over a line with one.
-- Only applies to Errors and Warnings; use <C-w>d for lesser diagnostics.
-- Only opens it if in Normal mode, mostly to avoid annoying pop-ups while in Insert mode.
-- Only opens if there aren't any floating windows already, to avoid drawing over stuff like floating LSP info when trying to resolve a problem (let me look at the function definition!).
Diagnostic_WindowID = nil
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  callback = function()
    -- Check for Normal mode, and if there is any floating window in the active tab.
    if string.find(vim.api.nvim_get_mode().mode, 'n', 1) then
      local numFloatingWindows = get_num_floating_windows()
      if numFloatingWindows <= 0 then
        _, Diagnostic_WindowID = vim.diagnostic.open_float(nil, {
          focus = false,
          severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
        })
      end
      return
    end
    if Diagnostic_WindowID ~= nil then
      if vim.api.nvim_win_is_valid(Diagnostic_WindowID) then vim.api.nvim_win_close(Diagnostic_WindowID, false) end
      Diagnostic_WindowID = nil
    end
  end,
})

-- TODO: If having written an error and you let the cursor settle, the error diagnostic floating window won't auto-appear due to LSP processing delay.

-- [[ LSP Configuration ]]
-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`

-- Useful status updates for LSP.
vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {
  -- TODO: Change text color to be darker, to blend in with background!
  --done_style = vim.api.nvim_get_hl()
}

--  This function gets run when an LSP attaches to a particular buffer.
--    That is to say, every time a new file is opened that is associated with
--    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
--    function will be executed to configure the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    --
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    --
    -- This may be unwanted, since they displace some of your code
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      vim.keymap.set(
        'n',
        '<leader>th',
        function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end,
        { desc = '[T]oggle Inlay [H]ints' }
      )
    end
  end,
})

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--  See `:help lsp-config` for information about keys and how to configure
---@type table<string, vim.lsp.Config>
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},

  stylua = {}, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

-- Automatically install LSPs and related tools to stdpath for Neovim
require('mason').setup {}

-- Ensure the servers and tools above are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools, you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  -- You can add other tools here that you want Mason to install
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end

-- vim: ts=2 sts=2 sw=2 et
