local opt = vim.opt

-- Sound
opt.belloff = "all"

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Syntax
opt.syntax = "enable"

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Editor behavior
opt.exrc = true
opt.hidden = true
opt.smartcase = true
opt.incsearch = true
opt.scrolloff = 8
opt.showmode = true
opt.signcolumn = "yes"

-- Persistent undo
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
