local function is_meta()
  local cwd = vim.fn.getcwd()
  return cwd:find("/fbsource") ~= nil
end

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local plugins = {
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
  'NLKNguyen/papercolor-theme',
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },
  'nvim-tree/nvim-tree.lua',
  'EdenEast/nightfox.nvim',
  {
    -- https://github.com/iamcco/markdown-preview.nvim/issues/690#issuecomment-2254280534
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable "npx" then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },
  'liuchengxu/vista.vim',
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
  'nanozuki/tabby.nvim',
  'mfussenegger/nvim-jdtls',
  'nvim-treesitter/nvim-treesitter-context',
  'sindrets/diffview.nvim',
  'mrjones2014/smart-splits.nvim',
  'christoomey/vim-tmux-navigator',
  'tomasiser/vim-code-dark',
}

if not is_meta() then
  vim.list_extend(plugins, {
    'lewis6991/gitsigns.nvim',
    'tpope/vim-fugitive',
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    {
      'lervag/vimtex',
      init = function()
        vim.g.vimtex_quickfix_open_on_warning = 0
      end
    },
  })
else
  vim.list_extend(plugins, {
    'nvimtools/none-ls.nvim',
    { dir = "/usr/share/fb-editor-support/nvim", name = "meta.nvim" },
  })
end

require("lazy").setup(plugins)

local config_augroup = vim.api.nvim_create_augroup("dotfiles_config", { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = config_augroup,
  callback = function()
    vim.highlight.on_yank({ timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = config_augroup,
  pattern = { 'c', 'cpp', 'java' },
  callback = function(args)
    vim.bo[args.buf].commentstring = '// %s'
  end,
})

require("nvim-autopairs").setup {}

local ts_langs = { 'bash', 'c', 'cpp', 'java', 'lua', 'python' }
local ts_max_filesize = 100 * 1024 -- 100 KB

require("nvim-treesitter").setup {
  install_dir = vim.fn.stdpath("data") .. "/site",
}

if vim.fn.executable("tree-sitter") == 0 then
  vim.schedule(function()
    vim.notify(
      "nvim-treesitter requires the `tree-sitter` CLI to install or update parsers on the `main` branch. Install it via your package manager or `cargo install tree-sitter-cli`.",
      vim.log.levels.WARN
    )
  end)
end

vim.treesitter.language.register('bash', { 'sh', 'zsh' })

vim.api.nvim_create_autocmd('FileType', {
  group = config_augroup,
  pattern = { 'c', 'cpp', 'java', 'lua', 'python', 'sh', 'zsh' },
  callback = function(args)
    local filename = vim.api.nvim_buf_get_name(args.buf)
    local ok, stats = pcall(vim.uv.fs_stat, filename)
    if ok and stats and stats.size > ts_max_filesize then
      return
    end

    pcall(vim.treesitter.start, args.buf)
  end,
})

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

local lspkind = require('lspkind')
local cmp = require('cmp')
local feedkey = function(keys)
  vim.api.nvim_feedkeys(vim.keycode(keys), "", false)
end
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
        feedkey("<Plug>(vsnip-expand-or-jump)")
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)")
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

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufopts = { noremap = true, silent = true, buffer = args.buf }

    vim.bo[args.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
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
  end,
})

if not is_meta() then
  require('gitsigns').setup()

  require("mason").setup()
  require('mason-tool-installer').setup{
    ensure_installed = {
      'reorder-python-imports',
      'shfmt',
      'google-java-format',
      'prettier',
    }
  }

  local servers = { 'pyright', 'clangd', 'bashls', 'lua_ls', 'julials' }

  require('mason-lspconfig').setup({
    ensure_installed = servers,
    automatic_enable = false,
  })

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { 'vim' },
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  })

  for _, server in ipairs(servers) do
    if server ~= 'lua_ls' then
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    vim.lsp.enable(server)
  end
end

require('lualine').setup()

require("ibl").setup {
  indent = { char = "▏" },
  scope = { enabled = false },
}

require('tabby.tabline').use_preset('tab_only', {
  nerdfont = false,
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

vim.g.clipboard = 'osc52'

if is_meta() then
  require("meta").setup()
  require("meta.lsp")
  vim.lsp.enable({
    "fb-pyright-ls@meta",
    "pyre@meta",
    "pyre-codenav@meta",
    "wasabi@meta",
    "cppls@meta",
    "buckls@meta",
    "buck2@meta",
  })

  require("meta.hg").setup({
    signs = {
      add = {
        char = "+",
        hl = "DiffAdd",
      },
      delete = {
        char = "_",
        hl = "DiffDelete",
      },
    },
    line_blame = {
      enable = false,
      highlight = "Comment",
      prefix = string.rep(" ", 4),
    },
  })
end
