-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
      'nvim-telescope/telescope.nvim',
      requires = {
          {'nvim-lua/plenary.nvim'},
          {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'}
      }
  }
  use 'tpope/vim-surround'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'marko-cerovac/material.nvim'
  use 'tpope/vim-commentary'
  use 'dense-analysis/ale'
  use 'projekt0n/github-nvim-theme'
  use 'nvim-lua/plenary.nvim'
  use {'lewis6991/gitsigns.nvim', config=function() require('gitsigns').setup() end }
  use 'NLKNguyen/papercolor-theme'
  use 'tpope/vim-fugitive'
  use 'kyazdani42/nvim-web-devicons'
  use 'lervag/vimtex'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'kyazdani42/nvim-tree.lua'
  use 'EdenEast/nightfox.nvim'
  -- use 'github/copilot.vim'
  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })
  use 'liuchengxu/vista.vim'
  use 'chrisbra/csv.vim'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/vim-vsnip'
  use 'hrsh7th/vim-vsnip-integ'
  use 'onsails/lspkind.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'windwp/nvim-autopairs'
  use 'SmiteshP/nvim-navic'
  use 'WhoIsSethDaniel/mason-tool-installer.nvim'
  use 'folke/trouble.nvim'
  use 'nanozuki/tabby.nvim'
  use 'mfussenegger/nvim-jdtls'
  use 'kdheepak/JuliaFormatter.vim'
  use 'nvim-treesitter/nvim-treesitter-context'
  use 'sindrets/diffview.nvim'
  use 'mrjones2014/smart-splits.nvim'
end)

local cmd = vim.cmd
cmd "au TextYankPost * silent! lua vim.highlight.on_yank({timeout = 300})"
cmd "autocmd FileType c,cpp,java setlocal commentstring=//\\ %s"

require("nvim-autopairs").setup {}

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "java", "python", "bash", "lua" },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  highlight = {
    enable = true,    
  }
}

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
}
-- Override NvimTreeFindFile with fucus = true
vim.api.nvim_create_user_command("NvimTreeFindFile", function(res)
  require("nvim-tree.api").tree.find_file { open = true, update_root = res.bang, focus = true }
end, { bang = true, bar = true })

require("mason").setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'pyright', 'clangd', 'jdtls', 'bashls' }
})
require('mason-tool-installer').setup{
  ensure_installed = { 'reorder-python-imports', 'shfmt', 'google-java-format' }
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
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
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
        return { gui = vim.bo.modified and 'italic,bold' or '' }
      end,
    }},
    lualine_c = {{ navic.get_location, cond = navic.is_available }},
    lualine_x = {'fileformat', 'filetype'},
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

require("indent_blankline").setup {
  -- for example, context is off by default, use this to turn it on
  show_current_context = true,
  show_current_context_start = false,
  -- treesitter to calculate indentation when possible
  use_treesitter=true,
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
})
vim.api.nvim_set_hl(0, 'TreesitterContextBottom', { underline=true, special="Grey" })

vim.keymap.set('n', '<C-h>', require('smart-splits').resize_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').resize_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').resize_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').resize_right)
