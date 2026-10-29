local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin' }) --theme
Plug('nvim-lualine/lualine.nvim') --status line
Plug('nvim-tree/nvim-web-devicons') --icons for status line
Plug('nvim-treesitter/nvim-treesitter') --better syntax
Plug('mfussenegger/nvim-lint') --linter
Plug('goolord/alpha-nvim') --startup menu
Plug('windwp/nvim-autopairs') --autopairs
Plug('norcalli/nvim-colorizer.lua') --color highlight
Plug('ibhagwan/fzf-lua') --fuzzy finder
Plug('numToStr/FTerm.nvim') --floating terminal
Plug('saghen/blink.lib') --autocomplete library
Plug('saghen/blink.cmp', { ['tag'] = 'v1.*' }) --autocomplete
Plug('rafamadriz/friendly-snippets') --autocomplete snippets
Plug('romgrk/barbar.nvim') --tabs

--java minecraft mod dev
Plug('mason-org/mason.nvim')
Plug('mfussenegger/nvim-jdtls')
Plug('mfussenegger/nvim-dap')
Plug('tunaflsh/minecraft-dev.nvim')
Plug('tunaflsh/follow-md-links.nvim')
Plug('JavaHello/java-deps.nvim')

vim.call('plug#end')



require('config.keybinds')
require('config.options')
require('config.autocmd')

require('catppuccin').setup({
	transparent_background = true,
})
vim.cmd.colorscheme "catppuccin"

require('plugins.lualine')
require('plugins.treesitter')
require('plugins.nvim-lint')
require('plugins.alpha')
require('plugins.autopairs')
require('plugins.colorizer')
require('plugins.fzf-lua')
require('plugins.fterm')
require('plugins.blink')
require('plugins.barbar')

--java mod dev

require('mason').setup()

require('follow-md-links').handler = function(link)
  if vim.startswith(link, 'jdt://') then
    vim.cmd.split(vim.fn.fnameescape(link))
    return true
  end
end

local javadeps = require('java-deps')
javadeps.setup({
  keymaps = { toggle_fold = '<cr>' },
  position = 'left',
})

local mcdev = require('minecraft-dev')
local mason_dir = require('mason.settings').current.install_root_dir
local jdtls = require('jdtls')

mcdev.setup({
  statusline = vim.o.statusline,
  win_config = { win = -1, split = 'right' },
  env = {
    __NV_PRIME_RENDER_OFFLOAD = 1,
    __VK_LAYER_NV_optimus = 'NVIDIA_only',
    __GLX_VENDOR_LIBRARY_NAME = 'nvidia',
  },
  jdtls_config = {
    init_options = {
      bundles = {
        vim.fn.glob( -- :MasonInstall java-debug-adapter
          mason_dir .. '/share/java-debug-adapter/com.microsoft.java.debug.plugin-*.jar',
          true
        ),
        vim.fn.glob( -- :MasonInstall vscode-java-dependencies
          mason_dir .. '/share/vscode-java-dependency/com.microsoft.jdtls.ext.core-*.jar',
          true
        ),
      },
    },
    on_attach = function(client, bufnr)
      local command = function(name, cmd, desc)
        vim.api.nvim_buf_create_user_command(bufnr, name, cmd, { desc = desc })
      end

      command('Asmify', mcdev.asmify, 'View ASM API calls')
      command('Bytecode', mcdev.bytecode, 'View ASM bytecode')
      command('Deps', javadeps.toggle_outline, 'View dependencies')

      local map = function(lhs, rhs)
        vim.keymap.set('', lhs, rhs, { buf = bufnr })
      end

      map('gro', jdtls.organize_imports)
      map('grv', jdtls.extract_variable_all)
      map('grc', jdtls.extract_constant)
      map('grm', jdtls.extract_method)
    end,
  },
})

--lsp
vim.lsp.enable({ "lua_ls", "rust_analyzer", "qmlls", "jdtls" })
