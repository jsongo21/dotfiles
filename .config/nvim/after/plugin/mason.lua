require("mason-lspconfig").setup {
  ensure_installed = {
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "tailwindcss",
    "tsserver",
    "vimls",
    "yamlls"
  }
}
