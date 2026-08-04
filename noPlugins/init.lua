-- C:\Users\{users}\AppData\Local\nvim\init.lua

-- 基本設定
vim.g.mapleader = " "
vim.g.termfeatures = { osc52 = false }

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- 検索設定
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- インデント・タブ設定
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- バックアップ・スワップ設定
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- 不可視文字の設定
vim.opt.list = true
vim.opt.listchars = { trail = "□", tab = "»-" }

-- ディレクトリ設定
vim.api.nvim_set_current_dir("E:/forge")

-- キーマップ
-- インサート・ビジュアルモードでのエスケープ (fj)
vim.keymap.set({ "i", "v" }, "fj", "<Esc>", { silent = true })

-- 検索ハイライトを一時的に消す (<leader>nh)
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- スペルチェックの切り替え (<leader>sc)
vim.keymap.set("n", "<leader>sc", function()
	vim.wo.spell = not vim.wo.spell
	if vim.wo.spell then
		vim.opt_local.spelllang = { "en", "cjk" }
		vim.opt_local.spelloptions = "camel"
		print("Spell check: ON")
	else
		print("Spell check: OFF")
	end
end, { desc = "Toggle spell check" })

-- 行末のスペース削除 (<leader>tw)
local function trim_whitespace()
	local save_cursor = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", save_cursor)
	print("Trailing spaces trimmed")
end

vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, {})
vim.keymap.set("n", "<leader>tw", trim_whitespace, { desc = "Trim trailing spaces" })

-- 自動コマンド
-- Markdownファイル用のHTMLコメントハイライト設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.cmd.syntax('region htmlComment start="<!--" end="-->"')
		vim.cmd.hi("link htmlComment Comment")
	end,
})

-- カラースキーム (※必ず一番下に配置)
vim.cmd.colorscheme("evening")
