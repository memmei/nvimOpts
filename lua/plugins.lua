-- C:\Users\{users}\AppData\Local\nvim\lua\plugins.lua

return {
	-- Gruvbox Material
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_background = "hard"
			vim.cmd([[colorscheme gruvbox-material]])
		end,
	},

	-- LSP マネージャー & 自動インストーラー
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = { ui = { border = "rounded" } },
			},
		},
		config = function()
			require("mason").setup()

			-- LSPやフォーマッタの自動導入設定
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP
					"lua_ls",
					"marksman",
					"bashls",
					"ts_ls",
					-- フォーマッタ
					"stylua",
					"prettier",
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "marksman", "bashls", "ts_ls" },
			})

			vim.lsp.config("lua_ls", {
				cmd = { "lua-language-server" },
				root_markers = { ".git", ".luarc.json" },
				filetypes = { "lua" },
			})

			vim.lsp.config("marksman", {
				cmd = { "marksman", "server" },
				root_markers = { ".git", ".marksman.toml" },
				filetypes = { "markdown" },
			})

			vim.lsp.config("bashls", {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
			})

			vim.lsp.config("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_markers = { "tsconfig.json", "package.json", ".git" },
			})

			vim.lsp.enable({ "lua_ls", "marksman", "bashls", "ts_ls" })

			-- --- LSPのキーマップ設定 ---
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- 定義へジャンプ
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts) -- 参照一覧
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- ホバー
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- リネーム
				end,
			})
		end,
	},

	-- ファイル検索 (Telescope)
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope find files" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
			{ "<leader>lg", "<cmd>Telescope live_grep<cr>", desc = "Telescope live grep" },
		},
	},

	-- ファイル操作ファイラ (oil.nvim)
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
			keymaps = {
				["<C-t>"] = false, -- 「新規タブで開く」を無効化する
			},
		},
		keys = {
			{ "<leader>o", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
	},

	-- ターミナル (ToggleTerm)
	{
		"akinsho/toggleterm.nvim",
		keys = {
			{ "<C-t>", "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
			{ "<C-[>", [[<C-\><C-n>]], mode = "t", desc = "Escape terminal mode" },
		},
		opts = {
			shell = "bash",
			direction = "float",
			open_mapping = [[<C-t>]],
		},
	},

	-- コメントアウト (Comment.nvim)
	{
		"numToStr/Comment.nvim",
	},

	-- コードフォーマッタ (conform.nvim)
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>lf",
				function()
					require("conform").format({ lsp_fallback = true, async = true, timeout_ms = 500 })
				end,
				mode = { "n", "v" },
				desc = "Format file",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "prettier" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
			},
		},
	},

	-- シンタックスハイライト (Treesitter)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter",
		opts = {
			ensure_installed = {
				"lua",
				"markdown",
				"markdown_inline",
				"bash",
				"vim",
				"vimdoc",
				"javascript",
				"typescript",
				"tsx",
			},
		},
	},

	-- git changed (Diffview)
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History (Current)" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Git Diffview Close" },
		},
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
				},
			},
		},
	},

	-- 補完プラグイン (nvim-cmp)
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(), -- 次の候補
					["<C-p>"] = cmp.mapping.select_prev_item(), -- 前の候補
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 確定
					["<C-e>"] = cmp.mapping.abort(), -- 補完ウィンドウを閉じる
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				},
			})
		end,
	},

	-- git操作 (vim-fugitive)
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "G" },
		keys = {
			{ "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
		},
	},
}
