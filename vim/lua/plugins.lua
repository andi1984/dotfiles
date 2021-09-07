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

--Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'

-- Install snippet engine (This example installs [hrsh7th/vim-vsnip](https://github.com/hrsh7th/vim-vsnip))
Plug 'hrsh7th/vim-vsnip'

-- Install the buffer completion source
Plug 'hrsh7th/cmp-buffer'

Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn[':TSUpdate']})  -- We recommend updating the parsers on update

Plug 'maxmellon/vim-jsx-pretty'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

vim.call('plug#end')

