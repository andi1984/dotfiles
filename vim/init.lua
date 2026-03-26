-- Startup optimizations
vim.loader.enable() -- Neovim 0.9+ bytecode cache

-- Disable unused providers for faster startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Leader key (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable line wrap
vim.wo.wrap = false

-- Search highlighting: only show while typing
vim.cmd("autocmd CmdlineEnter /,? :set hlsearch")
vim.cmd("autocmd CmdlineLeave /,? :set nohlsearch")

-- Load core configuration
require("plugins") -- lazy.nvim handles plugin loading
require("keymap")
require("sets")
require("opts")
require("config.lsp") -- Native Neovim 0.11 LSP config

-- Colorscheme (lazy.nvim already loaded it with priority)
vim.cmd.colorscheme("evergarden")
