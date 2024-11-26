return {
	"kkoomen/vim-doge",
	lazy = false,
	config = function()
		vim.g.doge_doc_standard_php = "phpdoc" -- Set the PHPDoc style
		vim.g.doge_php_settings = {
			resolve_fqn = 0, -- Enable resolving fully qualified names
		}
		vim.g.doge_enable_templates = 1
		vim.g.doge_template_path = "~/.config/nvim/templates"
		vim.api.nvim_set_keymap(
			"n",
			"<leader>nd",
			":DogeGenerate<CR>",
			{ noremap = true, silent = true, desc = "Run DogeGenerate" }
		)
		vim.cmd([[
    augroup DogeCustom
        autocmd!
        autocmd FileType php setlocal commentstring=/**\ %s */
    augroup END
]])

		_G.doge_custom = {
			generate = function()
				local line = vim.api.nvim_get_current_line()
				local func_name = string.match(line, "function%s+(%w+)%(")
				if func_name then
					vim.cmd("DogeGenerate")
					vim.cmd("normal! o[TODO:" .. func_name .. "]")
				end
			end,
		}
	end,
}
