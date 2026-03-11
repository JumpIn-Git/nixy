local path = vim.fn.expand("~/.cache/noctalia/neovim.lua")
local function colors()
	require("base16-colorscheme").setup(dofile(path))
end
colors()
vim.uv.new_fs_event():start(path, {}, vim.schedule_wrap(colors))
