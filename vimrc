call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'Valloric/YouCompleteMe'
Plug 'jiangmiao/auto-pairs'
Plug 'yggdroot/indentline'
Plug 'airblade/vim-gitgutter'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
call plug#end()

" disable YCM error checking
let g:ycm_show_diagnostics_ui = 0
let g:ycm_autoclose_preview_window_after_insertion = 1

set backspace=2
set expandtab tabstop=4 softtabstop=4
set laststatus=2
set nocompatible
set noerrorbells            " disable YCM errors
set nu                      " enable line numbers
set shiftwidth=4            " for :retab
set ignorecase smartcase
set colorcolumn=100         " highlight column 100
set nofixendofline          " no newline at end of file, conform with vscode
set splitright              " open new file on right side
set signcolumn=yes          " always show sign column for gitgutter
set updatetime=100          " vim-gitgutter refresh time
set mouse=a
let g:indentLine_setConceal = 0     " prevent hiding symbols in markdown

" open fzf
noremap <c-p> :Files <Enter>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif
nnoremap <C-b> :NERDTreeToggle<CR>

" move lines up or down
nnoremap <A-down> :m .+1<CR>==
nnoremap <A-up> :m .-2<CR>==
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

" colorschemes
if (has('termguicolors'))
  set termguicolors
endif
let g:material_theme_style = 'default'
let g:airline_theme = 'material'
colorscheme material
