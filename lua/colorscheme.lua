vim.opt.termguicolors = true
vim.g.material_theme_style = 'default'
vim.g.airline_theme = 'material'
vim.g.material_terminal_italics = 1

require('material').setup({
	contrast = {
		sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
		floating_windows = true, -- Enable contrast for floating windows
	},
})

vim.g.material_style = "darker"
vim.cmd([[
" colorscheme material
" colorscheme github_dark_default
" colorscheme PaperColor
colorscheme terafox
]])
