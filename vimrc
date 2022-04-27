call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'yggdroot/indentline'
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'tpope/vim-commentary'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'machakann/vim-highlightedyank'
Plug 'dominikduda/vim_current_word'
Plug 'projekt0n/github-nvim-theme'
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'tpope/vim-fugitive'
Plug 'liuchengxu/vista.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'lervag/vimtex'
call plug#end()


set backspace=2
set expandtab tabstop=4 softtabstop=4
set laststatus=2
set nocompatible
set nu                      " enable line numbers
set shiftwidth=4            " for :retab
set ignorecase smartcase
set colorcolumn=100         " highlight column 100
set nofixendofline          " no newline at end of file, conform with vscode
set splitright              " open new file on right side
set signcolumn=yes
set mouse=a
set ttimeoutlen=0           " set key code delays
let g:indentLine_setConceal = 1     " prevent hiding symbols in markdown
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
\   'sh': ['shellcheck'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8', 'reorder-python-imports'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\}
let g:ale_python_flake8_options = '--max-line-length=100'
let g:ale_python_autopep8_options = '--max-line-length 100'

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
noremap <leader>d :Gvdiffsplit<cr>
lua << EOF
  require('gitsigns').setup()
EOF

" Start of Coc configurations
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-sh', 'coc-java', 'coc-clangd']
"
" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
" End of Coc configurations

" The following requires https://github.com/ryanoasis/nerd-fonts
let g:vista_default_executive = 'coc'
let g:vista#renderer#enable_icon = 0
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
\   "function": "\uf794",
\   "variable": "\uf71b",
\  }
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

" Latex
syntax enable
let g:vimtex_syntax_conceal_disable = 1

" colorschemes
if (has('termguicolors'))
  set termguicolors
endif
let g:material_theme_style = 'default'
let g:airline_theme = 'material'
let g:material_terminal_italics = 1
colorscheme material
" colorscheme github_dark_colorblind
" colorscheme PaperColor
