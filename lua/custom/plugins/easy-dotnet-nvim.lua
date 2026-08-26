vim.pack.add( {
	--Add dependencies first, then main plugin.
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-telescope/telescope.nvim',

	'https://github.com/GustavEikaas/easy-dotnet.nvim'
})

require('easy-dotnet').setup()
