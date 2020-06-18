call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'flazz/vim-colorschemes'
Plug 'junegunn/fzf'
Plug 'Valloric/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" disable YCM error checking
let g:ycm_show_diagnostics_ui = 0

set backspace=2
set expandtab tabstop=4 softtabstop=4
set laststatus=2
set nocompatible
set noerrorbells
set nu
set shiftwidth=4    " for :retab
set ignorecase smartcase
set colorcolumn=100

" fzf
noremap <c-p> :Files <Enter>

" move lines up or down
nnoremap <A-down> :m .+1<CR>==
nnoremap <A-up> :m .-2<CR>==
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

colorscheme molokai
