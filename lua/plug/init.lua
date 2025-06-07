-- make sure vim plug is installed --
local data_dir = vim.fn.stdpath('data')
if vim.fn.empty(vim.fn.glob(data_dir .. '/site/autoload/plug.vim')) == 1 then
  vim.cmd('silent !curl -fLo ' .. data_dir .. '/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
  vim.o.runtimepath = vim.o.runtimepath
  vim.cmd('autocmd VimEnter * PlugInstall --sync | source $MYVIMRC')
end

local vim = vim
local Plug = vim.fn['plug#']

vim.diagnostic.config({
    virtual_lines = true
})

-- plugins
vim.call('plug#begin')
    -- installed color schemes --
    Plug('EdenEast/nightfox.nvim')
    Plug('comfysage/evergarden')
    Plug('folke/tokyonight.nvim')

    -- lualine --
    Plug('nvim-lualine/lualine.nvim')

    -- indent blankline --
    Plug('lukas-reineke/indent-blankline.nvim')

    -- undo tree --
    Plug 'mbbill/undotree'

    -- mason (and recommended packages for mason to work well) --
    Plug('mfussenegger/nvim-jdtls')
    Plug('williamboman/mason.nvim')
    Plug('williamboman/mason-lspconfig.nvim')
    Plug('neovim/nvim-lspconfig')
    Plug('mfussenegger/nvim-dap')
    Plug('nvim-neotest/nvim-nio')
    Plug('rcarriga/nvim-dap-ui')
    Plug('leoluz/nvim-dap-go')
    Plug('theHamsta/nvim-dap-virtual-text')
    Plug('mfussenegger/nvim-lint')
    Plug('mhartington/formatter.nvim')

    -- treesitter --
    Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
    Plug('nvim-treesitter/nvim-treesitter-refactor')

    -- telescope --
    Plug('nvim-lua/plenary.nvim')
    Plug('nvim-telescope/telescope.nvim')

    -- nvim-cmp --
    Plug('hrsh7th/cmp-nvim-lsp')
    Plug('hrsh7th/cmp-buffer')
    Plug('hrsh7th/cmp-path')
    Plug('hrsh7th/cmp-cmdline')
    Plug('hrsh7th/nvim-cmp')
    --  For vsnip users.
    Plug('hrsh7th/cmp-vsnip')
    Plug('hrsh7th/vim-vsnip')

    -- harpoon --
    Plug('ThePrimeagen/harpoon', { ['branch'] = 'harpoon2', ['do'] = ':PlugInstall' })

vim.call('plug#end')

-- remaps and sets--
vim.g.mapleader = " "
vim.filetype.plugin = true
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.termguicolors = true

-- setups --
require('tokyonight').setup({
    transparent = true,
})
require("ibl").setup()
require('lualine').setup()
require("nvim-treesitter.install").prefer_git = true
require('mason').setup()
require('mason-lspconfig').setup {
    ensure_installed = { "lua_ls", "ocamllsp", "zls", "gopls" },
}
require("nvim-dap-virtual-text").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Search Directory > ") })
end)
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end)
vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end)
vim.keymap.set("n", "<leader>fc", function() vim.lsp.formatexpr() end)
vim.keymap.set("n", "<leader>==", function() vim.lsp.buf.format() end)
vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end)
vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end)
vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end)
vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end)
vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end)
vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end)
vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end)
vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end)

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- debug mappings
vim.keymap.set('n', '<F4>', function() dap.restart() end)
vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F6>', function() dap.step_over() end)
vim.keymap.set('n', '<F7>', function() dap.step_into() end)
vim.keymap.set('n', '<F8>', function() dap.step_out() end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>gb', function() dap.run_to_cursor() end)
vim.keymap.set('n', '<leader>?', function() dap.eval(nil, { enter = true }) end)

require('dap-go').setup()

-- example dap adapter
-- dap.adapters.python = {
--     type = 'executable';
--     command = os.getenv('HOME') .. '/.virtualenvs/tools/bin/python';
--     args = { '-m', 'debugpy.adapter' };
-- }

-- Move between windows using Ctrl + h/j/k/l
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })


local cmp = require('cmp')
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
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
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['lua_ls'].setup {
    capabilities = capabilities
}

-- select colorscheme --
vim.cmd('silent! colorscheme tokyonight-moon')

local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-z>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-x>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-c>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(4) end)
