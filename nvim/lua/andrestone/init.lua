-- Notes to self:

local sumneko_root_path = "/opt/homebrew/Cellar/lua-language-server/2.6.7/libexec"
local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

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
		-- ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
		-- ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-y>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
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
	ensure_installed = "all",
	ignore_install = { "phpdoc" },
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
	client.server_capabilities.document_formatting = false
	client.server_capabilities.document_range_formatting = false
end

local eslint = {
	lintCommand = "eslint -f unix --stdin --stdin-filename ${INPUT}",
	lintIgnoreExitCode = false,
	lintStdin = true,
	lintFormats = { "%f:%l:%c: %m" },
	formatCommand = "eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true,
}

local default_prettier_max_line = "100"

local prettier = {
	formatCommand = "prettier --fix-tostdout --semi --single-quote --prose-wrap always --print-width "
		.. default_prettier_max_line
		.. " --stdin-filepath ${INPUT}",
	formatStdin = true,
}

local pylint = {
	lintCommand = "pylint --output-format text --score no --msg-template {path}:{line}:{column}:{C}:{msg} ${INPUT}",
	lintStdin = false,
	lintFormats = { "%f:%l:%c:%t:%m" },
	lintOffsetColumns = 1,
	lintCategoryMap = {
		I = "H",
		R = "I",
		C = "I",
		W = "W",
		E = "E",
		F = "E",
	},
}

local black = {
	formatCommand = "black --quiet -",
	formatStdin = true,
}

local stylua = { formatCommand = "/Users/andre/.cargo/bin/stylua -s -", formatStdin = true }

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
	python = { black },
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

require("lspconfig").html.setup({})

require("lspconfig").tsserver.setup({
	on_attach = on_tss_attach,
	filetypes = {
		-- "javascript",
		-- "javascriptreact",
		-- "javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
})
require("lspconfig").bashls.setup({ on_attach = on_attach })
-- require("lspconfig").graphql.setup({ on_attach = on_attach })
require("lspconfig").clangd.setup({
	filetypes = { "c", "cpp" },
	on_attach = on_attach,
	root_dir = function()
		return vim.loop.cwd()
	end,
	cmd = { "clangd", "--background-index" },
})

require("lspconfig").pyright.setup({})

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
	root_dir = require("lspconfig").util.root_pattern(".git"), -- extra root for RN projects
})

require("gitsigns").setup()
require("lspconfig").flow.setup({})

require("lspconfig").sourcekit.setup({
	filetypes = { "swift", "objcpp", "objective-c", "objc" },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

require("nvim-web-devicons").setup({
	-- your personnal icons can go here (to override)
	-- you can specify color or cterm_color instead of specifying both of them
	-- DevIcon will be appended to `name`
	override = {
		zsh = {
			icon = "",
			color = "#428850",
			cterm_color = "65",
			name = "Zsh",
		},
	},
	-- globally enable default icons (default to false)
	-- will get overriden by `get_icons` option
	default = true,
})

require("xbase").setup({
	log_level = vim.log.levels.INFO,
	log_buffer = {
		focus = false,
		default_direction = "horizontal",
	},
	-- sourcekit = {
	-- 	on_attach = require("user.lsp").on_attach(),
	-- 	handlers = require("user.lsp").handlers,
	-- 	capabilities = require("user.lsp").capabilities,
	-- },
	simctl = {
		iOS = {
			"iPhone 13 Pro",
		},
	},
	mappings = {
		--- Whether xbase mapping should be disabled.
		enable = true,
		--- Open build picker. showing targets and configuration.
		build_picker = 0, --- set to 0 to disable
		--- Open run picker. showing targets, devices and configuration
		run_picker = 0, --- set to 0 to disable
		--- Open watch picker. showing run or build, targets, devices and configuration
		watch_picker = 0, --- set to 0 to disable
		--- A list of all the previous pickers
		all_picker = "<leader>ef", --- set to 0 to disable
	},
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

-- git diff view
local cb = require("diffview.config").diffview_callback

require("diffview").setup({
	diff_binaries = false, -- Show diffs for binaries
	enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
	use_icons = true, -- Requires nvim-web-devicons
	icons = { -- Only applies when use_icons is true.
		folder_closed = "",
		folder_open = "",
	},
	signs = {
		fold_closed = "",
		fold_open = "",
	},
	file_panel = {
		winconfig = {
			position = "left", -- One of 'left', 'right', 'top', 'bottom'
			width = 35, -- Only applies when position is 'left' or 'right'
			height = 10, -- Only applies when position is 'top' or 'bottom'
		},
		listing_style = "tree", -- One of 'list' or 'tree'
		tree_options = { -- Only applies when listing_style is 'tree'
			flatten_dirs = true, -- Flatten dirs that only contain one single dir
			folder_statuses = "only_folded", -- One of 'never', 'only_folded' or 'always'.
		},
	},
	file_history_panel = {
		win_config = {
			position = "bottom",
			width = 35,
			height = 16,
		},
		-- log_options = {
		-- 	max_count = 256, -- Limit the number of commits
		-- 	follow = false, -- Follow renames (only for single file)
		-- 	all = false, -- Include all refs under 'refs/' including HEAD
		-- 	merges = false, -- List only merge commits
		-- 	no_merges = false, -- List no merge commits
		-- 	reverse = false, -- List commits in reverse order
		-- },
	},
	default_args = { -- Default args prepended to the arg-list for the listed commands
		DiffviewOpen = {},
		DiffviewFileHistory = {},
	},
	hooks = {}, -- See ':h diffview-config-hooks'
	key_bindings = {
		disable_defaults = false, -- Disable the default key bindings
		-- The `view` bindings are active in the diff buffers, only when the current
		-- tabpage is a Diffview.
		view = {
			["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
			["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
			["gf"] = cb("goto_file"), -- Open the file in a new split in previous tabpage
			["<C-w><C-f>"] = cb("goto_file_split"), -- Open the file in a new split
			["<C-w>gf"] = cb("goto_file_tab"), -- Open the file in a new tabpage
			["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
			["<leader>b"] = cb("toggle_files"), -- Toggle the files panel.
		},
		file_panel = {
			["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
			["<down>"] = cb("next_entry"),
			["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
			["<up>"] = cb("prev_entry"),
			["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
			["o"] = cb("select_entry"),
			["<2-LeftMouse>"] = cb("select_entry"),
			["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
			["S"] = cb("stage_all"), -- Stage all entries.
			["U"] = cb("unstage_all"), -- Unstage all entries.
			["X"] = cb("restore_entry"), -- Restore entry to the state on the left side.
			["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
			["<tab>"] = cb("select_next_entry"),
			["<s-tab>"] = cb("select_prev_entry"),
			["gf"] = cb("goto_file"),
			["<C-w><C-f>"] = cb("goto_file_split"),
			["<C-w>gf"] = cb("goto_file_tab"),
			["i"] = cb("listing_style"), -- Toggle between 'list' and 'tree' views
			["f"] = cb("toggle_flatten_dirs"), -- Flatten empty subdirectories in tree listing style.
			["<leader>e"] = cb("focus_files"),
			["<leader>b"] = cb("toggle_files"),
		},
		file_history_panel = {
			["g!"] = cb("options"), -- Open the option panel
			["<C-A-d>"] = cb("open_in_diffview"), -- Open the entry under the cursor in a diffview
			["y"] = cb("copy_hash"), -- Copy the commit hash of the entry under the cursor
			["zR"] = cb("open_all_folds"),
			["zM"] = cb("close_all_folds"),
			["j"] = cb("next_entry"),
			["<down>"] = cb("next_entry"),
			["k"] = cb("prev_entry"),
			["<up>"] = cb("prev_entry"),
			["<cr>"] = cb("select_entry"),
			["o"] = cb("select_entry"),
			["<2-LeftMouse>"] = cb("select_entry"),
			["<tab>"] = cb("select_next_entry"),
			["<s-tab>"] = cb("select_prev_entry"),
			["gf"] = cb("goto_file"),
			["<C-w><C-f>"] = cb("goto_file_split"),
			["<C-w>gf"] = cb("goto_file_tab"),
			["<leader>e"] = cb("focus_files"),
			["<leader>b"] = cb("toggle_files"),
		},
		option_panel = {
			["<tab>"] = cb("select"),
			["q"] = cb("close"),
		},
	},
})
