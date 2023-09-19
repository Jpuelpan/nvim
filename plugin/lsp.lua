local luasnip = require("luasnip")
local cmp = require('cmp')

require("luasnip.loaders.from_vscode").lazy_load()

-- luasnip.filetype_extend("javascript", { "html" })
-- luasnip.filetype_extend("typescriptreact", { "html" })
--luasnip.filetype_extend("markdown", { "html" })
--luasnip.filetype_extend("markdown.mdx", { "html" })
--luasnip.filetype_extend("javascript", { "html", "javascriptreact" })

vim.diagnostic.config{
  --virtual_text = {
  --  severity = vim.diagnostic.severity.ERROR,
  --},

  virtual_text = false,

  float = {
    scope = "line"
  }
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },

  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = "nvim_lua" },
    { name = 'luasnip' },
    { name = "path" },
    { name = "buffer" },
    { name = "calc" },
  },

  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
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


-- local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
-- end

local nvim_lsp = require("lspconfig")
local configs = require("lspconfig.configs")

nvim_lsp.lua_ls.setup({})

nvim_lsp.tsserver.setup({
  -- capabilities = capabilities,
  -- on_attach = on_attach,
})

nvim_lsp.html.setup({
  -- capabilities = capabilities,
  -- on_attach = on_attach,
})

--nvim_lsp.rust_analyzer.setup{}

--nvim_lsp.pylsp.setup {
--  capabilities = capabilities,
--  on_attach = on_attach,
--}

nvim_lsp.pyright.setup({
 -- capabilities = capabilities,
 -- on_attach = on_attach,
})

nvim_lsp.ruff_lsp.setup({
  -- init_options = {
  --   settings = {
  --     -- Any extra CLI arguments for `ruff` go here.
  --     args = {},
  --   }
  -- }
})

nvim_lsp.clangd.setup({
  -- capabilities = capabilities,
  -- on_attach = on_attach,
})

-- require('rust-tools').setup({
--   tools = {
--     autoSetHints = true
--   }
-- })

--nvim_lsp.marksman.setup({
--  capabilities = capabilities,
--  on_attach = on_attach,
--  filetypes = {"markdown", "markdown.mdx"}
--})

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- local null_ls = require("null-ls")
-- local formatting = null_ls.builtins.formatting

-- null_ls.setup({
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = augroup,
--                 buffer = bufnr,
--                 callback = function()
--                     -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
--                     --vim.lsp.buf.formatting_sync()
--                     vim.lsp.buf.format({ bufnr = bufnr })
--                 end,
--             })
--         end
--     end,
--
--     sources = {
--         --formatting.yapf,
--         formatting.autopep8,
--         formatting.rustfmt,
--
--         formatting.prettierd.with {
--           extra_filetypes = { "prisma", "typescript", "typescriptreact" }
--         },
--
--         --require("null-ls").builtins.formatting.stylua,
--         --require("null-ls").builtins.diagnostics.eslint,
--         --require("null-ls").builtins.completion.spell,
--     },
-- })

--require('lspconfig').tailwindcss.setup{}
