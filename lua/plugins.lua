-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use { 'feline-nvim/feline.nvim', branch = '0.5-compat' }
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'}
        }
    }
    use 'tpope/vim-surround'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'jiangmiao/auto-pairs'
    use "lukas-reineke/indent-blankline.nvim"
    use {'kaicataldo/material.vim', branch = 'main'}
    use 'tpope/vim-commentary'
    use 'dense-analysis/ale'
    use 'editorconfig/editorconfig-vim'
    use 'dominikduda/vim_current_word'
    use 'projekt0n/github-nvim-theme'
    use 'nvim-lua/plenary.nvim'
    use {'lewis6991/gitsigns.nvim', config=function() require('gitsigns').setup() end }
    use 'NLKNguyen/papercolor-theme'
    use 'tpope/vim-fugitive'
    use 'liuchengxu/vista.vim'
    use 'kyazdani42/nvim-web-devicons'
    use 'lervag/vimtex'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use 'kyazdani42/nvim-tree.lua'
    use "EdenEast/nightfox.nvim"
end)

local cmd = vim.cmd
cmd "au TextYankPost * silent! lua vim.highlight.on_yank({timeout = 300})"
vim.g.tex_conceal = ""
vim.g["vim_current_word#highlight_current_word"] = 0

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "java", "python", "bash" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    enable = true,    
  }
}

require('feline').setup()
require("nvim-tree").setup()
