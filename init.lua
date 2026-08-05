-- C:\Users\{users}\AppData\Local\nvim\init.lua

-- --- 起動時 / ディレクトリ設定 ---
vim.api.nvim_set_current_dir("E:/forge")

-- --- グローバル変数設定 ---
vim.g.mapleader = " " -- <leader> キーをスペースに設定
vim.g.termfeatures = { osc52 = false }

-- --- 基本設定 ---
vim.opt.number = true -- 行番号を表示
vim.opt.termguicolors = true -- 24ビットRGBカラーを有効化
vim.opt.clipboard = "unnamedplus" -- OSのクリップボードと共有

-- --- 検索設定 ---
vim.opt.ignorecase = true -- 検索で大文字小文字を区別しない
vim.opt.smartcase = true -- 検索語に大文字が含まれる場合のみ区別する
vim.opt.hlsearch = true -- 検索結果をハイライト表示

-- --- インデント・タブ設定 ---
vim.opt.expandtab = true -- Tabキー入力をスペースに変換
vim.opt.tabstop = 4 -- Tabキーの幅をスペース4つ分にする
vim.opt.shiftwidth = 4 -- 自動インデントの幅をスペース4つ分にする

-- --- バックアップ・ファイル設定 ---
vim.opt.swapfile = false -- スワップファイルを作らない
vim.opt.backup = false -- バックアップファイルを作らない
vim.opt.writebackup = false -- 上書き保存時のバックアップを作らない

-- --- 不可視文字の設定 ---
vim.opt.list = true -- 不可視文字の表示を有効化
vim.opt.listchars = { trail = "□", tab = "»-" }

-- --- スペルチェック設定 ---
vim.opt.spell = true -- スペルチェックを有効化
vim.opt.spelllang = { "en", "cjk" } -- 英語を対象にしつつCJK文字は無視
vim.opt.spelloptions = "camel" -- キャメルケース（mixedCase）を分割して判定

-- --- キーバインド ---
-- インサート・ビジュアルモードでのエスケープ
vim.keymap.set({ "i", "v" }, "fj", "<Esc>", { silent = true, noremap = true })

-- 検索ハイライトを一時的に消す
vim.keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- スペルチェックの切り替え
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

-- 行末のスペース削除
local function trim_whitespace()
	local save_cursor = vim.fn.getpos(".")
	vim.cmd([[%s/\s\+$//e]])
	vim.fn.setpos(".", save_cursor)
	print("Trailing spaces trimmed")
end

vim.api.nvim_create_user_command("TrimWhitespace", trim_whitespace, {})
vim.keymap.set("n", "<leader>tw", trim_whitespace, { desc = "Trim trailing spaces" })

-- --- 自動コマンド---
-- Markdownファイル用のHTMLコメントハイライト設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.cmd.syntax('region htmlComment start="<!--" end="-->"')
		vim.cmd.hi("link htmlComment Comment")
	end,
})

-- --- プラグイン管理 (lazy.nvim) ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

