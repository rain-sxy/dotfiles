local function map(m, k, v)
	vim.keymap.set(m, k, v, { noremap = true, silent = true })
end

map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- windows - ctrl nav, fn resize
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<F5>", ":resize +2<CR>")
map("n", "<F6>", ":resize -2<CR>")
map("n", "<F7>", ":vertical resize +2<CR>")
map("n", "<F8>", ":vertical resize -2<CR>")

--fuzzy finding
map("n", "<leader>f", ":lua require('fzf-lua').files()<CR>") --search cwd
map("n", "<leader>Fh", ":lua require('fzf-lua').files({ cwd = '~/' })<CR>") --search home
map("n", "<leader>Fc", ":lua require('fzf-lua').files({ cwd = '~/.config' })<CR>") --search .config
map("n", "<leader>Fl", ":lua require('fzf-lua').files({ cwd = '~/.local/src' })<CR>") --search .local/src
map("n", "<leader>Ff", ":lua require('fzf-lua').files({ cwd = '..' })<CR>") --search above
map("n", "<leader>Fr", ":lua require('fzf-lua').resume()<CR>") --last search
map("n", "<leader>g", ":lua require('fzf-lua').grep()<CR>") --grep
map("n", "<leader>G", ":lua require('fzf-lua').grep_cword()<CR>") --grep word under cursor

--open netrw
map("n", "<leader>pv", ":Ex<CR>")

--linting
map("n", "<leader>e", vim.diagnostic.open_float)

--buffer
map('n', '<DS-h>', '<Cmd>BufferMovePrevious<CR>')
map('n', '<DS-l>', '<Cmd>BufferMoveNext<CR>')
map('n', '<D-1>', '<Cmd>BufferGoto 1<CR>')
map('n', '<D-2>', '<Cmd>BufferGoto 2<CR>')
map('n', '<D-3>', '<Cmd>BufferGoto 3<CR>')
map('n', '<D-4>', '<Cmd>BufferGoto 4<CR>')
map('n', '<D-5>', '<Cmd>BufferGoto 5<CR>')
map('n', '<D-6>', '<Cmd>BufferGoto 6<CR>')
map('n', '<D-7>', '<Cmd>BufferGoto 7<CR>')
map('n', '<D-8>', '<Cmd>BufferGoto 8<CR>')
map('n', '<D-9>', '<Cmd>BufferGoto 9<CR>')
map('n', '<D-0>', '<Cmd>BufferLast<CR>')
map('n', '<D-p>', '<Cmd>BufferPin<CR>')
map('n', '<D-w>', '<Cmd>BufferClose<CR>')

--fterm
map('n', '<DS-i>', '<Cmd>lua require("FTerm").toggle()<CR>')
