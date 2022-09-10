-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
    use 'wbthomason/packer.nvim'
    use 'itchyny/lightline.vim'
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
    use 'lukas-reineke/indent-blankline.nvim'
    use 'marko-cerovac/material.nvim'
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
    use 'EdenEast/nightfox.nvim'
    -- use 'github/copilot.vim'
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use 'liuchengxu/vista.vim'
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

require("nvim-tree").setup {
  git = {
    enable = true,
    ignore = false,  -- do not hide .gitignore files
    timeout = 400,
  },
}

vim.g.AutoPairsMoveCharacter = "" -- disable auto-pairs move character

-- Show the nearest method/function in the statusline
-- https://github.com/liuchengxu/vista.vim#show-the-nearest-methodfunction-in-the-statusline
vim.cmd([[
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction
set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }
]])
