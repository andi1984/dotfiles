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

-- Python: basedpyright (installed via `uv tool install basedpyright`).
-- Resolves imports against the project's `.venv` (uv/poetry/venv) so
-- third-party packages get hover docs, go-to-definition and semantic
-- highlighting. Falls back to the system interpreter when no `.venv` exists.
local python_root_markers = {
  'pyproject.toml',
  'uv.lock',
  'setup.py',
  'setup.cfg',
  'requirements.txt',
  'Pipfile',
  'tox.ini',
  '.git',
}

local function venv_python(root)
  if not root then return nil end
  local candidate = root .. '/.venv/bin/python'
  if vim.uv.fs_stat(candidate) then
    return candidate
  end
  return nil
end

vim.lsp.config('basedpyright', {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
        typeCheckingMode = 'standard',
      },
    },
  },
  before_init = function(_, config)
    local py = venv_python(config.root_dir)
    if py then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        python = { pythonPath = py },
      })
    end
  end,
})

-- Ruff LSP: linting + formatting (installed via `uv tool install ruff`).
vim.lsp.config('ruff', {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = python_root_markers,
  init_options = {
    settings = {
      logLevel = 'info',
    },
  },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.config('vue_ls', {
  cmd = { 'vue-language-server', '--stdio' },
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

vim.lsp.config('jdtls', {
  -- mason's jdtls wrapper picks a per-project data dir automatically
  cmd = { 'jdtls' },
  filetypes = { 'java' },
  root_markers = {
    'settings.gradle', 'settings.gradle.kts',
    'build.gradle', 'build.gradle.kts',
    'pom.xml', 'mvnw', 'gradlew',
    '.git',
  },
})

-- JetBrains Kotlin LSP (mason package `kotlin-lsp`, binary `intellij-server`)
vim.lsp.config('kotlin_lsp', {
  cmd = { 'intellij-server', '--stdio' },
  filetypes = { 'kotlin' },
  root_markers = {
    'settings.gradle', 'settings.gradle.kts',
    'build.gradle', 'build.gradle.kts',
    'pom.xml', 'gradlew',
    '.git',
  },
})

-- Enable all configured servers
vim.lsp.enable({
  'rust_analyzer', 'denols', 'basedpyright', 'ruff', 'gopls', 'vue_ls', 'tailwindcss',
  'jdtls', 'kotlin_lsp',
})
