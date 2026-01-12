return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		-- logs
		opts = {
			log_level = "DEBUG", -- o "TRACE"
		},

		-- ✅ Ollama adapter
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						model = {
							default = "gpt-oss:20b", -- <-- cámbialo por el tuyo (ollama list)
						},
					},
					-- opcional, pero útil si quieres forzar URL
					env = {
						url = "http://127.0.0.1:11434",
					},
				})
			end,
		},

		-- ✅ usar Ollama por defecto
		strategies = {
			chat = { adapter = "ollama" },
			inline = { adapter = "ollama" },
		},
	},
}
