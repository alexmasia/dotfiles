vim.keymap.set("n", "<leader>nm", function()
  require("noice").cmd("history")
end, { desc = "Mostrar mensajes (Noice)" })

-- Mostrar el log de Lazy.nvim
vim.keymap.set("n", "<leader>nl", function()
  require("lazy.view").show("log")
end, { desc = "Mostrar log de Lazy.nvim" })

-- Obrir telescope amb space+sp
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- Guardar archivo y formatear con <Space>w
vim.keymap.set("n", "<leader>w", function()
  vim.cmd("w") -- guarda el buffer actual
  -- Intenta usar conform.nvim si está disponible (LazyVim lo trae)
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_fallback = true })
  else
    -- Si conform no está, usa el formateador del LSP
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Guardar y formatear archivo" })
