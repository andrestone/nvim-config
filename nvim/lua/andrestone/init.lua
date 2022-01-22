-- Notes to self:

local sumneko_root_path = "/home/andre/dev/other/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

local cmp = require("cmp")

cmp.setup({
	preselect = "item",
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-f>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "vsnip" },
		{ name = "path" },
		{ name = "emoji" },
	},
})

require("nvim-autopairs").setup({})

require("nvim-treesitter.configs").setup({
	highlight = {
		enable = true,
		disable = { "json" },
	},
	ensure_installed = "maintained",
	indent = { enable = true },
	autopairs = { enable = true },
	rainbow = { enable = true },
	autotag = { enable = true },
	context_commentstring = { enable = true },
})

local function on_attach(client, bufnr)
	print("Attached to " .. client.name)
	require("lsp_signature").on_attach({
		bind = true, -- This is mandatory, otherwise border config won't get registered.
		hint_enable = false,
		handler_opts = {
			border = "single",
		},
	}, bufnr)
end

local function on_tss_attach(client, bufnr)
	on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false
end

local eslint = {
	lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
	lintIgnoreExitCode = false,
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true,
}

local default_prettier_max_line = "100"

local prettier = {
	formatCommand = "prettier --fix-tostdout --semi --single-quote --print-width "
		.. default_prettier_max_line
		.. " --stdin-filepath ${INPUT}",
	formatStdin = true,
}

local stylua = { formatCommand = "stylua -s -", formatStdin = true }

local formats = {
	css = { prettier },
	html = { prettier },
	javascript = { prettier, eslint },
	javascriptreact = { prettier, eslint },
	json = { prettier },
	lua = { stylua },
	markdown = { prettier },
	scss = { prettier },
	typescript = { prettier, eslint },
	typescriptreact = { prettier, eslint },
	yaml = { prettier },
}

require("lspconfig").efm.setup({
	root_dir = require("lspconfig").util.root_pattern({ ".git/", "." }),
	init_options = { documentFormatting = true, codeAction = true },
	filetypes = vim.tbl_keys(formats),
	settings = {
		rootMarkers = { ".git/", "." },
		languages = formats,
	},
})
require("lspconfig").tsserver.setup({ on_attach = on_tss_attach })
require("lspconfig").bashls.setup({ on_attach = on_attach })
require("lspconfig").graphql.setup({ on_attach = on_attach })
require("lspconfig").clangd.setup({
	on_attach = on_attach,
	root_dir = function()
		return vim.loop.cwd()
	end,
	cmd = { "clangd-12", "--background-index" },
})

require("lspconfig").jedi_language_server.setup({
	on_attach = on_attach,
})

require("lspconfig").yamlls.setup({})

require("lspconfig").gopls.setup({
	on_attach = on_attach,
	cmd = { "gopls", "serve" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})
-- who even uses this?
require("lspconfig").rust_analyzer.setup({ on_attach = on_attach })
require("lspconfig").solargraph.setup({
	root_dir = require("lspconfig").util.root_pattern("Gemfile", ".git"), -- extra root for RN projects
})

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
			},
		},
	},
})
