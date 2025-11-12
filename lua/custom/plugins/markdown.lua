return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  ft = { 'md', 'markdown' },
  build = function()
    require('lazy').load { plugins = { 'markdown-preview.nvim' } }
    vim.fn['mkdp#util#install']()
  end,
  keys = {
    { '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', desc = 'Toggle Markdown Preview' },
  },
}
