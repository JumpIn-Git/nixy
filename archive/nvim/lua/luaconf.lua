vim.g.mapleader = " "
vim.o.winborder = "rounded"
vim.o.number = true
require("mini.icons").setup()

local path = vim.fn.expand("~/.cache/noctalia/neovim.lua")
require(path)
vim.uv.new_fs_event():start(path, {}, function()
	require(path)
end)

vim.lsp.enable({
	"lua_ls",
	"nixd",
	"nushell",
})
vim.lsp.config("lua_ls", {
	settings = {
		Lua = { workspace = {
			library = vim.api.nvim_get_runtime_file("lua", true),
		} },
	},
})
require("lazydev").setup({
	library = {
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		{ path = "${3rd}/love2d/library", words = { "love" } },
	},
})

require("mini.files").setup({ windows = { preview = true } })
require("mini.pairs").setup()
require("mini.tabline").setup()

vim.keymap.set("n", "<leader>e", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0))
end, { desc = "Open mini.files" })
vim.keymap.set("n", "<leader>E", function()
	MiniFiles.open()
end, { desc = "Open mini.files (cwd)" })

require("which-key").setup({ preset = "modern" })
require("conform").setup({
	formatters_by_ft = {
		nix = { "alejandra" },
	},
	format_on_save = true,
})

require("conform").setup({
	formatters_by_ft = {
		nix = { "alejandra" },
		lua = { "stylua" },
	},
	format_on_save = true,
})

require("fzf-lua").setup()
vim.keymap.set("n", "<leader><space>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "live_grep" })

require("blink-cmp").setup({
	keymap = { preset = "super-tab" },
	cmdline = { enabled = false },
})
