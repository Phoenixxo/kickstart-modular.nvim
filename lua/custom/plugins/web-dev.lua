return {
  -- Auto-close & auto-rename HTML/JSX/TSX tags
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "tsx", "javascript", "typescript", "svelte", "vue" },
    opts = {}, -- default setup
  },

  -- Inline color previews for hex/rgb/hsl, etc.
  {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
    config = function()
      require("colorizer").setup({
        "*", -- enable everywhere; or list: css,scss,html,tsx,jsx
      }, {
        names = false, -- disable named colors if you prefer
      })
    end,
  },
}

