local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'dense-analysis/ale'
Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lsp'
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install()']})
Plug 'junegunn/fzf.vim'
Plug('styled-components/vim-styled-components', { ['branch'] = 'main' })

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'

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

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'ThePrimeagen/refactoring.nvim'

-- If you don't have nodejs and yarn
-- use pre build, add 'vim-plug' to the filetype list so vim-plug can update this plugin
-- see: https://github.com/iamcco/markdown-preview.nvim/issues/50
Plug(
        'iamcco/markdown-preview.nvim', {
                ['do'] = vim.fn['mkdp#util#install()'],
                ['for'] = {'markdown', 'vim-plug'}
        }
)

vim.call('plug#end')

