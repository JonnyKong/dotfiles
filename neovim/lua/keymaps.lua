vim.g.mapleader = " "

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set("n", "<c-p>", builtin.find_files, {})
vim.keymap.set("n", "<s-f>", builtin.live_grep, {})
vim.keymap.set("n", "<s-c>", builtin.colorscheme, {})
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

-- nvimtree
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

-- -- Copilot
-- vim.api.nvim_set_keymap("i", "<c-[>", "<Plug>(copilot-previous)", {})
-- vim.api.nvim_set_keymap("i", "<c-]>", "<Plug>(copilot-next)", {})
-- -- Use C-J to accept, avoid collision with CoC
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

for i = 1,9,1 do
  vim.api.nvim_set_keymap("n", "<leader>" .. i, i .. "gt", {})
end

-- Search and highlight but not jump
-- https://stackoverflow.com/a/49944815/6060420
vim.cmd([[
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>
]])

-- trouble.nvim
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
