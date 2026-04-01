return {
	"yetone/avante.nvim",
	-- ⚠️ obligatorio: hace el build del binario
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- no pongas "*"

	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"stevearc/dressing.nvim",
		"nvim-tree/nvim-web-devicons",
	},

	---@module 'avante'
	---@type avante.Config
	opts = {
		instructions_file = "avante.md", -- opcional, pero útil

		-- 👉 proveedor por defecto
		provider = "ollama",

		-- 🔧 aquí va LM Studio como endpoint OpenAI-compatible
		providers = {
			ollama = {
				endpoint = "http://127.0.0.1:11434", -- LM Studio base URL :contentReference[oaicite:1]{index=1}
				model = "gurubot/gpt-oss-derestricted:20b", -- pon aquí el *model id* tal cual sale en LM Studio
				timeout = 30000,
				extra_request_body = {
					temperature = 0.2,
					max_completion_tokens = 2048,
				},
			},
		},
	},
}
