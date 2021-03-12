set runtimepath^=~/.local/share/nvim/site/pack/packer/opt/nvim-lsp
set runtimepath^=~/.local/share/nvim/site/pack/packer/opt/completion-nvim

autocmd BufEnter * lua require'completion'.on_attach()

lua << EOF
vim.o.completeopt = "menuone,noinsert,noselect"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.gopls.setup{
	cmd = {"gopls", "serve"},
	capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

EOF
