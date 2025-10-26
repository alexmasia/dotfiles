return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- Evita que se abra automáticamente al iniciar Neovim
    open_on_setup = false,
  },
  init = function()
    -- Desactiva el autostart completamente
    vim.api.nvim_del_augroup_by_name("NeotreeAutostart")
  end,
}
