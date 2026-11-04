-- Language- and filetype-specific plugins
return {
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "astro" },
  },
  {
    -- Rename the paired tag while editing one (like tagalong). Auto-closing
    -- stays off, matching typescript-tools' jsx_close_tag = false.
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascriptreact", "typescriptreact", "vue", "astro" },
    opts = {
      opts = {
        enable_close = false,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
  {
    "David-Kunz/jester",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    keys = {
      { "<leader>jj", function() require("jester").run_file() end, desc = "Run Jest file" },
    },
  },
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup()
    end,
  },
  {
    "nikvdp/ejs-syntax",
    ft = "ejs",
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}
