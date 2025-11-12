return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/TheNest/',
      },
      {
        name = 'notes',
        path = '~/Documents/psychology101/TheNotes/',
      },
    },
    note_id_func = function(title)
      if title and title ~= '' then
        local slug = title:gsub('[%s_]+', '-'):gsub('[^%w%-]', ''):lower()
        return slug
      end
      return os.date '%Y%m%d-%H%M%S'
    end,

    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
    },
    disable_front_matter = true,
  },
}
