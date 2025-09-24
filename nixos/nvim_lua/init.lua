-- Set TMPDIR for Neovim
vim.env.TMPDIR = vim.fn.expand("~/neovim_tmp")
vim.fn.mkdir(vim.env.TMPDIR, "p")

require("config.lazy")

local opt = vim.opt
local cmd = vim.cmd
local api = vim.api
local nvim_create_autocmd = api.nvim_create_autocmd
local nvim_set_hl = api.nvim_set_hl
local fn = vim.fn
local g = vim.g
local keymap = vim.keymap

opt.shell = 'bash'

-- enable true color
cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
opt.termguicolors = true

-- enable relative number
opt.relativenumber = true

-- enable line number
opt.number = true

opt.cursorline = true

-- enable sign column
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

-- BEGIN gruvbox.nvim
opt.background = "dark" -- or "light" for light mode
cmd([[colorscheme nightfox]])

-- BEGIN lualine
require('lualine').setup()
-- END lualine

-- BEGIN typst-preview
--require 'typst-preview'.setup({
--  debug = false,
--  dependencies_bin = {
--    ['tinymist'] = 'tinymist',
--    ['websocat'] = 'websocat'
--  },
--})
-- END typst-preview

-- Enable syntax highlighting
cmd 'syntax on'

-- Write to the same file
opt.backupcopy = 'yes'

-- Clipboard settings
opt.clipboard = 'unnamedplus'

-- Give warning when line  > 80
local generalSettingsGroup = api.nvim_create_augroup('General settings', { clear = true })
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

-- BEGIN nvim-tree
-- First we disable netrw
-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file#install
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- then setup
require('nvim-tree').setup()
-- END nvim-tree

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*/play*.yml",
    "*/play*.yaml",
    "*/playbooks/*.yml",
    "*/playbooks/*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*.ansible.yml",
    "*.ansible.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

vim.lsp.enable({"lua_ls"})
vim.lsp.enable({"ansiblels"})
vim.lsp.enable({"ruff"})
vim.lsp.enable({"basedpyright"})
vim.lsp.enable({"bashls"})
vim.lsp.enable({"terraformls"})
vim.lsp.enable({"gopls"})
vim.lsp.enable({"nixd"})
vim.lsp.enable({"rust_analyzer"})
vim.lsp.enable({"ts_ls"})
vim.lsp.enable({"phpactor"})

--vim.lsp.config("tinymist", {
--  settings = {
--    formatterMode = "typstyle",
--    exportPdf = "onType",
--    semanticTokens = "disable"
--  }
--})
--vim.lsp.enable({"tinymist"})

--require("lspconfig").rust_analyzer.setup({
--  settings = {
--    ["rust-analyzer"] = {
--      inlayHints = {
--        -- Optional: tweak what hints you want
--        lifetimeElisionHints = { enable = true, useParameterNames = true },
--        parameterHints = { enable = true },
--        typeHints = { enable = true },
--      },
--    },
--  },
--})


vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        -- Optional: tweak what hints you want
        lifetimeElisionHints = { enable = true, useParameterNames = true },
        parameterHints = { enable = true },
        typeHints = { enable = true },
      },
    },
  },
})
vim.lsp.enable({"rust_analyzer"})

--
vim.keymap.set("n", "<leader>hi", function()
--  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({0})

  vim.lsp.inlay_hint.enable(not enabled)

--  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
end, { desc = "Toggle Inlay Hints" })

-- Optional: enable hints by default
vim.api.nvim_create_autocmd("LspAttach", {
 callback = function(args)
   local bufnr = args.buf
   local lsp_client = vim.lsp.get_client_by_id(args.data.client_id).name
   vim.notify("LSP client "..lsp_client)
   if vim.lsp.get_client_by_id(args.data.client_id).name == "rust_analyzer" then
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({0}),{0})
      vim.notify("inlay hint enabled for "..lsp_client)
   end
 end,
})

vim.notify = require("notify")

---- Simple toggle state
--local hello_toggle = false
--
--vim.keymap.set("n", "<leader>bn", function()
--  hello_toggle = not hello_toggle
--  if hello_toggle then
--    vim.notify("hello world")
--  else
--    vim.notify("goodbye world")
--  end
--end, { desc = "Toggle Hello World" })
