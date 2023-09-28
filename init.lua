-- Neovim config

-- Options
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.guicursor = "a:blinkon1"
vim.opt.clipboard = "unnamedplus"
vim.opt.wildmenu = true
vim.opt.wildignore:prepend("node_modules/**")
vim.opt.backspace = "indent,eol,start"
vim.opt.gdefault = true
vim.opt.binary = true
vim.opt.eol = false
vim.opt.swapfile = false
vim.opt.modeline = true
vim.opt.modelines = 4
vim.opt.wrap = false
vim.opt.cursorline = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.expandtab = true

vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", eol = "¬", nbsp = "_" }
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.errorbells = false
vim.opt.startofline = false
vim.opt.ruler = true
vim.opt.shortmess = { a = true, t = true, I = true }
vim.opt.showmode = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.scrolloff = 0
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.background = "dark"

vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes:1"
vim.opt.laststatus = 3
-- vim.opt.winbar = "%m %f"

vim.opt.backupdir = ".backups"
vim.opt.undodir = ".undo"
vim.opt.syntax = "off"
-- "set fo-=t

-- Mappings

-- Map Leader to <space>
vim.keymap.set("n", "<space>", "<nop>", { noremap = true })
vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	"tpope/vim-fugitive",

	"nvim-lua/plenary.nvim",
	"nvim-treesitter/nvim-treesitter",

	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/cmp-calc",
	"hrsh7th/cmp-nvim-lsp-signature-help",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"morhetz/gruvbox",
	"jose-elias-alvarez/null-ls.nvim",

	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	},

	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = "^$",

				-- toggler = {
				--   line = '<leader>cc', ---Line-comment toggle keymap
				--   block = '<leader>bc', ---Block-comment toggle keymap
				-- },
				-- opleader = {
				--   line = '<leader>c', ---Line-comment keymap
				--   block = '<leader>b', ---Block-comment keymap
				-- },

				-- mappings = {
				--   basic = true,
				--   extra = true
				-- },

				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	},

	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "horizon",
					icons_enabled = false,
					section_separators = "",
					component_separators = "|",
					disabled_filetypes = {},
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "%f%m" },
					lualine_c = {},
					lualine_x = { "diagnostics", "branch", "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = { "%f%m" },
					lualine_c = {},
					lualine_x = { "filetype", "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},

	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				version = "^1.0.0",
			},
		},
		config = function()
			local actions = require("telescope.actions")
			local telescope = require("telescope")

			telescope.load_extension("live_grep_args")

			telescope.setup({
				defaults = {
					--layout_config = {
					--  vertical = { width = 0.5 }
					--},

					file_ignore_patterns = { "node_modules" },

					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<esc>"] = actions.close,
							["<C-u>"] = false,
						},
					},
				},
			})
		end,
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup()
		end,
	},

	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
					-- height and width can be:
					-- * an absolute number of cells when > 1
					-- * a percentage of the width / height of the editor when <= 1
					-- * a function that returns the width or the height
					width = 80, -- width of the Zen window
					height = 1, -- height of the Zen window
					-- by default, no options are changed for the Zen window
					-- uncomment any of the options below, or add other vim.wo options you want to apply
					options = {
						signcolumn = "no", -- disable signcolumn
						number = false, -- disable number column
						relativenumber = false, -- disable relative numbers
						cursorcolumn = false, -- disable cursor column
						--cursorline = false, -- disable cursorline
						colorcolumn = "",
						list = false, -- disable whitespace characters
						-- foldcolumn = "0", -- disable fold column
					},
				},
				plugins = {
					-- disable some global vim options (vim.o...)
					-- comment the lines to not apply the options
					options = {
						enabled = true,
						ruler = false, -- disables the ruler text in the cmd line area
						showcmd = false, -- disables the command in the last line of the screen
					},
					--twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
					--gitsigns = { enabled = false }, -- disables git signs
					tmux = { enabled = true }, -- disables the tmux statusline
					-- this will change the font size on kitty when in zen mode
					-- to make this work, you need to set the following kitty options:
					-- - allow_remote_control socket-only
					-- - listen_on unix:/tmp/kitty
					-- this will change the font size on alacritty when in zen mode
					-- requires  Alacritty Version 0.10.0 or higher
					-- uses `alacritty msg` subcommand to change font size
					--alacritty = {
					--  enabled = true,
					--  font = "11", -- font size
					--},
				},
				-- callback where you can add custom code when the Zen window opens
				on_open = function(_) end,
				-- callback where you can add custom code when the Zen window closes
				on_close = function() end,
			})
		end,
	},
})

vim.cmd([[colorscheme gruvbox]])
vim.cmd("highligh Normal guibg=NONE ctermbg=NONE")
vim.cmd("highligh clear SignColumn")
vim.cmd("highlight ColorColumn ctermbg=black")
vim.cmd("highligh WinSeparator guibg=None")

vim.cmd("highligh LspReferenceRead ctermbg=237 guibg=#303030")
vim.cmd("highligh LspReferenceText ctermbg=237 guibg=#303030")
vim.cmd("highligh LspReferenceWrite ctermbg=237 guibg=#303030")
vim.cmd("highligh DiagnosticError ctermfg=1 guifg=#f87171")

-- Inactive buffer winbar
vim.cmd("highligh WinBarNC guifg=#ffffff guibg=default")

-- Active buffer winbar
vim.cmd("highligh WinBar guifg=#000000 guibg=#ffffff")

vim.g.gruvbox_constrast_dark = "hard"
-- vim.g.copilot_enabled = "v:false"

-- Leader mappings
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

vim.keymap.set("n", "<leader><space>", ":nohl<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>*", live_grep_args_shortcuts.grep_word_under_cursor)

-- Unmap arrow keys
vim.keymap.set("n", "<up>", "<nop>")
vim.keymap.set("n", "<down>", "<nop>")
vim.keymap.set("n", "<left>", "<nop>")
vim.keymap.set("n", "<right>", "<nop>")
vim.keymap.set("i", "<up>", "<nop>")
vim.keymap.set("i", "<down>", "<nop>")
vim.keymap.set("i", "<left>", "<nop>")
vim.keymap.set("i", "<right>", "<nop>")

-- Move lines in visual mode
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Telescope
vim.keymap.set("n", "<c-p>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>gd", ":lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gh", ":lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>gsh", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>ga", ":lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", ":lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })
vim.keymap.set(
	"n",
	"<leader>grr",
	":lua require('telescope.builtin').lsp_references()<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>gi",
	":lua require('telescope.builtin').lsp_implementations()<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set("n", "<leader>snd", ":lua vim.diagnostic.goto_next()<CR>", { silent = true })
-- "nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
-- "nnoremap <leader>vsd :lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

-- Center highlighted word
vim.keymap.set("n", "G", "Gzz", {})
vim.keymap.set("n", "n", "nzz", {})
vim.keymap.set("n", "N", "Nzz", {})
vim.keymap.set("n", "}", "}zz", {})
vim.keymap.set("n", "{", "{zz", {})

-- Better indentation
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Windows navigation
vim.keymap.set("", "<c-j>", "<c-w>j", {})
vim.keymap.set("", "<c-k>", "<c-w>k", {})
vim.keymap.set("", "<c-l>", "<c-w>l", {})
vim.keymap.set("", "<c-h>", "<c-w>h", {})

-- Tabs navigation
vim.keymap.set("n", "tl", ":tabnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "th", ":tabprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "tn", ":tabnew<CR>", { noremap = true, silent = true })

-- Nvim tree
vim.keymap.set("", "<c-e>", ":NvimTreeFindFileToggle<CR>", { silent = true })

local cmd_group = vim.api.nvim_create_augroup("autocmds", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	callback = function()
		-- skip if a pop up window
		if vim.fn.win_gettype() == "popup" then
			return
		end

		-- skip if new buffer
		if vim.bo.filetype == "" then
			return
		end

		-- Skip if there is only one window
		local win_list = vim.api.nvim_tabpage_list_wins(0)
		if #win_list == 1 then
			-- TODO: Remove winbar from the remaining window
			return
		else
			-- Add winbar to all windows in tabpage
			for _, win_id in ipairs(win_list) do
				vim.api.nvim_set_option_value("winbar", "%m %f", { win = win_id })
			end
			return
		end

		-- vim.api.nvim_set_option_value("winbar", "", { win = "win_id" })
		-- vim.fn.getwininfo(win_id)
		-- vim.fn.bufnr()
		-- vim.api.nvim_win_get_number(0)
		-- vim.api.nvim_win_get_config(0)
		-- vim.api.nvim_win_list_bufs()
		-- vim.api.nvim_win_get_buf(0)
		-- vim.api.nvim_buf_is_valid(0)
		-- vim.api.nvim_buf_is_loaded(0)
		-- vim.wo.winbar = "%m %f"
	end,
	group = cmd_group,
})
