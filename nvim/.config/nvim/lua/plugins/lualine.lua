return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local gruvbox_theme = require("lualine.themes.gruvbox")

      require("lualine").setup({
        options = {
          theme = gruvbox_theme,
          component_separators = "",
          section_separators = "",
        },
      })
    end,
  },
}
