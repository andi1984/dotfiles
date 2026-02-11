-- LSP keymaps applied when a language server attaches to a buffer
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, silent = true }

    -- Navigation (some of these are Neovim 0.11 defaults, but explicit is fine)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

    -- Diagnostics
    vim.keymap.set('n', '<Leader>dj', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<Leader>dk', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)

    -- Actions
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

    -- Seldomly used
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
  end,
})

-- LSP server configurations using Neovim 0.11 native vim.lsp.config
vim.lsp.config('rust_analyzer', {
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importGranularity = "module",
        importPrefix = "by_self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.config('denols', {
  root_markers = { "deno.json", "deno.jsonc" },
})

-- Simple servers with default config
local servers = { 'pylsp', 'vuels', 'tailwindcss', 'gopls' }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {})
end

-- Enable all configured servers
vim.lsp.enable({ 'rust_analyzer', 'denols', 'pylsp', 'vuels', 'tailwindcss', 'gopls' })
