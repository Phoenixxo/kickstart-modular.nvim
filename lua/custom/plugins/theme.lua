return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,      -- load at startup
    priority = 1000,   -- load before other UI plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false, -- paint over terminal bg
        term_colors = true,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
