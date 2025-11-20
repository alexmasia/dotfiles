local is_deno_project = require("faraday.functions").is_deno_project

-- OJO: ya no usamos require('lspconfig') aquí
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local navbuddy = require("nvim-navbuddy")
local navic = require("nvim-navic")

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-----------------------------------------------------------------------
-- on_attach: keymaps y Navbuddy/Navic
-----------------------------------------------------------------------
local on_attach = function(client, bufnr)
	opts.buffer = bufnr

	if client.server_capabilities.documentSymbolProvider then
		navbuddy.attach(client, bufnr)
		if not navic.is_available(bufnr) then
			navic.attach(client, bufnr)
		end
	end

	opts.desc = "Show LSP references"
	keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

	opts.desc = "Go to declaration"
	keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

	opts.desc = "Show LSP definitions"
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	keymap.set("n", "<C-g><C-d>", "<C-w><C-v><cmd>Telescope lsp_definitions<CR>", opts)

	opts.desc = "Show LSP type definitions"
	keymap.set("n", "gy", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	opts.desc = "Show LSP implementations"
	keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

	opts.desc = "Show incoming calls"
	keymap.set("n", "gj", "<cmd>Telescope lsp_incoming_calls<CR>", opts)

	opts.desc = "Show outgoing calls"
	keymap.set("n", "gk", "<cmd>Telescope lsp_outgoing_calls<CR>", opts)

	opts.desc = "Smart rename"
	keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	opts.desc = "Show buffer diagnostics"
	keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

	opts.desc = "Show workspace diagnostics ([s]how [e]rrors)"
	keymap.set("n", "<leader>se", "<cmd>Telescope diagnostics<CR>", opts)

	opts.desc = "Show line diagnostics"
	keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

	opts.desc = "Go to previous diagnostic"
	keymap.set("n", "[e", vim.diagnostic.goto_prev, opts)

	opts.desc = "Go to next diagnostic"
	keymap.set("n", "]e", vim.diagnostic.goto_next, opts)

	opts.desc = "Show documentation for what is under cursor"
	keymap.set("n", "K", vim.lsp.buf.hover, opts)

	opts.desc = "Signature help"
	keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
end

-----------------------------------------------------------------------
-- capabilities
-----------------------------------------------------------------------
local capabilities = cmp_nvim_lsp.default_capabilities()

-----------------------------------------------------------------------
-- Diagnostic symbols
-----------------------------------------------------------------------
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-----------------------------------------------------------------------
-- Servidores “simples” (sin config especial)
-----------------------------------------------------------------------
local simple_servers = {
	"bashls",
	"cssls",
	"emmet_language_server",
	"html",
	"jsonls",
	"prismals",
	"pyright",
	"sourcekit",
	"tailwindcss",
	"taplo",
	"zls",
}

for _, server in ipairs(simple_servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-----------------------------------------------------------------------
-- Servidores con configuración específica
-----------------------------------------------------------------------

-- GraphQL
vim.lsp.config("graphql", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
})

-- SQL
vim.lsp.config("sqlls", {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "sql" },
})

-- Clangd
vim.lsp.config("clangd", {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = {
		"clangd",
		"--background-index",
		"--suggest-missing-includes",
		"--clang-tidy",
		"--header-insertion=iwyu",
	},
})

-- Go
vim.lsp.config("gopls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		gopls = {
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- Gleam
vim.lsp.config("gleam", {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "gleam", "lsp" },
})

-- Lua
vim.lsp.config("lua_ls", {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$XDG_CONFIG_HOME") .. "/nvim/lua",
				},
			},
		},
	},
})

-----------------------------------------------------------------------
-- TypeScript / Deno
-----------------------------------------------------------------------
if is_deno_project() then
	require("deno-nvim").setup({
		server = {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				deno = {
					inlayHints = {
						parameterNames = { enabled = "all" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		},
	})
else
	require("typescript-tools").setup({
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)

			local options = { desc = "[ts-tools] organize imports", buffer = bufnr }
			vim.keymap.set("n", "<leader>tso", vim.cmd.TSToolsOrganizeImports, options)

			options = { desc = "[ts-tools] sort imports" }
			vim.keymap.set("n", "<leader>tsi", vim.cmd.TSToolsSortImports, options)

			options = { desc = "[ts-tools] remove unused statements" }
			vim.keymap.set("n", "<leader>tss", vim.cmd.TSToolsRemoveUnused, options)

			options = { desc = "[ts-tools] remove unused imports" }
			vim.keymap.set("n", "<leader>tsu", vim.cmd.TSToolsRemoveUnusedImports, options)

			options = { desc = "[ts-tools] add missing imports" }
			vim.keymap.set("n", "<leader>tsa", vim.cmd.TSToolsAddMissingImports, options)

			options = { desc = "[ts-tools] re-attach lsp" }
			vim.keymap.set("n", "<leader>tsk", function()
				on_attach(client, vim.api.nvim_get_current_buf())
			end, options)
		end,
		settings = {
			tsserver_file_preferences = {
				importModuleSpecifierPreference = "non-relative",
			},
		},
	})
end

-----------------------------------------------------------------------
-- Formato de mensajes de diagnóstico
-----------------------------------------------------------------------
local format_diagnostic_message = function(diagnostic)
	local severity = vim.diagnostic.severity[diagnostic.severity]
	local message = ""
	if severity ~= nil then
		message = string.format("[%s]", severity)
	end

	if diagnostic.message ~= nil then
		message = string.format("%s %s", message, diagnostic.message)
	end

	if diagnostic.source ~= nil then
		message = string.format("%s (%s)", message, diagnostic.source)
	end

	return message
end

vim.diagnostic.config({
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = false,
		header = "",
		prefix = "",
		format = format_diagnostic_message,
	},
	virtual_text = {
		spacing = 2,
		format = format_diagnostic_message,
	},
})

-----------------------------------------------------------------------
-- Rust (rustaceanvim)
-----------------------------------------------------------------------
vim.g.rustaceanvim = function()
	return {
		tools = {
			hover_actions = {
				auto_focus = true,
			},
		},
		server = {
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)

				vim.keymap.set("n", "<leader>rt", function()
					vim.cmd.RustLsp("testables")
				end, { desc = "[rustaceanvim] rust testables" })

				vim.keymap.set("n", "<leader>rr", function()
					vim.cmd.RustLsp({ "testables", bang = true })
				end, { desc = "[rustaceanvim] rust testables" })

				vim.keymap.set("n", "<leader>rb", function()
					vim.cmd.RustLsp("debuggables")
				end, { desc = "[rustaceanvim] rust debuggables" })

				vim.keymap.set("n", "<leader>rl", function()
					vim.cmd.RustLsp({ "debuggables", bang = true })
				end, { desc = "[rustaceanvim] rust debug last" })

				vim.keymap.set("n", "<leader>ra", function()
					vim.cmd.RustLsp("codeAction")
				end, { silent = true, desc = "[rustaceanvim] code actions" })

				vim.keymap.set("n", "<leader>rh", function()
					vim.cmd.RustLsp({ "hover", "actions" })
				end, { silent = true, desc = "[rustaceanvim] hover actions" })

				vim.keymap.set("n", "<leader>re", function()
					vim.cmd.RustLsp("explainError")
				end, { silent = true, desc = "[rustaceanvim] render diagnostics" })

				vim.keymap.set("n", "<leader>rd", function()
					vim.cmd.RustLsp("renderDiagnostic")
				end, { silent = true, desc = "[rustaceanvim] render diagnostics" })
			end,
		},
	}
end

-----------------------------------------------------------------------
-- Activar configs
-----------------------------------------------------------------------
vim.lsp.enable(simple_servers)
vim.lsp.enable({ "graphql", "sqlls", "clangd", "gopls", "gleam", "lua_ls" })

-----------------------------------------------------------------------
-- Bash LSP extra vía autocmd (lo tenías ya y lo dejo igual)
-----------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.lsp.start({
			name = "bash-language-server",
			cmd = { "bash-language-server", "start" },
		})
	end,
})
