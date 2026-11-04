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
    -- nowait: don't stall waiting for the 0.11 default grn/gra/grr/gri maps
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { nowait = true }))

    -- Diagnostics
    vim.keymap.set('n', '<Leader>dj', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
    vim.keymap.set('n', '<Leader>dk', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
    vim.keymap.set('n', '<Leader>dq', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float, opts)

    -- Actions
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action, opts)

    -- Seldomly used
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>Wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>Wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<Leader>Wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
  end,
})

-- Diagnostic signs (kept from the ALE setup)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = ".",
    },
  },
})

-- Server configs: nvim-lspconfig ships the defaults (cmd, filetypes, root
-- detection) in its lsp/*.lua files. Only overrides live here; they are
-- merged on top of those defaults.

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

-- Python: basedpyright (installed via `uv tool install basedpyright`).
-- Resolves imports against the project's `.venv` (uv/poetry/venv) so
-- third-party packages get hover docs, go-to-definition and semantic
-- highlighting. Falls back to the system interpreter when no `.venv` exists.
local function venv_python(root)
  if not root then return nil end
  local candidate = root .. '/.venv/bin/python'
  if vim.uv.fs_stat(candidate) then
    return candidate
  end
  return nil
end

vim.lsp.config('basedpyright', {
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

-- Ruff LSP: linting (installed via `uv tool install ruff`).
vim.lsp.config('ruff', {
  init_options = {
    settings = {
      logLevel = 'info',
    },
  },
})

-- lspconfig falls back to any `.git` root (for Tailwind v4), which would run
-- the server in every repo. Only start with a Tailwind/PostCSS config or a
-- package.json that depends on tailwindcss.
vim.lsp.config('tailwindcss', {
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local markers = require('lspconfig.util').insert_package_json({
      'tailwind.config.js', 'tailwind.config.cjs', 'tailwind.config.mjs', 'tailwind.config.ts',
      'postcss.config.js', 'postcss.config.cjs', 'postcss.config.mjs', 'postcss.config.ts',
    }, 'tailwindcss', fname)
    local found = vim.fs.find(markers, { path = fname, upward = true })[1]
    if found then on_dir(vim.fs.dirname(found)) end
  end,
})

-- Mason's kotlin-lsp package exposes the binary as `intellij-server`
vim.lsp.config('kotlin_lsp', {
  cmd = { 'intellij-server', '--stdio' },
})

-- Vue hybrid mode: vue_ls handles templates/CSS and forwards TS requests to
-- vtsls, which loads @vue/typescript-plugin from mason's vue-language-server.
-- vtsls runs for .vue only; plain TS/JS uses typescript-tools.nvim.
vim.lsp.config('vtsls', {
  filetypes = { 'vue' },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = '@vue/typescript-plugin',
            location = vim.fn.stdpath('data')
              .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
            languages = { 'vue' },
            configNamespace = 'typescript',
          },
        },
      },
    },
  },
})

-- eslint: vscode-eslint-language-server (mason `eslint-lsp`); lspconfig only
-- starts it in projects with an eslint config.
vim.lsp.enable({
  'rust_analyzer', 'denols', 'basedpyright', 'ruff', 'gopls', 'vue_ls', 'vtsls', 'tailwindcss',
  'eslint', 'jdtls', 'kotlin_lsp',
})
