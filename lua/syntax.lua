vim.opt.backspace = 'indent,eol,start' -- allow backspacing over everything in insert mode 
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.laststatus = 2
vim.opt.compatible = false
vim.opt.nu = true                	    -- enable line numbers
vim.opt.shiftwidth = 4              	-- for :retab
vim.opt.ignorecase = true
vim.opt.smartcase = true 	            -- ignore case for search
vim.opt.colorcolumn = '100'          	-- highlight column 100
vim.opt.fixendofline = false            -- no newline at end of file, conform with vscode
vim.opt.splitright = true               -- open new file on right side
vim.opt.signcolumn='yes'
vim.opt.mouse='a'
vim.opt.ttimeoutlen=0                   -- set key code delays

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
