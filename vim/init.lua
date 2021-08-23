-- Reference https://github.com/doums/dotfiles/blob/master/.config/nvim/init.lua
-- Aliases 

local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local window = vim.wo

-- Own changes

vim.g.mapleader = " "

opt.belloff = "all"
opt.number = true
opt.relativenumber = true
opt.syntax = "enable"
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.exrc = true
opt.hidden = true
opt.nu = true
opt.smartcase = true
opt.undodir  = "~/.vim/undodir"
opt.undofile = true
opt.incsearch = true
opt.scrolloff = 8
opt.showmode = true
opt.signcolumn = "yes"

window.wrap = false

cmd 'autocmd CmdlineEnter /,? :set hlsearch'
cmd 'autocmd CmdlineLeave /,? :set nohlsearch'

vim.api.nvim_command('silent noswapfile')
