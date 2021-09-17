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
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'psliwka/vim-smoothie'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'dominikduda/vim_current_word'
Plug 'projekt0n/github-nvim-theme'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
call plug#end()


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
set signcolumn=yes
set mouse=a
let g:indentLine_setConceal = 1     " prevent hiding symbols in markdown
let g:ycm_confirm_extra_conf = 0    " do not prompt user to load YCM configs
let g:ycm_show_diagnostics_ui = 0   " disable YCM error checking to reduce conflict with syntastic
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:tex_conceal = ""
let g:smoothie_enabled = 1
let g:highlightedyank_highlight_duration = 150
let g:vim_current_word#highlight_current_word = 0

" ale
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'c': ['clangd'],
\   'cpp': ['clangd'],
\}

" open fzf
noremap <c-p> :Files <Enter>

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
            \ quit | endif
nnoremap <C-b> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Remember last opened location
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" move lines up or down
nnoremap <A-down> :m .+1<CR>==
nnoremap <A-up> :m .-2<CR>==
inoremap <A-down> <Esc>:m .+1<CR>==gi
inoremap <A-up> <Esc>:m .-2<CR>==gi
vnoremap <A-down> :m '>+1<CR>gv=gv
vnoremap <A-up> :m '<-2<CR>gv=gv

" Go to tab by number
let mapleader = " "
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
noremap gd :YcmC GoToDefinition<cr>
lua << EOF
  require('gitsigns').setup()
EOF

" colorschemes
if (has('termguicolors'))
  set termguicolors
endif
let g:material_theme_style = 'darker'
let g:airline_theme = 'material'
let g:material_terminal_italics = 1
" colorscheme material
colorscheme github_dark
