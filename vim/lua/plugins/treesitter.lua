-- Treesitter parsers, highlighting and indent
return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      -- Install tree-sitter CLI locally (no global npm install needed)
      local cli_dir = vim.fn.stdpath("data") .. "/tree-sitter-cli"
      vim.fn.mkdir(cli_dir, "p")
      vim.fn.system({ "npm", "install", "--prefix", cli_dir, "tree-sitter-cli" })
      vim.env.PATH = cli_dir .. "/node_modules/.bin:" .. vim.env.PATH
      vim.cmd("TSUpdate")
    end,
    -- `main` requires Neovim 0.12 (vim.list.unique). Stay on the frozen
    -- `master` branch while on 0.11; switch to `main` after upgrading.
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSUninstall" },
    config = function()
      -- Ensure locally installed tree-sitter CLI is on PATH
      local cli_bin = vim.fn.stdpath("data") .. "/tree-sitter-cli/node_modules/.bin"
      if vim.uv.fs_stat(cli_bin) then
        vim.env.PATH = cli_bin .. ":" .. vim.env.PATH
      end
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "typescript", "javascript", "tsx", "vue", "html", "css", "scss",
          "lua", "vim", "vimdoc", "query",
          "go", "rust", "python", "java", "kotlin",
          "json", "yaml", "toml", "markdown", "markdown_inline",
          "bash", "graphql", "dockerfile", "astro", "twig", "styled",
          "regex", "jsdoc", "diff", "gitcommit",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
