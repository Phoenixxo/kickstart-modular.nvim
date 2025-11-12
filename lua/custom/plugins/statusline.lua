return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    config = function()
      vim.o.laststatus = 3

      local clock = function() return os.date("%H:%M") end

      -- only show diagnostics when there are any
      local has_diags = function()
        return #vim.diagnostic.get(0) > 0
      end

      local lsp_names = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if not clients or #clients == 0 then return "" end
        local names = {}
        for _, c in ipairs(clients) do
          if c.name ~= "null-ls" then table.insert(names, c.name) end
        end
        return (#names > 0) and (" " .. table.concat(names, ",")) or ""
      end

      require("lualine").setup({
        options = {
          theme = "catppuccin",
          icons_enabled = true,
          globalstatus = true,
          section_separators   = { left = "", right = "" }, -- chevrons
          component_separators = { left = "", right = "" }, -- slim dividers
        },
        sections = {
          -- LEFT
          lualine_a = {
            { "mode", fmt = function(s) return s:upper() end, padding = { left = 2, right = 2 } },
          },
          lualine_b = {
            { "branch", icon = "" },
          },
          lualine_c = {
            {
              "filename",
              path = 0,
              symbols = { modified = " [+]", readonly = " ", unnamed = "[No Name]" },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
              symbols = { error = " ", warn = " ", info = " ", hint = " " },
              colored = true,
              update_in_insert = false,
              always_visible = false,
              cond = has_diags,
            },
            {
              lsp_names,
              cond = function() return lsp_names() ~= "" end,
            },
          },

          -- RIGHT
          lualine_x = {
            { "encoding", fmt = function(s) return (s or ""):lower() end },
            { "filetype" },
          },
          lualine_y = {
            { "progress" },
          },
          lualine_z = {
            { clock, padding = { left = 2, right = 2 } },
          },
        },
        inactive_sections = {
          lualine_a = {}, lualine_b = {}, lualine_c = { "filename" },
          lualine_x = { "location" }, lualine_y = {}, lualine_z = {}
        },
      })
    end,
  },
}
