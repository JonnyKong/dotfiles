local config = {
    cmd = { vim.fn.stdpath('data') .. '/mason/packages/jdtls/bin/jdtls' },
    root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }) or vim.fn.getcwd(),
}
require('jdtls').start_or_attach(config)
