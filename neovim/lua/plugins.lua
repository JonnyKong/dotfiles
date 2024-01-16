-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("lazy").setup({
  'nvim-telescope/telescope.nvim',
  {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  'tpope/vim-surround',
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
  'marko-cerovac/material.nvim',
  'tpope/vim-commentary',
  'dense-analysis/ale',
  'projekt0n/github-nvim-theme',
  'nvim-lua/plenary.nvim',
  'lewis6991/gitsigns.nvim',
  'NLKNguyen/papercolor-theme',
  'tpope/vim-fugitive',
  'kyazdani42/nvim-web-devicons',
  'lervag/vimtex',
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
  },
  'kyazdani42/nvim-tree.lua',
  'EdenEast/nightfox.nvim',
  {
     "iamcco/markdown-preview.nvim",
     build = "cd app && npm install",
     ft = { "markdown" },
     config = function()
       vim.g.mkdp_filetypes = { "markdown" }
     end,
  },
  'liuchengxu/vista.vim',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'neovim/nvim-lspconfig',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/vim-vsnip',
  'hrsh7th/vim-vsnip-integ',
  'onsails/lspkind.nvim',
  'nvim-lualine/lualine.nvim',
  'windwp/nvim-autopairs',
  'SmiteshP/nvim-navic',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  'folke/trouble.nvim',
  'nanozuki/tabby.nvim',
  'mfussenegger/nvim-jdtls',
  'kdheepak/JuliaFormatter.vim',
  'nvim-treesitter/nvim-treesitter-context',
  'sindrets/diffview.nvim',
  'mrjones2014/smart-splits.nvim',
  'christoomey/vim-tmux-navigator',
  'lervag/vimtex',
})

local cmd = vim.cmd
cmd "au TextYankPost * silent! lua vim.highlight.on_yank({timeout = 300})"
cmd "autocmd FileType c,cpp,java setlocal commentstring=//\\ %s"

require("nvim-autopairs").setup {}

require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "java", "python", "bash", "lua" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    enable = true,    
  },
  disable = function(lang, buf)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    if ok and stats and stats.size > max_filesize then
      return true
    end
  end,
}

require('gitsigns').setup()

require("nvim-tree").setup {
  git = {
    enable = true,
    ignore = false,  -- do not hide .gitignore files
    timeout = 400,
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        folder_arrow = true,
      },
    },
  },
  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
  },
  view = {
    width = 45,
  },
}
-- Override NvimTreeFindFile with fucus = true
vim.api.nvim_create_user_command("NvimTreeFindFile", function(res)
  require("nvim-tree.api").tree.find_file { open = true, update_root = res.bang, focus = true }
end, { bang = true, bar = true })

require("mason").setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'pyright',
    'clangd',
    'jdtls',
    'bashls',
  }
})
require('mason-tool-installer').setup{
  ensure_installed = {
    'reorder-python-imports',
    'shfmt',
    'google-java-format',
    'prettier',
  }
}

local lspkind = require('lspkind')
local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format(),
  },
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local navic = require('nvim-navic')

-- Set up lspconfig.
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

-- Set LSP key bindings globally so they also apply to nvim-jdtls
-- See `:help vim.lsp.*` for documentation on any of the below functions
local bufopts = { noremap=true, silent=true, buffer=bufnr }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<S-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

for _, ls in ipairs({ "pyright", "clangd", "bashls", "julials" }) do
    require('lspconfig')[ls].setup{ on_attach = on_attach }
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {{
      'filename',
      color = function(section)
        return { gui = vim.bo.modified and 'bold' or '' }
      end,
    }},
    lualine_c = {},
    lualine_x = {'branch', 'fileformat', 'filetype'},
    lualine_y = {'location'},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {{
      'filename',
      color = function(section)
        return { gui = vim.bo.modified and 'italic,bold' or '' }
      end,
    }},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

require("ibl").setup {
  indent = { highlight = highlight, char = "▏" },
  scope = { enabled = false },
}

require("trouble").setup{}

require('tabby.tabline').use_preset('tab_only', {
  theme = {
    fill = 'Visual', -- tabline background
    head = 'StatusLine', -- head element highlight
    tab = 'StatusLine', -- other tab label highlight
    win = 'StatusLine', -- window highlight
    tail = 'StatusLine', -- tail element highlight
  },
  nerdfont = false,
  buf_name = {
      mode = "'unique'|'relative'|'tail'|'shorten'",
  },
})

require('treesitter-context').setup({
    mode = 'topline',
    multiline_threshold = 1,
})
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline=true, special="Grey" })

vim.keymap.set('n', '<S-Left>', require('smart-splits').resize_left)
vim.keymap.set('n', '<S-Down>', require('smart-splits').resize_down)
vim.keymap.set('n', '<S-Up>', require('smart-splits').resize_up)
vim.keymap.set('n', '<S-Right>', require('smart-splits').resize_right)
