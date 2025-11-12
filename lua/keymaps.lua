local map = vim.keymap.set

-- Clear search highlights
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Terminal: make <Esc><Esc> leave terminal-mode
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Easier split navigation
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Diagnostics: quickfix list
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Fugitive
map('n', '<leader>gs', ':G<CR>', { desc = 'Git status' })
map('n', '<leader>gc', ':Git commit<CR>', { desc = 'Git commit' })
map('n', '<leader>gp', ':Git push<CR>', { desc = 'Git push' })
map('n', '<leader>gP', ':Git pull --rebase<CR>', { desc = 'Git pull --rebase' })
map('n', '<leader>gl', ':Gclog<CR>', { desc = 'Git log (buffer)' })
map('n', '<leader>gb', ':Gblame<CR>', { desc = 'Git blame' })
map('n', '<leader>gd', ':Gvdiffsplit<CR>', { desc = 'Diff vs index/HEAD' })

-- Moving between windows
vim.keymap.set('n', '<M-h>', '<C-w>h')
vim.keymap.set('n', '<M-j>', '<C-w>j')
vim.keymap.set('n', '<M-k>', '<C-w>k')
vim.keymap.set('n', '<M-l>', '<C-w>l')
vim.keymap.set('n', '<M-q>', '<C-w>q')

-- [[ Basic Autocommands ]]
-- See :help lua-guide-autocommands
local aug = vim.api.nvim_create_augroup('user-autocmds', { clear = true })

-- 1) Highlight on yank (same behavior, just under a single user group)
vim.api.nvim_create_autocmd('TextYankPost', {
  group = aug,
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- 2) Equalize splits when resizing the Neovim window
vim.api.nvim_create_autocmd('VimResized', {
  group = aug,
  desc = 'Equalize window splits when the editor is resized',
  command = 'wincmd =',
})

-- 3) Close certain transient windows with q
vim.api.nvim_create_autocmd('FileType', {
  group = aug,
  desc = 'Use q to quit helper buffers',
  pattern = { 'help', 'qf', 'lspinfo', 'man', 'checkhealth', 'notify' },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = event.buf, silent = true })
    vim.bo[event.buf].buflisted = false
  end,
})

-- 4) Wrap & spell in markdown / gitcommit buffers
vim.api.nvim_create_autocmd('FileType', {
  group = aug,
  pattern = { 'markdown', 'gitcommit' },
  desc = 'Soft wrap and spellcheck for prose',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.spell = true
  end,
})

-- 5) Restore last cursor position when re-opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = aug,
  desc = 'Jump to last known cursor position',
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 6) Auto-create missing directories on write
vim.api.nvim_create_autocmd('BufWritePre', {
  group = aug,
  desc = 'Create missing parent directories on write',
  callback = function(args)
    local dir = vim.fn.fnamemodify(args.match, ':p:h')
    if dir ~= '' and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

-- 7) Optional: trim trailing whitespace on save (toggle with g:strip_whitespace)
vim.g.strip_whitespace = vim.g.strip_whitespace ~= false
vim.api.nvim_create_autocmd('BufWritePre', {
  group = aug,
  desc = 'Strip trailing whitespace',
  callback = function()
    if vim.g.strip_whitespace then
      local cur = vim.api.nvim_win_get_cursor(0)
      vim.cmd [[%s/\s\+$//e]]
      pcall(vim.api.nvim_win_set_cursor, 0, cur)
    end
  end,
})

-- Diagnostic on hover
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float { scope = 'cursor' }
  end,
})

-- Detect runner from filetype (extend as you like)
local runners = {
  python = { cmd = 'python3', args = {} },
  javascript = { cmd = 'node', args = {} },
  typescript = { cmd = 'ts-node', args = {} },
  sh = { cmd = 'bash', args = {} },
}

-- Run current buffer in a terminal split (interactive)
vim.keymap.set('n', '<leader>rr', function()
  local ft = vim.bo.filetype
  local runner = runners[ft]
  if not runner then
    vim.notify('No runner configured for filetype: ' .. ft, vim.log.levels.WARN)
    return
  end
  -- Save, then open a bottom terminal and run
  vim.cmd.write()
  local cmd = table.concat(vim.tbl_flatten { runner.cmd, runner.args, vim.fn.expand '%' }, ' ')
  vim.cmd 'botright split | resize 15'
  vim.cmd('terminal ' .. cmd)
  -- enter Terminal-Job mode so you can type inputs immediately
  vim.cmd 'startinsert'
end, { desc = 'Run current file in terminal (interactive)' })

-- Handy keys for terminal buffers
-- <Esc> returns to Normal mode from Terminal mode
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Terminal -> Normal' })
-- Close the terminal quickly with 'q' in Normal mode
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    vim.keymap.set('n', 'q', '<cmd>bd!<cr>', { buffer = args.buf, desc = 'Close terminal' })
  end,
})
