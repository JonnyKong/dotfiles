vim.g.ale_set_loclist = 0
vim.g.ale_fixers = {
    c = {'clang-format'},
    cpp = {'clang-format'},
    sh = {'shfmt'},
    java = {'google_java_format'},
    html = {'prettier'},
}
vim.g.ale_fixers["*"] = {'remove_trailing_lines', 'trim_whitespace'}
vim.g.ale_java_google_java_format_options = '--aosp'
vim.g.ale_sh_shfmt_options = '--indent 4'

-- Only run linters named in ale_linters settings.
vim.g.ale_linters_explicit = 1
