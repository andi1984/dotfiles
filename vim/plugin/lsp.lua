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
-- NOTE: native vim.lsp.config does NOT provide default cmd/filetypes like
-- nvim-lspconfig did — each server needs them explicitly.

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
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
  cmd = { 'deno', 'lsp' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'deno.json', 'deno.jsonc' },
})

vim.lsp.config('pylsp', {
  cmd = { 'pylsp' },
  filetypes = { 'python' },
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'tox.ini',
    '.git',
  },
})

vim.lsp.config('ruff', {
  init_options = {
    settings = {
        logLevel = 'info',
    }
  }
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.config('vuels', {
  cmd = { 'vls' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
})

vim.lsp.config('tailwindcss', {
  cmd = { 'tailwindcss-language-server', '--stdio' },
  filetypes = {
    'html', 'css', 'scss', 'javascript', 'javascriptreact',
    'typescript', 'typescriptreact', 'vue', 'astro',
  },
  root_markers = {
    'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs',
    'tailwind.config.ts', 'postcss.config.js', '.git',
  },
})

-- Enable all configured servers
vim.lsp.enable({ 'rust_analyzer', 'denols', 'pylsp', 'ruff', 'gopls', 'vuels', 'tailwindcss' })
