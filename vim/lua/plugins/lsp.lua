-- Language servers, formatting and diagnostics (server overrides: config/lsp.lua)
return {
  {
    "mason-org/mason.nvim",
    lazy = false, -- puts mason/bin on PATH before any LSP/formatter starts
    config = true,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = { "mason-org/mason.nvim" },
    -- config/lsp.lua decides which servers run; mason only puts binaries on PATH
    opts = { automatic_enable = false },
  },
  {
    -- Server defaults only (lsp/*.lua: cmd, filetypes, root detection).
    -- Overrides and vim.lsp.enable() live in config/lsp.lua.
    "neovim/nvim-lspconfig",
    lazy = false,
  },
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("typescript-tools").setup({
        settings = {
          separate_diagnostic_server = true,
          publish_diagnostic_on = "insert_leave",
          tsserver_max_memory = "auto",
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          code_lens = "off",
          jsx_close_tag = { enable = false },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        root_dir = function(bufnr, on_dir)
          local node_root = vim.fs.root(bufnr, { "package.json", "node_modules" })
          if not node_root then
            on_dir(nil)
            return
          end
          local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc", "import_map.json", "denops" })
          if deno_root and #deno_root <= #node_root then
            on_dir(nil)
            return
          end
          on_dir(node_root)
        end,
        single_file_support = false,
      })
    end,
  },
  {
    -- Format on save (replaces ALE fixers). Linting comes from LSP servers.
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>F", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format buffer" },
    },
    config = function()
      local function read(path)
        local f = io.open(path, "r")
        if not f then return "" end
        local content = f:read("*a")
        f:close()
        return content
      end

      -- Python: use the formatter the project configures, else ruff_format.
      local function python_formatters(bufnr)
        local root = vim.fs.root(bufnr, {
          "pyproject.toml", "setup.cfg", "tox.ini", "ruff.toml", ".ruff.toml",
          ".style.yapf", ".isort.cfg", ".pre-commit-config.yaml", ".git",
        })
        if not root then return { "ruff_format" } end

        local function exists(name) return vim.uv.fs_stat(root .. "/" .. name) ~= nil end
        local pyproject = read(root .. "/pyproject.toml")
        local setup_cfg = read(root .. "/setup.cfg") .. read(root .. "/tox.ini")
        local precommit = read(root .. "/.pre-commit-config.yaml")

        local isort = pyproject:find("%[tool%.isort%]") or exists(".isort.cfg")
          or setup_cfg:find("%[isort%]") or precommit:find("id:%s*isort")
        local function with_isort(formatter)
          return isort and { "isort", formatter } or { formatter }
        end

        if pyproject:find("%[tool%.black%]") or precommit:find("id:%s*black") then
          return with_isort("black")
        elseif pyproject:find("%[tool%.yapf%]") or exists(".style.yapf") or setup_cfg:find("%[yapf%]") then
          return with_isort("yapf")
        elseif pyproject:find("%[tool%.autopep8%]") or setup_cfg:find("%[autopep8%]") then
          return with_isort("autopep8")
        elseif pyproject:find("%[tool%.ruff") or exists("ruff.toml") or exists(".ruff.toml")
          or precommit:find("id:%s*ruff%-format") then
          -- `ruff format` doesn't sort imports; apply ruff's isort rule (I) first,
          -- honouring [tool.ruff.lint.isort].
          return { "ruff_organize_imports", "ruff_format" }
        elseif vim.uv.fs_stat(root .. "/.venv/bin/black") then
          return with_isort("black")
        end
        return with_isort("ruff_format")
      end

      -- Prefer the project's .venv binary over $PATH (like ALE did).
      local function venv_command(name)
        return function(_, ctx)
          local root = vim.fs.root(ctx.buf, ".venv")
          local bin = root and (root .. "/.venv/bin/" .. name)
          if bin and vim.fn.executable(bin) == 1 then return bin end
          return name
        end
      end

      local prettier = { "prettier" } -- conform prefers node_modules/.bin/prettier
      require("conform").setup({
        formatters_by_ft = {
          javascript = prettier,
          javascriptreact = prettier,
          typescript = prettier,
          typescriptreact = prettier,
          css = prettier,
          vue = prettier,
          rust = { "rustfmt" },
          go = { "goimports", "gofmt", stop_after_first = true },
          python = python_formatters,
        },
        formatters = {
          black = { command = venv_command("black") },
          isort = { command = venv_command("isort") },
          yapf = { command = venv_command("yapf") },
          autopep8 = { command = venv_command("autopep8") },
          ruff_format = { command = venv_command("ruff") },
          ruff_organize_imports = { command = venv_command("ruff") },
        },
        format_on_save = { timeout_ms = 2000, lsp_format = "never" },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>dl", "<cmd>Trouble<cr>", desc = "Diagnostics list" },
    },
    config = function()
      require("trouble").setup({
        auto_close = false,
        auto_open = false,
        auto_preview = true,
        focus = true,
        icons = { folder_closed = " ", folder_open = " " },
      })
    end,
  },
}
