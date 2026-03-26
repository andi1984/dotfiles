-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  --------------------------------------------------------------------------------
  -- General
  --------------------------------------------------------------------------------
  {
    "mhinz/vim-startify",
    lazy = false, -- dashboard should load immediately
  },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup()
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
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Easy Align" },
    },
  },
  {
    "filipdutescu/renamer.nvim",
    branch = "master",
    keys = {
      { "<leader>rn", function() require("renamer").rename() end, desc = "Rename" },
    },
    config = function()
      require("renamer").setup()
    end,
  },
  {
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    config = true,
  },
  {
    "editorconfig/editorconfig-vim",
    event = "BufReadPre",
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  --------------------------------------------------------------------------------
  -- Git
  --------------------------------------------------------------------------------
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  },
  {
    "akinsho/git-conflict.nvim",
    event = "BufReadPre",
    config = true,
  },
  -- Removed vim-gitgutter (redundant with gitsigns)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "-" },
          changedelete = { text = "~" },
        },
        current_line_blame = false, -- toggle with :Gitsigns toggle_current_line_blame
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end
          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
          end, { expr = true, desc = "Prev hunk" })
          -- Actions
          map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
          map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
        end,
      })
    end,
  },

  --------------------------------------------------------------------------------
  -- AI / Copilot
  --------------------------------------------------------------------------------
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_hide_during_completion = false
      vim.g.copilot_proxy_strict_ssl = false
      vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
      vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle" },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
      { "<leader>ae", desc = "AI Explain" },
      { "<leader>ar", desc = "AI Review" },
      { "<leader>at", desc = "AI Tests" },
      { "<leader>af", desc = "AI Fix" },
      { "<leader>ao", desc = "AI Optimize" },
      { "<leader>ad", desc = "AI Documentation" },
      { "<leader>ac", desc = "AI Generate Commit" },
    },
    dependencies = { "github/copilot.vim", "nvim-lua/plenary.nvim" },
    config = function()
      require("config.copilot-chat")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    config = true,
  },

  --------------------------------------------------------------------------------
  -- Telescope Fuzzy Finder
  --------------------------------------------------------------------------------
  { "nvim-lua/plenary.nvim", lazy = true },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files({ layout_strategy = "vertical" }) end, desc = "Find files" },
      { "<leader>fb", function() require("telescope.builtin").buffers({ layout_strategy = "vertical" }) end, desc = "Buffers" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
    },
    dependencies = {
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
      require("telescope").setup()
      require("telescope").load_extension("fzy_native")
    end,
  },

  --------------------------------------------------------------------------------
  -- Themes & UI
  --------------------------------------------------------------------------------
  -- Removed vim-devicons and mini.icons (redundant)
  {
    "kyazdani42/nvim-web-devicons",
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
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = true,
  },
  { "folke/tokyonight.nvim", lazy = true },
  { "craftzdog/solarized-osaka.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "neanias/everforest-nvim", branch = "main", lazy = true },
  { "comfysage/evergarden", lazy = true, priority = 1000 },
  { "MunifTanjim/nui.nvim", lazy = true },

  --------------------------------------------------------------------------------
  -- FZF (keeping for :Rg command)
  --------------------------------------------------------------------------------
  {
    "junegunn/fzf",
    build = "./install --all",
    lazy = true,
  },
  {
    "junegunn/fzf.vim",
    cmd = { "Files", "Rg", "Buffers", "GFiles" },
    keys = {
      { "<leader>fi", ":Rg ", desc = "Ripgrep search" },
    },
    dependencies = { "junegunn/fzf" },
  },

  --------------------------------------------------------------------------------
  -- Namu (symbol picker)
  --------------------------------------------------------------------------------
  {
    "bassamsdata/namu.nvim",
    keys = {
      { "<leader>ss", ":Namu symbols<cr>", desc = "Jump to LSP symbol" },
    },
    config = function()
      require("namu").setup({
        namu_symbols = {
          enable = true,
          options = { display = { mode = "text" } },
        },
        colorscheme = { enable = false },
        ui_select = { enable = false },
      })
    end,
  },

  --------------------------------------------------------------------------------
  -- LSP & Linting
  --------------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPre",
    dependencies = { "williamboman/mason.nvim" },
    config = true,
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
    "dense-analysis/ale",
    event = "BufReadPre",
    config = function()
      vim.g.ale_lint_on_enter = 0
      vim.g.ale_lint_on_save = 1
      vim.g.ale_sign_error = "●"
      vim.g.ale_sign_warning = "."
      vim.g.ale_linters = { rust = { "analyzer" } }
      vim.g.ale_fixers = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        vue = { "prettier" },
        rust = { "rustfmt" },
      }
      vim.g.ale_fix_on_save = 1
      vim.keymap.set("n", "<C-e>", "<Plug>(ale_next_wrap)", { silent = true })
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
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    config = true,
  },

  --------------------------------------------------------------------------------
  -- Statusline (replaced vim-airline with lualine)
  --------------------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "kyazdani42/nvim-web-devicons" },
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

  --------------------------------------------------------------------------------
  -- Treesitter
  --------------------------------------------------------------------------------
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
    event = "BufReadPost",
    config = function()
      -- Ensure locally installed tree-sitter CLI is on PATH
      local cli_bin = vim.fn.stdpath("data") .. "/tree-sitter-cli/node_modules/.bin"
      if vim.uv.fs_stat(cli_bin) then
        vim.env.PATH = cli_bin .. ":" .. vim.env.PATH
      end
      require("nvim-treesitter").setup({
        ensure_installed = {
          "typescript", "javascript", "tsx", "vue", "html", "css",
          "lua", "vim", "vimdoc", "query",
          "go", "rust", "python",
          "json", "yaml", "toml", "markdown", "markdown_inline",
          "bash", "graphql", "dockerfile",
        },
      })
    end,
  },

  --------------------------------------------------------------------------------
  -- WebDev plugins
  --------------------------------------------------------------------------------
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "astro" },
  },
  {
    "styled-components/vim-styled-components",
    branch = "main",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "AndrewRadev/tagalong.vim",
    ft = { "html", "xml", "jsx", "javascriptreact", "typescriptreact", "vue" },
  },
  {
    "nelsyeung/twig.vim",
    ft = "twig",
  },
  {
    "David-Kunz/jester",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    keys = {
      { "<leader>jj", function() require("jester").run_file() end, desc = "Run Jest file" },
    },
  },
  {
    "kristijanhusak/vim-js-file-import",
    build = "npm install",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },
  {
    "jparise/vim-graphql",
    ft = { "graphql", "javascript", "typescript" },
  },
  {
    "wuelnerdotexe/vim-astro",
    ft = "astro",
  },
  {
    "vuki656/package-info.nvim",
    ft = "json",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
      require("package-info").setup()
    end,
  },

  --------------------------------------------------------------------------------
  -- Utility
  --------------------------------------------------------------------------------
  -- Replaced vim-surround with nvim-surround (Lua native)
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = true,
  },
  {
    "numToStr/Comment.nvim",
    keys = {
      { "<leader>c", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comment" },
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
    },
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
    config = function()
      require("ts_context_commentstring").setup({ enable_autocmd = false })
    end,
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiff", "Gblame", "Gwrite", "Gread" },
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
    "mhinz/vim-grepper",
    cmd = { "Grepper", "GrepperRg" },
    keys = {
      { "<leader>R", ":let @s='\\<'.expand('<cword>').'\\>'<CR>:Grepper -cword -noprompt<CR>:cfdo %s/<C-r>s//g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>", desc = "Replace word in project" },
    },
  },

  --------------------------------------------------------------------------------
  -- Autocomplete
  --------------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "petertriho/cmp-git",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
          { name = "emoji" },
        }),
      })
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({ { name = "cmp_git" } }, { { name = "buffer" } }),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  --------------------------------------------------------------------------------
  -- Autopairs (new)
  --------------------------------------------------------------------------------
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
      -- Integration with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  --------------------------------------------------------------------------------
  -- Text manipulation
  --------------------------------------------------------------------------------
  {
    "johmsalas/text-case.nvim",
    keys = {
      { "ga", mode = { "n", "v" }, desc = "Text case" },
    },
    config = function()
      require("textcase").setup()
    end,
  },
  {
    "nikvdp/ejs-syntax",
    ft = "ejs",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  --------------------------------------------------------------------------------
  -- File-specific plugins
  --------------------------------------------------------------------------------
  {
    "ekalinin/Dockerfile.vim",
    ft = { "dockerfile", "docker-compose" },
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
  },
  {
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("go").setup()
    end,
  },
  {
    "charlespascoe/vim-go-syntax",
    ft = "go",
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
}, {
  -- Lazy.nvim options for faster startup
  defaults = {
    lazy = true, -- lazy load everything by default
  },
  install = {
    colorscheme = { "evergarden", "habamax" },
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
