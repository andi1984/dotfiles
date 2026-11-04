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
    "abecodes/tabout.nvim",
    event = "InsertEnter",
    config = true,
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
    -- Needs the lazygit binary on $PATH
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
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
            vim.schedule(function() gs.nav_hunk("next") end)
            return "<Ignore>"
          end, { expr = true, desc = "Next hunk" })
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.nav_hunk("prev") end)
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
  -- AI / Chat & Completion (Copilot subscription cancelled -> Mistral/OpenAI backed)
  --------------------------------------------------------------------------------
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { "CopilotChat", "CopilotChatOpen", "CopilotChatToggle", "CopilotChatModels" },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "AI Chat" },
      { "<leader>ae", desc = "AI Explain" },
      { "<leader>ar", desc = "AI Review" },
      { "<leader>at", desc = "AI Tests" },
      { "<leader>af", desc = "AI Fix" },
      { "<leader>ao", desc = "AI Optimize" },
      { "<leader>ad", desc = "AI Documentation" },
      { "<leader>ac", desc = "AI Generate Commit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.copilot-chat")
    end,
  },
  {
    "HakonHarnes/img-clip.nvim",
    cmd = "PasteImage",
    config = true,
  },
  {
    "coder/claudecode.nvim",
    cmd = { "ClaudeCode", "ClaudeCodeFocus", "ClaudeCodeAdd", "ClaudeCodeSend", "ClaudeCodeDiffAccept", "ClaudeCodeDiffDeny" },
    keys = {
      { "<leader>cA", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
      { "<leader>cF", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>cy", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude diff" },
      { "<leader>cn", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny Claude diff" },
    },
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

  --------------------------------------------------------------------------------
  -- FZF (keeping for :Rg command)
  --------------------------------------------------------------------------------
  {
    "junegunn/fzf",
    build = "./install --bin", -- --all would rewrite ~/.fzf.bash (symlinked into this repo)
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

  --------------------------------------------------------------------------------
  -- WebDev plugins
  --------------------------------------------------------------------------------
  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "astro" },
  },
  {
    "AndrewRadev/tagalong.vim",
    ft = { "html", "xml", "jsx", "javascriptreact", "typescriptreact", "vue" },
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
      { "<leader>/", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comment" },
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
    "saghen/blink.cmp",
    version = "1.*", -- release tags ship the prebuilt fuzzy matcher
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "Kaiser-Yang/blink-cmp-git" },
    opts = {
      keymap = {
        -- <CR> accepts, <C-Space> opens, <C-e> closes, <C-b>/<C-f> scroll docs
        preset = "enter",
        -- leave <Tab>/<S-Tab> to tabout.nvim and native snippet jumps
        ["<Tab>"] = false,
        ["<S-Tab>"] = false,
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 300 },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { gitcommit = { "git", "buffer" } },
        providers = {
          git = { module = "blink-cmp-git", name = "Git" },
        },
      },
      cmdline = {
        completion = { menu = { auto_show = true } },
      },
      signature = { enabled = true },
    },
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
      -- blink.cmp adds brackets after accepted functions itself
    end,
  },

  --------------------------------------------------------------------------------
  -- Text manipulation
  --------------------------------------------------------------------------------
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
    "ray-x/go.nvim",
    ft = { "go", "gomod", "gowork", "gotmpl" },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("go").setup()
    end,
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
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
