require("mason").setup()

require("mason-lspconfig").setup {
  ensure_installed = { "clangd", "emmet_language_server", "lua_ls", "pylsp", "bashls", "marksman" },
}
