-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'itchyny/lightline.vim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'}
        }
    }
    use 'scrooloose/nerdtree'
    use {'neoclide/coc.nvim', branch = 'release'}
    use 'jiangmiao/auto-pairs'
    use 'yggdroot/indentline'
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
    use 'ryanoasis/vim-devicons'
    use 'lervag/vimtex'
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
end)
