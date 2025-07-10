require("config.lazy")

local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_set_hl = api.nvim_set_hl
local fn = vim.fn
local g = vim.g
local keymap = vim.keymap

-- enable relative number
opt.relativenumber = true

-- enable line number
opt.number = true

-- enable sing column
opt.signcolumn = "number"

-- set tab spaces to 2
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
vim.bo.softtabstop = 2

--  UTF-8 FTW
opt.encoding = "utf-8"

-- Show unvisible characters
local space = "·"
opt.list = true
opt.listchars:append {
	tab = "│─",
	multispace = space,
	lead = space,
	trail = space,
	nbsp = space,
	eol = "¬"
}

cmd([[match TrailingWhitespace /\s\+$/]])

nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })

nvim_create_autocmd("InsertEnter", {
	callback = function()
		opt.listchars.trail = nil
		nvim_set_hl(0, "TrailingWhitespace", { link = "Whitespace" })
	end
})

nvim_create_autocmd("InsertLeave", {
	callback = function()
		opt.listchars.trail = space
		nvim_set_hl(0, "TrailingWhitespace", { link = "Error" })
	end
})

-- enable true color
cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
opt.termguicolors = true

-- set colorscheme
opt.background = "dark" -- or "light" for light mode
cmd([[colorscheme gruvbox]])

-- Enable syntax highlighting
cmd 'syntax on'

-- Write to the same file
opt.backupcopy = 'yes'

-- Clipboard settings
opt.clipboard = 'unnamedplus'

-- Give warning when line  > 80
local generalSettingsGroup = vim.api.nvim_create_augroup('General settings', { clear = true })
api.nvim_set_hl(0, "ColorColumn", { ctermbg = 135, bg = '#850127' })
api.nvim_create_autocmd('BufRead', {
	pattern = "*",
	callback = function ()
		fn.matchadd('ColorColumn', '\\%81v', 100)
	end,
	group = generalSettingsGroup
})
api.nvim_create_autocmd('FileWritePost', {
	pattern = "*",
	callback = function ()
		fn.matchadd('ColorColumn', '\\%81v', 100)
	end,
	group = generalSettingsGroup
})

-- Configure nvim-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

require('nvim-tree').setup()

api.nvim_set_keymap('n', '<C-n>', ':NvimTreeFindFileToggle<CR>', { noremap = true, silent = true })

-- Configure Telescope
local builtin = require('telescope.builtin')
keymap.set('n', '<leader>ff', builtin.find_files, {})
keymap.set('n', '<leader>fg', builtin.live_grep, {})
keymap.set('n', '<leader>fb', builtin.buffers, {})
keymap.set('n', '<leader>fh', builtin.help_tags, {})

cmd 'nnoremap <silent> <c-p> <cmd>Telescope find_files<cr>'

api.nvim_create_user_command('Find', function (args)
  local vimCmd = 'Telescope grep_string'
  if (args['args']) then
    vimCmd = vimCmd .. ' ' .. args['args']
  end
  vim.cmd(vimCmd)
end, { desc = "Open Git vertically", nargs = '*' })

-- LSP ZERO
--local lsp_zero = require('lsp-zero')

-- lsp_attach is where you enable features that only work
-- if there is a language server active in the file
--local lsp_attach = function(client, bufnr)
--  local opts = {buffer = bufnr}
--
--  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
--  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
--  vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
--  vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
--  vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
--  vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
--  vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
--  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
--  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
--  vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
--end

--lsp_zero.extend_lspconfig({
--  sign_text = true,
--  lsp_attach = lsp_attach,
----  capabilities = require('cmp_nvim_lsp').default_capabilities(),
--})

require('lspconfig').lua_ls.setup({})
require'lspconfig'.ansiblels.setup{}
require'lspconfig'.pyright.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.terraformls.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.terraformls.setup{}
require("lspconfig")["tinymist"].setup {
        settings = {
        formatterMode = "typstyle",
        exportPdf = "onType",
        semanticTokens = "disable"
    }
}

--vim.lsp.enable('ansiblels')
--vim.lsp.enable('terraformls')

--local cmp = require('cmp')
--
--cmp.setup({
--  sources = {
--    {name = 'nvim_lsp'},
--    {name = 'buffer'},
--    {name = 'path'},
--  },
--  snippet = {
--    expand = function(args)
--      -- You need Neovim v0.10 to use vim.snippet
--      vim.snippet.expand(args.body)
--    end,
--  },
--  window = {
--      completion = cmp.config.window.bordered(),
--      documentation = cmp.config.window.bordered(),
--  },
--  mapping = cmp.mapping.preset.insert({
--    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-Space>'] = cmp.mapping.complete(),
--    ['<C-e>'] = cmp.mapping.abort(),
--    ['<Tab>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--  }),
--})
