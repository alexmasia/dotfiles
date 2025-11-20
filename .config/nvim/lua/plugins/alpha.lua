return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"MaximilianLloyd/ascii.nvim",
		"MunifTanjim/nui.nvim",
	},
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")
		local ascii = require("ascii")

		-- OPCIÓN 1: uno aleatorio global
		-- dashboard.section.header.val = ascii.get_random_global()

		-- OPCIÓN 2: aleatorio de una subcategoría concreta
		-- categorías: "animals", "movies", "cartoons", "gaming", "computers", "misc", "text" :contentReference[oaicite:0]{index=0}
		dashboard.section.header.val = ascii.get_random("computers", "linux")

		-- Tus botones como ya los tenías
		dashboard.section.buttons.val = {
			dashboard.button("f", "  Buscar archivo", ":Telescope find_files<CR>"),
			dashboard.button("r", "  Recientes", ":Telescope oldfiles<CR>"),
			dashboard.button("g", "󰱼  Live grep", ":Telescope live_grep<CR>"),
			dashboard.button("e", "  Neo-tree", ":Neotree toggle<CR>"),
			dashboard.button("c", "  Config nvim", ":e ~/.config/nvim/init.lua<CR>"),
			dashboard.button("q", "  Salir", ":qa<CR>"),
		}

		dashboard.section.footer.val = {
			"  ascii.nvim + alpha.nvim",
		}

		-- Si no quieres Alpha al abrir archivos/directorios:
		if vim.fn.argc() > 0 then
			return
		end

		alpha.setup(dashboard.config)
	end,
}
