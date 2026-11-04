-- Editing helpers: text objects, pairs, alignment, refactoring, search & replace
return {
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    },
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    config = true,
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    -- Context-aware commentstring (JSX, Vue, embedded CSS...) for Neovim's
    -- built-in gc/gcc commenting.
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    opts = { enable_autocmd = false },
    init = function()
      local get_option = vim.filetype.get_option
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end, mode = "v", desc = "Extract function" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, mode = "v", desc = "Extract variable" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = true,
  },
  {
    -- Project-wide search & replace with a live preview
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>R", function()
        require("grug-far").open({
          prefills = { search = vim.fn.expand("<cword>"), flags = "--word-regexp" },
        })
      end, desc = "Replace word in project" },
    },
    opts = {},
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
        fast_wrap = {
          map = "<M-e>",
        },
      })
      -- blink.cmp adds brackets after accepted functions itself
    end,
  },
  {
    "johmsalas/text-case.nvim",
    keys = {
      { "gA", mode = { "n", "v" }, desc = "Text case" },
    },
    config = function()
      -- `ga` belongs to EasyAlign
      require("textcase").setup({ prefix = "gA" })
    end,
  },
}
