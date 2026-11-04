-- Treesitter parsers, highlighting and indent
local function cli_path()
  -- tree-sitter CLI (needed to build parsers), installed locally via npm
  local cli_bin = vim.fn.stdpath("data") .. "/tree-sitter-cli/node_modules/.bin"
  if vim.uv.fs_stat(cli_bin) and not vim.env.PATH:find(cli_bin, 1, true) then
    vim.env.PATH = cli_bin .. ":" .. vim.env.PATH
  end
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main does not support lazy-loading
    build = function()
      local cli_dir = vim.fn.stdpath("data") .. "/tree-sitter-cli"
      vim.fn.mkdir(cli_dir, "p")
      vim.fn.system({ "npm", "install", "--prefix", cli_dir, "tree-sitter-cli" })
      cli_path()
      require("nvim-treesitter").update():wait(300000)
    end,
    config = function()
      cli_path()
      local ts = require("nvim-treesitter")
      local installed = ts.get_installed()
      local missing = vim.tbl_filter(function(p)
        return not vim.list_contains(installed, p)
      end, require("config.tools").parsers)
      if #missing > 0 then
        ts.install(missing) -- async, in the background
      end

      -- main: highlighting and indent are started per buffer
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
