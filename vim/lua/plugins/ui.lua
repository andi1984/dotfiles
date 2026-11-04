-- Colorscheme, statusline, picker/dashboard (snacks) and other UI
return {
  {
    -- Picker, dashboard, indent guides, notifier, input and lazygit in one.
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      lazygit = { enabled = true },
      picker = { enabled = true, ui_select = true },
    },
    keys = {
      { "<leader>ff", function() Snacks.picker.files({ layout = "vertical" }) end, desc = "Find files" },
      { "<leader>fb", function() Snacks.picker.buffers({ layout = "vertical" }) end, desc = "Buffers" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fi", function() Snacks.picker.grep() end, desc = "Ripgrep search" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      -- was fzf.vim :Find - fixed strings, hidden files, from the git root
      { "<leader>fa", function()
        Snacks.picker.grep({ regex = false, hidden = true, cwd = Snacks.git.get_root() })
      end, desc = "Grep literal (git root)" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor", mode = { "n", "x" } },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Jump to LSP symbol" },
      { "<leader>lg", function() Snacks.lazygit() end, desc = "LazyGit" },
    },
    init = function()
      -- LSP progress in the notifier (replaces fidget.nvim)
      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
            id = "lsp_progress",
            title = "LSP Progress",
            opts = function(notif)
              notif.icon = ev.data.params.value.kind == "end" and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.add({
        {
          mode = { "n", "v" },
          { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
          { "<leader>w", "<cmd>w<cr>", desc = "Write" },
        }
      })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          zsh = { icon = "", color = "#428850", cterm_color = "65", name = "Zsh" }
        },
        default = true,
      })
    end,
  },
  { "comfysage/evergarden", lazy = true, priority = 1000 },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    -- Highlights hex/rgb/hsl/named colors in place
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
}
