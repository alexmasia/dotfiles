return {
  "ojroques/nvim-osc52",
  config = function()
    local osc52 = require("osc52")
    vim.keymap.set("n", "<leader>y", osc52.copy_operator, { expr = true })
    vim.keymap.set("n", "<leader>yy", "<leader>y_", { remap = true })
    vim.keymap.set("x", "<leader>y", osc52.copy_visual)
  end
}
