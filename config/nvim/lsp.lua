vim.lsp.enable({
	"lua-language-server",
	"nixd",
	"nushell",
})

require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		{ path = "${3rd}/love2d/library", words = { "love" } },
	},
})
