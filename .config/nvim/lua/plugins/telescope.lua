-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    {
      "<leader>sp",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Buscar archivos (Telescope)",
    },
  },
  config = function()
    -- Configuración opcional de Telescope
    require("telescope").setup({
      defaults = {
        layout_strategy = "vertical",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
      },
    })
  end,
}
