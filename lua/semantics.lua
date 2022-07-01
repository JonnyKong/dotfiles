vim.g.ale_set_loclist = 0
vim.g.ale_set_quickfix = 1
vim.g.ale_linters = { 
    python = {'flake8'},
    c = {'clangd'},
    cpp = {'clangd'},
    sh = {'shellcheck'},
}
vim.g.ale_fixers = {
    python = {'autopep8', 'reorder-python-imports'},
    c = {'clang-format'},
    cpp = {'clang-format'},
    sh = {'shfmt'}
}
vim.g.ale_fixers["*"] = {'remove_trailing_lines', 'trim_whitespace'}
vim.g.ale_python_flake8_options = '--max-line-length=100'
vim.g.ale_python_autopep8_options = '--max-line-length 100'

-- Start of Coc configurations
vim.cmd([[
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50
let g:coc_global_extensions = ['coc-pyright', 'coc-json', 'coc-sh', 'coc-java', 'coc-clangd']

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
]])
-- End of Coc configurations
