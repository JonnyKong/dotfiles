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
    sh = {'shfmt'},
    java = {'google_java_format'},
}
vim.g.ale_fixers["*"] = {'remove_trailing_lines', 'trim_whitespace'}
vim.g.ale_python_flake8_options = '--max-line-length=100'
vim.g.ale_python_autopep8_options = '--max-line-length 100'
