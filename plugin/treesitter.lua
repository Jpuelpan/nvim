require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	sync_install = false,
	auto_install = true,
	ignore_install = {},

	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},

	indent = {
		enable = true,
	},

	-- indent = {
	-- 	enable = true,
	-- 	disable = { "javascript", "typescriptreact", "rust", "python" },
	-- },
})
