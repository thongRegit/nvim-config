return {
	"windwp/nvim-ts-autotag",
	event = "InsertEnter",
	config = function()
		require("nvim-ts-autotag").setup({
			autotag = {
				enable = true, -- Enable auto-tagging
			},
			-- Apply auto-tagging to these file types
			filetypes = {
				"html", -- HTML files
				"javascript", -- JavaScript files
				"javascriptreact", -- React JSX
				"typescript", -- TypeScript files
				"typescriptreact", -- React TSX
				"vue", -- Vue files
				"php", -- PHP files
				"blade", -- Laravel Blade templates
				"xml", -- XML files
				"markdown", -- Markdown files
				"svelte", -- Svelte files
			},
			-- Skip auto-renaming these tags
			skip_tags = {
				"area",
				"base",
				"br",
				"col",
				"command",
				"embed",
				"hr",
				"img",
				"slot",
				"input",
				"keygen",
				"link",
				"meta",
				"param",
				"source",
				"track",
				"wbr",
				"menuitem",
			},
		})
	end,
}
