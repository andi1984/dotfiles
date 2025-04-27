-- require("nvim-lsp-installer").setup {
    -- automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    -- ui = {
        -- icons = {
            -- server_installed = "✓",
            -- server_pending = "➜",
            -- server_uninstalled = "✗"
        -- }
    -- }
-- }
--
--
--
require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup()

-- After setting up mason-lspconfig you may set up servers via lspconfig
-- require("lspconfig").lua_ls.setup {}
-- require("lspconfig").rust_analyzer.setup {}
-- ...
