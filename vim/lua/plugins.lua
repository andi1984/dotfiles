local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

--------------------------------------------------------------------------------
-- General
--------------------------------------------------------------------------------
Plug 'mhinz/vim-startify';
Plug 'norcalli/nvim-colorizer.lua'
Plug 'folke/which-key.nvim'
Plug 'junegunn/vim-easy-align'
Plug('filipdutescu/renamer.nvim', {['branch'] = 'master' })
Plug 'abecodes/tabout.nvim';
Plug 'editorconfig/editorconfig-vim'
Plug 'lukas-reineke/indent-blankline.nvim'
--------------------------------------------------------------------------------
-- Git
--------------------------------------------------------------------------------
Plug 'whiteinge/diffconflicts';
Plug 'akinsho/git-conflict.nvim';
Plug 'airblade/vim-gitgutter';

--------------------------------------------------------------------------------
-- Telescope Fuzzy Finder
--------------------------------------------------------------------------------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

--------------------------------------------------------------------------------
-- Themes
--------------------------------------------------------------------------------
Plug 'https://github.com/ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'stevearc/dressing.nvim'
Plug 'folke/tokyonight.nvim'
Plug 'craftzdog/solarized-osaka.nvim'
Plug 'EdenEast/nightfox.nvim'

-- Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'

--------------------------------------------------------------------------------
-- FZF
--------------------------------------------------------------------------------
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install()']})
Plug 'junegunn/fzf.vim'

--------------------------------------------------------------------------------
-- LSP & Linting
--------------------------------------------------------------------------------
Plug 'williamboman/nvim-lsp-installer'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'
Plug 'folke/trouble.nvim'
Plug('j-hui/fidget.nvim', {['tag']='legacy'})

--------------------------------------------------------------------------------
-- Footer
--------------------------------------------------------------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update
-- Plug 'romgrk/nvim-treesitter-context'


--------------------------------------------------------------------------------
-- WebDev plugins
--------------------------------------------------------------------------------
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mattn/emmet-vim'
Plug('styled-components/vim-styled-components', { ['branch'] = 'main' })
Plug 'AndrewRadev/tagalong.vim'
Plug 'nelsyeung/twig.vim'
Plug 'David-Kunz/jester'
-- Plug 'ap/vim-css-color'
Plug( 'kristijanhusak/vim-js-file-import', {['do'] = vim.fn['npm install']})
Plug 'jelera/vim-javascript-syntax';
Plug 'jparise/vim-graphql';
Plug 'eslint/eslint';
Plug 'wuelnerdotexe/vim-astro'
Plug 'vuki656/package-info.nvim'

--------------------------------------------------------------------------------
-- Utilty stuff
--------------------------------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'mhinz/vim-grepper'

--------------------------------------------------------------------------------
-- Autocomplete
--------------------------------------------------------------------------------

-- Autocompletion Start
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'petertriho/cmp-git'
Plug 'hrsh7th/cmp-emoji'
Plug 'hrsh7th/nvim-cmp'
-- Autocompletion End

Plug 'johmsalas/text-case.nvim'
Plug 'nikvdp/ejs-syntax'
Plug 'folke/todo-comments.nvim'

--------------------------------------------------------------------------------
-- Snippets
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
--------------------------------------------------------------------------------


Plug 'Exafunction/codeium.vim'

Plug 'simrat39/symbols-outline.nvim'
-- Plug 'justinmk/vim-sneak'
-- Plug 'zbirenbaum/neodim'

--------------------------------------------------------------------------------
-- File-specific plugins
--------------------------------------------------------------------------------

-- *.dockerfile
Plug 'ekalinin/Dockerfile.vim'

-- *.rs
Plug 'rust-lang/rust.vim'

-- *.go
Plug 'ray-x/go.nvim'
Plug 'charlespascoe/vim-go-syntax'

vim.call('plug#end')

