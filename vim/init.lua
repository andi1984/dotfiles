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
require('opts')
require('sets')
require('plugins')
require('keymap')


-- Plugin related
require('lsp')
cmd 'colorscheme OceanicNext'
-- cmd 'colorscheme tender'
