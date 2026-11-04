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

-- TypeScript / JavaScript / Vue
--
--   project TypeScript < 7 (or none) -> vtsls (wraps tsserver; also serves Vue)
--   project TypeScript >= 7          -> tsc --lsp (native TS 7 server, no tsserver)
--   Deno projects                    -> denols (both configs exclude Deno roots)
--
-- The version comes from the nearest node_modules/typescript/package.json.
local function ts_major(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  local pkg = vim.fs.find('node_modules/typescript/package.json', { path = vim.fs.dirname(fname), upward = true })[1]
  if not pkg then return nil end
  local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(pkg), '\n'))
  local version = ok and data and vim.version.parse(data.version or '')
  return version and version.major or nil
end

local function is_ts7(bufnr)
  local major = ts_major(bufnr)
  return major ~= nil and major >= 7
end

local vtsls_root = vim.lsp.config.vtsls.root_dir
vim.lsp.config('vtsls', {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
  root_dir = function(bufnr, on_dir)
    if not is_ts7(bufnr) then vtsls_root(bufnr, on_dir) end
  end,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true, -- the project's TypeScript, else vtsls' bundled one
      tsserver = {
        -- Vue hybrid mode: vue_ls forwards TS requests in .vue files to vtsls
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

local tsc_root = vim.lsp.config.tsc.root_dir
vim.lsp.config('tsc', {
  -- lspconfig would warn in every pre-7 project; only try where TS 7 is installed
  root_dir = function(bufnr, on_dir)
    if is_ts7(bufnr) then tsc_root(bufnr, on_dir) end
  end,
  -- lspconfig caches the binary inside lsp/tsc.lua, but every access to
  -- vim.lsp.config.tsc reloads that file, so its cmd never sees the cache
  -- and falls back to a global `tsc`. Start the project's binary directly.
  cmd = function(dispatchers, config)
    local bin = vim.fs.find('node_modules/.bin/tsc', { path = config.root_dir, upward = true })[1] or 'tsc'
    return vim.lsp.rpc.start({ bin, '--lsp', '--stdio' }, dispatchers, { cwd = config.root_dir })
  end,
})

-- eslint: vscode-eslint-language-server (mason `eslint-lsp`); lspconfig only
-- starts it in projects with an eslint config.
vim.lsp.enable({
  'rust_analyzer', 'denols', 'basedpyright', 'ruff', 'gopls', 'vue_ls', 'vtsls', 'tsc',
  'tailwindcss', 'eslint', 'jdtls', 'kotlin_lsp',
})
