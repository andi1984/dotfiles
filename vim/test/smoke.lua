-- Headless smoke test for this Neovim config (run by script/test-nvim).
--
--   nvim --headless -c "luafile vim/test/smoke.lua"
--
-- Prints one "PASS <check>" / "FAIL <check>: <detail>" / "SKIP <check>: <why>"
-- line per check and exits non-zero when anything failed. Checks that need an
-- external tool (language servers, formatters) are skipped when it's missing.

local failed = 0
local function out(line) io.stdout:write(line .. "\n") end
local function check(name, ok, detail)
  if ok then
    out("PASS " .. name)
  else
    failed = failed + 1
    out("FAIL " .. name .. (detail and (": " .. detail) or ""))
  end
end
local function skip(name, why) out("SKIP " .. name .. ": " .. why) end

-- Errors from :messages plus vim.notify(ERROR) calls. snacks.notifier replaces
-- vim.notify, so plugin errors reported by lazy.nvim never reach :messages.
local seen_notifs = 0
local function error_lines()
  local text = vim.api.nvim_exec2("messages", { output = true }).output
  local lines = {}
  for line in text:gmatch("[^\n]+") do
    if line:match("E%d+:") or line:match("[Ee]rror") or line:match("stack traceback") then
      table.insert(lines, line)
    end
  end
  if _G.Snacks and Snacks.notifier then
    local history = Snacks.notifier.get_history({ filter = vim.log.levels.ERROR })
    for i = seen_notifs + 1, #history do
      table.insert(lines, (history[i].msg or ""):gsub("\n", " "):sub(1, 200))
    end
    seen_notifs = #history
  end
  return lines
end

local function wait(ms, cond) return vim.wait(ms, cond, 100) end

local tmp = vim.fn.tempname()
local function fixture(rel, content)
  local path = tmp .. "/" .. rel
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile(vim.split(content, "\n"), path)
  return path
end

local function open(path)
  vim.cmd.edit(vim.fn.fnameescape(path))
  return vim.api.nvim_get_current_buf()
end

local function client_names(buf)
  return vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = buf }))
end

-- 1. startup ------------------------------------------------------------------
vim.wait(300) -- lazy.nvim reports errors via vim.schedule
local startup_errors = error_lines()
check("startup without errors", #startup_errors == 0, table.concat(startup_errors, " | "))
check("Neovim 0.12+", vim.fn.has("nvim-0.12") == 1, tostring(vim.version()))

-- 2. every plugin loads -------------------------------------------------------
vim.cmd("messages clear")
local ok_load, load_err = pcall(vim.cmd, "Lazy! load all")
vim.wait(500)
local load_errors = error_lines()
check("all plugins load", ok_load and #load_errors == 0, load_err or table.concat(load_errors, " | "))

local lazy_problems = {}
for _, plugin in ipairs(require("lazy").plugins()) do
  if not plugin._.installed then table.insert(lazy_problems, plugin.name .. " not installed") end
end
check("all plugins installed", #lazy_problems == 0, table.concat(lazy_problems, ", "))

-- 3. treesitter ---------------------------------------------------------------
local missing_parsers = {}
local installed = require("nvim-treesitter").get_installed()
for _, parser in ipairs(require("config.tools").parsers) do
  if not vim.list_contains(installed, parser) then table.insert(missing_parsers, parser) end
end
check("treesitter parsers installed", #missing_parsers == 0, table.concat(missing_parsers, ", "))

for _, case in ipairs({
  { "lua", "hl/a.lua", "local x = 1" },
  { "typescript", "hl/a.ts", "const x: number = 1" },
  { "python", "hl/a.py", "x = 1" },
}) do
  local buf = open(fixture(case[2], case[3]))
  check("treesitter highlight: " .. case[1], vim.treesitter.highlighter.active[buf] ~= nil)
end

-- 4. LSP configs resolve --------------------------------------------------------
local bad_configs = {}
for name in pairs(vim.lsp._enabled_configs) do
  local cfg = vim.lsp.config[name]
  if not (cfg and cfg.cmd and cfg.filetypes) then table.insert(bad_configs, name) end
end
check("enabled LSP configs resolve", #bad_configs == 0, table.concat(bad_configs, ", "))

-- 5. LSP attaches in real projects ----------------------------------------------
local function attach_case(label, exe, files, expect)
  if vim.fn.executable(exe) ~= 1 then return skip("LSP " .. label, exe .. " not installed") end
  local main
  for rel, content in pairs(files) do
    local path = fixture(rel, content)
    if rel:match("main%.") then main = path end
  end
  local buf = open(main)
  local attached = wait(30000, function()
    local names = client_names(buf)
    for _, want in ipairs(expect) do
      if not vim.list_contains(names, want) then return false end
    end
    return true
  end)
  check("LSP " .. label, attached, "attached: " .. table.concat(client_names(buf), ","))
end

attach_case("TypeScript -> vtsls", "vtsls", {
  ["ts/package.json"] = "{}",
  ["ts/package-lock.json"] = "{}",
  ["ts/main.ts"] = "const x: number = 1",
}, { "vtsls" })
attach_case("Python -> basedpyright + ruff", "basedpyright-langserver", {
  ["py/pyproject.toml"] = "[project]\nname = 't'",
  ["py/main.py"] = "x = 1",
}, { "basedpyright", "ruff" })
attach_case("Deno -> denols only", "deno", {
  ["deno/deno.json"] = "{}",
  ["deno/main.ts"] = "const x: number = 1",
}, { "denols" })
if vim.fn.executable("deno") == 1 then
  local names = client_names(0)
  check("Deno project has no vtsls", not vim.list_contains(names, "vtsls"), table.concat(names, ","))
end

-- 6. formatting on save -----------------------------------------------------------
if vim.fn.executable("prettier") == 1 then
  local path = fixture("fmt/main.ts", "const  x = {a:1}")
  open(path)
  vim.cmd("silent write")
  local line = vim.fn.readfile(path)[1]
  check("format on save (prettier)", line == "const x = { a: 1 };", line)
else
  skip("format on save (prettier)", "prettier not installed")
end

-- 7. completion and picker ----------------------------------------------------------
check("blink.cmp loads", pcall(require, "blink.cmp"))
local ok_picker, picker = pcall(Snacks.picker.files, { cwd = vim.fn.stdpath("config") })
local has_items = ok_picker and wait(5000, function() return #picker:items() > 0 end)
check("snacks file picker finds files", has_items, ok_picker and nil or tostring(picker))
if ok_picker then picker:close() end

-- done ---------------------------------------------------------------------------------
vim.fn.delete(tmp, "rf")
if failed > 0 then
  out(failed .. " check(s) failed")
  vim.cmd("cquit 1")
end
vim.cmd("qall!")
