-- telescope
local builtin = require('telescope.builtin')
local keymaps_augroup = vim.api.nvim_create_augroup("dotfiles_keymaps", { clear = true })

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
vim.keymap.set("n", "<c-c>", "<cmd>NvimTreeToggle<CR>")
vim.keymap.set("n", "<c-f>", "<cmd>NvimTreeFindFile<CR>")

vim.api.nvim_create_autocmd('BufEnter', {
  group = keymaps_augroup,
  callback = function()
    if vim.fn.tabpagenr('$') == 1 and vim.fn.winnr('$') == 1 and vim.bo.filetype == 'NvimTree' then
      vim.cmd.quit()
    end
  end,
})

-- remember last opened position
vim.api.nvim_create_autocmd('BufReadPost', {
  group = keymaps_augroup,
  callback = function()
    local line = vim.fn.line([['"]])
    if line > 0 and line <= vim.fn.line('$') then
      vim.cmd.normal({ args = { [[g`"]] }, bang = true })
    end
  end,
})

-- -- Copilot
-- vim.api.nvim_set_keymap("i", "<c-[>", "<Plug>(copilot-previous)", {})
-- vim.api.nvim_set_keymap("i", "<c-]>", "<Plug>(copilot-next)", {})
-- -- Use C-J to accept, avoid collision with CoC
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

for i = 1,9,1 do
  vim.keymap.set("n", "<leader>" .. i, i .. "gt")
end

-- Search and highlight but not jump
-- https://stackoverflow.com/a/49944815/6060420
vim.cmd([[
nnoremap <silent> * :let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>
]])

-- View diagnostics at the cursor
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostics under cursor" })
