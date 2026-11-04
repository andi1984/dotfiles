-- External tools this config expects, in one place.
--
--   vim/install.sh       installs everything (blocking) via M.install_sync()
--   on startup           missing mason packages install in the background
--
-- System tools not managed here: git, rg, a C compiler (treesitter parsers),
-- uv (Python tools), rustup's rust-analyzer/rustfmt, deno.
local M = {}

-- nvim-treesitter (main) parsers
M.parsers = {
  "typescript", "javascript", "tsx", "vue", "html", "css", "scss",
  "lua", "vim", "vimdoc", "query",
  "go", "rust", "python", "java", "kotlin",
  "json", "yaml", "toml", "markdown", "markdown_inline",
  "bash", "graphql", "dockerfile", "astro", "twig", "styled",
  "regex", "jsdoc", "diff", "gitcommit",
}

-- mason packages; `needs` skips a package when its runtime is missing
M.mason = {
  "tree-sitter-cli", -- builds the parsers above
  -- language servers
  "vtsls",
  "vue-language-server",
  "eslint-lsp",
  "tailwindcss-language-server",
  { "gopls", needs = "go" },
  { "jdtls", needs = "java" },
  { "kotlin-lsp", needs = "java" },
  -- formatters (conform)
  "prettier",
  { "goimports", needs = "go" },
}

-- Python tools via `uv tool install` (mason's pypi installs need python3-venv)
M.uv = { "basedpyright", "ruff" }

local function wanted()
  local names = {}
  for _, entry in ipairs(M.mason) do
    local name, needs = entry, nil
    if type(entry) == "table" then name, needs = entry[1], entry.needs end
    if not needs or vim.fn.executable(needs) == 1 then table.insert(names, name) end
  end
  return names
end

--- Install missing mason packages; on_done(failed) runs once all finished.
---@param on_done? fun(failed: string[])
function M.install_mason(on_done)
  local registry = require("mason-registry")
  registry.refresh(function()
    local pending, failed = 0, {}
    local function finish()
      if pending == 0 and on_done then on_done(failed) end
    end
    for _, name in ipairs(wanted()) do
      local ok, pkg = pcall(registry.get_package, name)
      if not ok then
        table.insert(failed, name .. " (not in registry)")
      elseif not pkg:is_installed() and not pkg:is_installing() then
        pending = pending + 1
        vim.notify("mason: installing " .. name)
        pkg:install({}, function(success)
          vim.schedule(function()
            pending = pending - 1
            if not success then table.insert(failed, name) end
            finish()
          end)
        end)
      end
    end
    finish()
  end)
end

--- Blocking install for vim/install.sh: mason packages, then parsers.
--- Exits Neovim with status 1 if anything failed.
function M.install_sync()
  local timeout = 15 * 60 * 1000
  local done, failed = false, {}
  M.install_mason(function(f) failed, done = f, true end)
  if not vim.wait(timeout, function() return done end, 200) then
    table.insert(failed, "mason (timed out)")
  end

  if vim.fn.executable("uv") == 1 then
    for _, tool in ipairs(M.uv) do
      local res = vim.system({ "uv", "tool", "install", "--quiet", tool }, { text = true }):wait()
      if res.code ~= 0 then table.insert(failed, "uv " .. tool) end
    end
  else
    io.stdout:write("uv not found, skipping: " .. table.concat(M.uv, ", ") .. "\n")
  end

  require("nvim-treesitter").install(M.parsers):wait(timeout)
  local installed = require("nvim-treesitter").get_installed()
  for _, parser in ipairs(M.parsers) do
    if not vim.list_contains(installed, parser) then table.insert(failed, "parser " .. parser) end
  end

  if #failed > 0 then
    io.stderr:write("failed: " .. table.concat(failed, ", ") .. "\n")
    vim.cmd("cquit 1")
  end
  io.stdout:write(("tools: %d mason packages, %d uv tools, %d parsers ok\n"):format(#wanted(), #M.uv, #M.parsers))
  vim.cmd("qall!")
end

return M
