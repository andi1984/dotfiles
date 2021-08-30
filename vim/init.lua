-- Reference https://github.com/doums/dotfiles/blob/master/.config/nvim/init.lua
-- Aliases 

local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local window = vim.wo

-- Own changes

vim.g.mapleader = " "

window.wrap = false

cmd 'autocmd CmdlineEnter /,? :set hlsearch'
cmd 'autocmd CmdlineLeave /,? :set nohlsearch'

vim.api.nvim_command('silent noswapfile')

-- All the rest
require('lua/statusline')
require('lua/opts')
require('lua/plugins')
require('lua/keymap')

-- Plugin related
require('lua/lsp')
cmd 'colorscheme gruvbox'
