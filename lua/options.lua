-- Leader keys (must be set before plugins)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- UI/Editing Defaults
vim.opt.termguicolors = true
vim.opt.cursorline = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'

-- Indentation (consistent 2-space soft tabs)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Mouse & UI
vim.opt.mouse = 'a'
vim.opt.showmode = false

-- Clipboard (scheduled to avoid startup delay)
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Search
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Lists / whitespace indicators
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Timing & layout
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
