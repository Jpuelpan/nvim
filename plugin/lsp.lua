local luasnip = require("luasnip")
local cmp = require("cmp")
local nvim_lsp = require("lspconfig")

require("luasnip.loaders.from_vscode").lazy_load()

luasnip.filetype_extend("javascript", { "html" })
luasnip.filetype_extend("typescriptreact", { "html" })

vim.diagnostic.config({
	virtual_text = false,
	float = {
		scope = "line",
	},
})

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},

	sources = {
		{ name = "nvim_lsp_signature_help" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "buffer" },
		{ name = "calc" },
	},

	mapping = {
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<C-j>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-k>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(_, bufnr)
	-- local function buf_set_keymap(...)
	-- 	vim.api.nvim_buf_set_keymap(bufnr, ...)
	-- end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

nvim_lsp.lua_ls.setup({
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
			client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using
						-- (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- "${3rd}/luv/library"
							-- "${3rd}/busted/library",
						},
						-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
						-- library = vim.api.nvim_get_runtime_file("", true)
					},
				},
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end,
})

nvim_lsp.tsserver.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

nvim_lsp.html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

nvim_lsp.pyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

nvim_lsp.ruff_lsp.setup({
	capabilities = capabilities,
	on_attach = function(client, bufnr)
		-- Disable hover in favor of Pyright
		client.server_capabilities.hoverProvider = false
	end,
})

-- require("lspconfig").ruff_lsp.setup({
-- 	on_attach = function(client, bufnr)
-- 		-- Disable hover in favor of Pyright
-- 		client.server_capabilities.hoverProvider = false
-- 	end,
-- })

nvim_lsp.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- require('rust-tools').setup({
--   tools = {
--     autoSetHints = true
--   }
-- })

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting

null_ls.setup({
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					--vim.lsp.buf.formatting_sync()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,

	sources = {
		-- formatting.autopep8,
		formatting.ruff,
		formatting.rustfmt,

		null_ls.builtins.diagnostics.ruff,

		-- sources = {
		-- 	require("null-ls").builtins.diagnostics.ruff,
		-- },

		formatting.prettierd.with({
			extra_filetypes = { "prisma", "typescript", "typescriptreact" },
		}),

		require("null-ls").builtins.formatting.stylua,
		--require("null-ls").builtins.diagnostics.eslint,
		--require("null-ls").builtins.completion.spell,
	},
})
