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
-- Plug 'Pocco81/AutoSave.nvim'; NOTE: Buggy right now
Plug 'abecodes/tabout.nvim';
Plug 'editorconfig/editorconfig-vim'

--------------------------------------------------------------------------------
-- Git
--------------------------------------------------------------------------------
Plug 'whiteinge/diffconflicts';
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
Plug 'kyazdani42/nvim-web-devicons'
Plug 'tjdevries/colorbuddy.vim'
Plug 'stevearc/dressing.nvim'
-- Plug 'tjdevries/gruvbuddy.nvim'
Plug 'Th3Whit3Wolf/onebuddy'

--------------------------------------------------------------------------------
-- FZF
--------------------------------------------------------------------------------
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install()']})
Plug 'junegunn/fzf.vim'

--------------------------------------------------------------------------------
-- LSP & Linting
--------------------------------------------------------------------------------
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'dense-analysis/ale'
Plug 'folke/trouble.nvim'
Plug 'j-hui/fidget.nvim'

--------------------------------------------------------------------------------
-- Footer
--------------------------------------------------------------------------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update
Plug 'romgrk/nvim-treesitter-context'


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

--------------------------------------------------------------------------------
-- Utilty stuff
--------------------------------------------------------------------------------
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'ThePrimeagen/refactoring.nvim'
-- Plug 'wellle/context.vim'
-- Plug 'github/copilot.vim'
Plug 'mhinz/vim-grepper'

--------------------------------------------------------------------------------
-- Autocomplete
--------------------------------------------------------------------------------

-- Autocompletion Start
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'Shougo/ddu.vim'

-- Install your sources
Plug 'Shougo/ddc-around'
Plug 'statiolake/ddc-ale'
-- Plug 'LumaKernel/ddc-tabnine'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'LumaKernel/ddc-file'
Plug 'matsui54/ddc-buffer'
Plug 'delphinus/ddc-treesitter'
Plug 'tani/ddc-git'
Plug 'Shougo/ddc-rg'

-- Install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
-- Autocompletion End

Plug 'johmsalas/text-case.nvim'
Plug 'nikvdp/ejs-syntax'
Plug 'folke/todo-comments.nvim'

--------------------------------------------------------------------------------
-- Snippets
--------------------------------------------------------------------------------
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'


Plug 'simrat39/symbols-outline.nvim'
Plug 'justinmk/vim-sneak'


--------------------------------------------------------------------------------
-- File-specific plugins
--------------------------------------------------------------------------------

-- *.dockerfile
Plug 'ekalinin/Dockerfile.vim'



vim.call('plug#end')

