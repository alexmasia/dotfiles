return {
	"nvim-telescope/telescope.nvim",
	tag = "v0.1.9",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<Leader>sp", builtin.git_files, {})
		vim.keymap.set("n", "<Leader>lg", builtin.live_grep, {})
	end,
}
