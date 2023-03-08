local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then return end

local on_attach = function(client, bufnr)
  -- formatting
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end
    })
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local lsp_flags = {
  debounce_text_changes = 150,
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false
      },
    },
  },
}

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  cmd = { "typescript-language-server", "--stdio" },
  capabilities = capabilities
}

nvim_lsp.html.setup {
  capabilities = capabilities,
}

nvim_lsp.cssls.setup {
  capabilities = capabilities,
}

nvim_lsp.pyright.setup {
  on_attach = on_attach,
  flags = lsp_flags,
}

nvim_lsp.astro.setup {}

nvim_lsp.clangd.setup {}
