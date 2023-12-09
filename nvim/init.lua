-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  vim.cmd([[packadd packer.nvim]])
end

require("packer").startup(function(use)
  -- Package manager
  use("wbthomason/packer.nvim")

  use({
    "j-hui/fidget.nvim",
    tag = "legacy",
    config = function()
      require("fidget").setup({
        -- options
      })
    end,
  })

  -- jupytext
  use("goerz/jupytext.vim")

  use({ -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- Useful status updates for LSP
      "j-hui/fidget.nvim",

      -- Additional lua configuration, makes nvim stuff amazing
      "folke/neodev.nvim",
    },
  })

  -- Null-ls
  use({
    "nvimtools/none-ls.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
  })

  use({ -- Autocompletion
    "hrsh7th/nvim-cmp",
    requires = { "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
  })

  use({ -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    run = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
  })

  use({ -- Additional text objects via treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
  })

  -- Treesitter has no love for GraphQL
  use("jparise/vim-graphql")

  -- Git related plugins
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")
  use("lewis6991/gitsigns.nvim")
  use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

  -- Color schemes
  -- Gruvbox
  use("morhetz/gruvbox")
  -- Kanagawa
  use("rebelot/kanagawa.nvim")
  -- Nord
  use("shaunsingh/nord.nvim")
  -- Everforest
  use("sainnhe/everforest")
  -- Xcode
  use("arzg/vim-colors-xcode")
  -- Tokyo Night
  use("folke/tokyonight.nvim")

  -- Undotree
  use("mbbill/undotree")

  -- Fancier statusline
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons" },
  })

  use("lukas-reineke/indent-blankline.nvim") -- Add indentation guides even on blank lines
  use("tpope/vim-sleuth")                   -- Detect tabstop and shiftwidth automatically

  -- Commenting
  use("tpope/vim-commentary")
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- Syntax highlighting on Markdown
  use("tpope/vim-markdown")

  -- Autopairs
  use("windwp/nvim-autopairs")

  -- Snippets
  use("rafamadriz/friendly-snippets")

  -- Fuzzy Finder (files, lsp, etc)
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x", requires = { "nvim-lua/plenary.nvim" } })

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make", cond = vim.fn.executable("make") == 1 })

  -- File browser
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
  })

  -- Copilot
  use("github/copilot.vim")

  -- [[Dap]]
  use("mfussenegger/nvim-dap")
  use("rcarriga/nvim-dap-ui")
  use("theHamsta/nvim-dap-virtual-text")
  use("nvim-telescope/telescope-dap.nvim")

  use("mfussenegger/nvim-dap-python")

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, "custom.plugins")
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require("packer").sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print("==================================")
  print("    Plugins are being installed")
  print("    Wait until Packer completes,")
  print("       then restart nvim")
  print("==================================")
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  command = "source <afile> | silent! LspStop | silent! LspStart | PackerCompile",
  group = packer_group,
  pattern = vim.fn.expand("$MYVIMRC"),
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Use percent for jupytext
vim.g.jupytext_fmt = "py"

-- Hide buffers don't close them
vim.o.hidden = true

-- Fix tab
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 0
vim.o.expandtab = true
vim.o.smarttab = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.nuw = 1

-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd([[colorscheme gruvbox]])
vim.cmd([[let g:gruvbox_contrast_dark = 'hard']])
vim.o.background = "dark"
vim.cmd([[hi Normal guifg=#ded8c8 guibg=#1c1b1b]])
vim.cmd([[hi GruvboxPurple guifg=#987699]])
vim.cmd([[hi ColorColumn guibg=#212121]])

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Split right!
vim.o.splitbelow = true
vim.o.splitright = true

-- No error bells
vim.o.errorbells = false

-- No wrap please
vim.o.wrap = false
vim.o.colorcolumn = 120

-- Disabling auto commenting
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- JSDoc
vim.keymap.set({ "i" }, "/**<CR>", "/**<CR> *<CR> */<Esc>kA", { silent = true })

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<Leader>b", function()
  require("dap").toggle_breakpoint()
end)
vim.keymap.set("n", "<Leader>B", function()
  require("dap").set_breakpoint()
end)

-- Various mappings (Untied to plugin setups)
vim.keymap.set({ "v" }, "<C-c>", '"+y', { silent = true, noremap = true })
vim.keymap.set({ "n" }, "<C-v>", '"+p', { silent = true, noremap = true })
vim.keymap.set({ "n" }, "<C-n>", vim.cmd.NvimTreeToggle, { silent = true })
vim.keymap.set({ "n" }, "<leader><C-n>", ":NvimTreeFindFile!<CR>", { silent = true })
vim.keymap.set({ "n" }, "<leader>u", vim.cmd.UndotreeToggle, { silent = true })
vim.keymap.set({ "n" }, "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { silent = true })
-- TODO: convert the mappings below to lua friendly
-- Comments
vim.cmd([[nmap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('CommentaryLine')]])
vim.cmd([[xmap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('Commentary')]])
vim.cmd([[omap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('Commentary')]])
-- e-Regex
vim.cmd([[:nnoremap / /\v]])
vim.cmd([[:cnoremap s/ s/\v]])
-- Change dir
vim.cmd([[nnoremap <leader>cd :cd %:h<CR>:pwd<CR>]])

-- tmux splits
local function open_tmux_split(direction)
  local path = vim.fn.expand("%:p:h")
  vim.fn.system(string.format("tmux split-window -%sp 30 -c '%s'", direction, path))
end

vim.keymap.set("n", "<leader>-", function()
  open_tmux_split("v")
end, { remap = false })
vim.keymap.set("n", "<leader>_", function()
  open_tmux_split("h")
end, { remap = false })

-- Custom text wrapper
vim.keymap.set({ "v" }, "<leader>{", "di{}<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, "<leader>`", "di``<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, "<leader>[", "di[]<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, "<leader>(", "di()<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, '<leader>"', 'di""<ESC>hp', { silent = true })
vim.keymap.set({ "v" }, "<leader>'", "di''<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, "<leader>~", "di~~<ESC>hp", { silent = true })
vim.keymap.set({ "v" }, "<leader>/*", "di/*<CR>*/<ESC>kpAA", { silent = true })

-- Custom window navigation
-- TODO: Use proper APIs here (e.g.: vim.o.wfw instead of calling a set)
local function window_left()
  if vim.bo.buftype ~= "nofile" then
    vim.o.wfw = false
    vim.cmd([[execute "normal! \<C-w>h"]])
    if vim.bo.buftype ~= "nofile" then
      vim.cmd([[execute "normal! :vertical resize 126\<CR>:set wfw\<CR>\<C-w>=0"]])
    end
  else
    vim.o.wfw = true
  end
end

local function window_right()
  if vim.bo.buftype ~= "nofile" then
    vim.o.wfw = false
    vim.cmd([[execute "normal! \<C-w>l"]])
    if vim.bo.buftype ~= "nofile" then
      vim.cmd([[execute "normal! :vertical resize 126\<CR>:set wfw\<CR>\<C-w>=0"]])
    end
  else
    vim.o.wfw = true
    vim.cmd([[execute "normal! \<C-w>l"]])
    -- if vim.bo.buftype ~= "nofile" then
    --   vim.cmd([[execute "normal! :NvimTreeToggle\<CR>"]])
    -- end
  end
end

vim.keymap.set({ "n" }, "<C-h>", window_left, { silent = true })
vim.keymap.set({ "n" }, "<C-l>", window_right, { silent = true })
vim.keymap.set({ "n" }, "<C-j>", "<C-W>j", { silent = true })
vim.keymap.set({ "n" }, "<C-k>", "<C-W>k", { silent = true })
vim.keymap.set({ "n" }, "<leader><C-o>", "<C-W>x", { silent = true })
vim.keymap.set({ "n" }, "<leader><C-l>", "gt", { silent = true })
vim.keymap.set({ "n" }, "<leader><C-h>", "gT", { silent = true })
vim.keymap.set({ "n" }, "≥", "<C-W>>", { silent = true })
vim.keymap.set({ "n" }, "≤", "<C-W><lt>", { silent = true })

-- [[ Custom Configs ]]
-- TODO: Convert all the custom configs below to lua
-- Automatically restore to the last read line
-- vim.lsp.set_log_level("trace")
vim.cmd([[
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
]])

-- Reading Podfiles as Ruby files
vim.cmd([[autocmd BufNewFile,BufRead Podfile set filetype=ruby]])
vim.cmd([[autocmd BufNewFile,BufRead *.podspec set filetype=ruby]])
-- PlantUML
vim.cmd([[autocmd BufNewFile,BufRead *.puml set filetype=plantuml]])
vim.cmd([[autocmd BufNewFile,BufRead *.plantuml set filetype=plantuml]])
-- Close quickfix after selecting item
vim.cmd([[autocmd FileType qf nnoremap <buffer> <leader><CR> <CR>:cclose<CR>]])
-- Copilot
vim.cmd([[imap <silent><script><expr> <C-J> copilot#Accept("\<C-N>")]])
vim.g.copilot_no_tab_map = true
vim.g.copilot_filetypes = { markdown = true }
-- Markdown syntax highlighting
vim.cmd([[au BufNewFile,BufRead *.md set filetype=markdown]])
vim.g.markdown_fenced_languages = {
  "html",
  "python",
  "bash=sh",
  "ts=typescript",
  "tsx=typescriptreact",
  "typescript",
  "js=javascript",
  "javascript",
  "console=sh",
  "shell=sh",
  "json",
  "css",
  "scss",
  "yaml",
  "ruby",
  "go",
  "rust",
  "java",
  "c",
  "cpp",
  "erlang",
  "haskell",
}

-- [[Plugin setups]]
-- nvim-dap-python
local dap_python = require("dap-python")
dap_python.setup("~/.virtualenvs/debugpy/bin/python")
dap_python.test_runner = "pytest"

require("dapui").setup()
require("nvim-dap-virtual-text").setup({})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- disabling justMyCode
local configurations = dap.configurations.python
for _, configuration in pairs(configurations) do
  configuration.justMyCode = false
end

-- Null-ls
local null_ls = require("null-ls")
null_ls.setup({
  debug = true,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.completion.spell,
    null_ls.builtins.formatting.black.with({
      extra_args = { "--line-length", "120" },
    }),
    null_ls.builtins.formatting.prettierd.with({
      filetypes = { "json", "css", "scss", "html", "markdown" },
    }),
    null_ls.builtins.formatting.eslint_d.with({
      cwd = function(params)
        local ret = require("null-ls.utils").root_pattern(
        -- https://eslint.org/docs/latest/user-guide/configuring/configuration-files-new
          "eslint.config.js",
          -- https://eslint.org/docs/user-guide/configuring/configuration-files#configuration-file-formats
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "package.json"
        )(params.bufname)
        return ret
      end,
    }),
    null_ls.builtins.diagnostics.eslint_d,
  },
})

-- Format
vim.keymap.set("n", "<leader>l", function()
  print("Formatting...")
  vim.lsp.buf.format({
    filter = function(client)
      print(client.name)
      return client.name ~= "tsserver"
    end,
  })
end, { desc = "[F]ormat" })

-- Autopairs
require("nvim-autopairs").setup({})

-- Snippets to use with LuaSnip
require("luasnip.loaders.from_vscode").lazy_load()

-- Fancy icons
require("nvim-web-devicons").setup()

-- Nvim Tree
-- See :help nvim-tree
require("nvim-tree").setup({
  actions = {
    open_file = {
      resize_window = false,
    },
  },
  on_attach = function(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set("n", "s", api.node.open.vertical, opts("Open: Vertical Split"))
  end,
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = "gruvbox",
    section_separators = { left = "\u{E0B0}", right = "\u{E0B2}" },
    component_separators = { left = "\u{E0BD}", right = "\u{E0BD}" },
  },
  sections = {
    lualine_c = { { "filename", path = 1 } },
  },
})

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require("ibl").setup({
  enabled = false,
})
vim.keymap.set({ "n" }, "<leader>in", ":IBLToggle<CR>", { silent = true })

-- Gitsigns
-- See `:help gitsigns.txt`
require("gitsigns").setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "‾" },
    changedelete = { text = "~" },
  },
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles, { desc = "[F]ind recently [O]pened files" })
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "[F]ind existing [B]uffers" })
vim.keymap.set("n", "<leader>f/", function()
  vim.keymap.set("i", "<C-q>", require("telescope.builtin").quickfix, { desc = "Send to [Quick][F]ix" })
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "Fuzzily [F]ind in current [/] buffer]" })

vim.keymap.set("n", "<C-f>", require("telescope.builtin").live_grep, { desc = "[C-F]ind by grep" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fd", require("telescope.builtin").diagnostics, { desc = "[F]ind [D]iagnostics" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup({
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "rust",
    "typescript",
    "javascript",
    "tsx",
    "help",
    "vim",
    "prisma",
  },
  highlight = { enable = true },
  indent = { enable = true, disable = { "python" } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader><space>",
      node_incremental = "<leader><space>",
      scope_incremental = "<c-s>",
      node_decremental = "<leader><backspace>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set("n", "<F3>", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<F2>", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>dh", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>qf", vim.diagnostic.setqflist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

  nmap("<C-b>", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("<F7>", require("telescope.builtin").lsp_references, "[F]ind [R]eferences")
  nmap("<leader>gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>gt", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")
  nmap("<leader>fs", require("telescope.builtin").lsp_document_symbols, "[F]ind [S]ymbols")
  nmap("<leader>fws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[F]ind [W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("<leader>h", vim.lsp.buf.hover, "Hover Documentation")
  nmap("<leader>s", vim.lsp.buf.signature_help, "Signature Documentation")

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
  nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  yamlls = {
    settings = {
      yaml = {
        schemas = {
          -- DevOps
          ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.yml",
          -- JavaScript
          ["https://json.schemastore.org/prettierrc"] = ".prettierrc",
          ["https://json.schemastore.org/eslintrc"] = ".eslintrc",
          ["https://json.schemastore.org/tsconfig"] = "tsconfig.json",
          ["https://json.schemastore.org/lerna"] = "lerna.json",
          -- Python
          ["https://json.schemastore.org/pyrightconfig"] = "pyrightconfig.json",
          ["https://json.schemastore.org/pyproject"] = "pyproject.toml",
          -- Docker
          ["https://json.schemastore.org/docker-compose"] = "docker-compose.yml",
          ["https://json.schemastore.org/dockerfile"] = "Dockerfile",
          -- Helm
          ["https://json.schemastore.org/helmfile"] = "helmfile.yml",
          -- K8s
          ["https://json.schemastore.org/kustomization"] = "kustomization.yml",
          ["https://json.schemastore.org/kubeval"] = "kubeval.json",
          ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
          "/*.k8s.yml",
        },
      },
    },
  },
  prismals = {},
  clangd = {},
  gopls = {},
  pyright = {},
  jsonls = {},
  rust_analyzer = {},
  tsserver = {},
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require("mason").setup()

-- Ensure the servers above are installed
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

mason_lspconfig.setup_handlers({
  function(server_name)
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end,
  ["pyright"] = function()
    require("lspconfig")["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers["pyright"],
      -- cmd = { 'node', '/Users/andre/dev/other/pyright/packages/pyright/dist/pyright-langserver.js',
      --   '--stdio' }, -- node --inspect-brk /Users/andre/dev/other/pyright/packages/pyright/dist/pyright-langserver.js --stdio
    })
  end,
})

-- Turn on lsp status information
require("fidget").setup()

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete({ reason = "manual" }),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
