-- import none-ls plugin safely
local setup, none_ls = pcall(require, "none-ls")
if not setup then
	return
end

-- for conciseness
local formatting = none_ls.builtins.formatting -- to setup formatters
local diagnostics = none_ls.builtins.diagnostics -- to setup linters

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- configure none-ls
none_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes = {}})" (see none-ls docs)
		formatting.prettier, -- js/ts formatter
		-- golang formatter
		formatting.gofumpt,

		-- c# formatter
		formatting.csharpier,

		-- python formatter
		formatting.black,
		formatting.isort,
		-- c/c++ formatter
		formatting.clang_format,

		formatting.stylua, -- lua formatter
		require("none-ls.diagnostics.eslint_d"),
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use none-ls for formatting instead of lsp server
							return client.name == "none-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
