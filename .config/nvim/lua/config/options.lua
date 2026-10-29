local options = {
	smarttab = true,
	cindent = true,
	autoindent = false,
	shiftwidth = 2,
	tabstop = 2,

	showmode = false,

	number = true,
	relativenumber = true,
	numberwidth = 4,

	ttyfast = true,

	clipboard = "unnamedplus",

	termguicolors = true,

	ignorecase = true,
	smartcase = true,

	splitkeep = 'screen',
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.diagnostic.config({
	signs = false,
})
