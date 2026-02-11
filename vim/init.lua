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

-- All the rest
require('plugins')
require('keymap')
require('sets')
require('opts')

-- Plugin related
-- vim.cmd [[colorscheme solarized-osaka]]
-- vim.cmd [[colorscheme nightfox]]
-- vim.cmd [[colorscheme everforest]]
vim.cmd [[colorscheme evergarden]]
