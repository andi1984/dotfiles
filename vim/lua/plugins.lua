local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
-- Telescope Fuzzy Finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

-- Themes
Plug 'kyazdani42/nvim-web-devicons'
Plug 'jacoborus/tender.vim'
Plug 'mhartington/oceanic-next'
Plug 'catppuccin/nvim'

-- FZF
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install()']})
Plug 'junegunn/fzf.vim'

-- LSP & Linting
Plug 'neovim/nvim-lsp'
Plug 'dense-analysis/ale'
Plug 'folke/trouble.nvim'

-- Footer
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- Treesitter
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update

-- WebDev plugins
Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'mattn/emmet-vim'
Plug('styled-components/vim-styled-components', { ['branch'] = 'main' })
Plug 'AndrewRadev/tagalong.vim'
Plug 'nelsyeung/twig.vim'
Plug 'David-Kunz/jester'
Plug 'ap/vim-css-color'
Plug( 'kristijanhusak/vim-js-file-import', {['do'] = vim.fn['npm install']})
Plug 'jelera/vim-javascript-syntax';

-- Utilty stuff
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'wellle/context.vim'
Plug 'github/copilot.vim'

-- Autocompletion Start
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

-- Install your sources
Plug 'Shougo/ddc-around'
Plug 'statiolake/ddc-ale'
Plug 'LumaKernel/ddc-tabnine'
Plug 'Shougo/ddc-nvim-lsp'
Plug 'LumaKernel/ddc-file'
Plug 'matsui54/ddc-buffer'
Plug 'delphinus/ddc-treesitter'

-- Install your filters
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
-- Autocompletion End


-- Trying out area below:
-- If you don't have nodejs and yarn
-- use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
-- see: https://github.com/iamcco/markdown-preview.nvim/issues/50
Plug(
        'iamcco/markdown-preview.nvim', {
                ['do'] = vim.fn['mkdp#util#install()'],
                ['for'] = {'markdown', 'vim-plug'}
        }
)

Plug 'norcalli/nvim-colorizer.lua'
Plug 'junegunn/vim-easy-align'
Plug 'folke/which-key.nvim'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

-- HIGH HDD USAGE!: Plug 'ludovicchabant/vim-gutentags'
-- Plug 'honza/vim-snippets'
Plug('filipdutescu/renamer.nvim', {['branch'] = 'master' })
-- Plug 'shmargum/vim-sass-colors';
Plug 'whiteinge/diffconflicts';
Plug 'Pocco81/AutoSave.nvim';
Plug 'abecodes/tabout.nvim';
vim.call('plug#end')

