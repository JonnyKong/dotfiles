vim.g.mapleader = " "

-- telescope
vim.api.nvim_set_keymap("n", "<c-p>", "<cmd>Telescope find_files<CR>", {})
vim.api.nvim_set_keymap("n", "<s-f>", "<cmd>Telescope live_grep<CR>", {})
-- make telescope close with single esc in insert mode
local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
            },
        },
    },
})

-- nerdtree
vim.api.nvim_set_keymap("n", "<c-b>", ":NvimTreeToggle<CR>", {})
vim.api.nvim_set_keymap("n", "<c-f>", ":NvimTreeFindFile<CR>", {})
-- exit Vim if NERDTree is the only window left
vim.api.nvim_command([[
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
]])

-- remember last opened position
vim.api.nvim_command([[
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

vim.api.nvim_set_keymap("n", "<leader>1", "1gt", {})
vim.api.nvim_set_keymap("n", "<leader>2", "2gt", {})
vim.api.nvim_set_keymap("n", "<leader>3", "3gt", {})
vim.api.nvim_set_keymap("n", "<leader>4", "4gt", {})
vim.api.nvim_set_keymap("n", "<leader>5", "5gt", {})
vim.api.nvim_set_keymap("n", "<leader>6", "6gt", {})
vim.api.nvim_set_keymap("n", "<leader>7", "7gt", {})
vim.api.nvim_set_keymap("n", "<leader>8", "8gt", {})
vim.api.nvim_set_keymap("n", "<leader>9", "9gt", {})
