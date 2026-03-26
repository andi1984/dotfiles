local opt = vim.opt

-- Disable swap/backup (use undofile instead)
opt.swapfile = false
opt.backup = false
opt.writebackup = false

-- Command line
opt.cmdheight = 2
opt.updatetime = 300
opt.shortmess:append("c")

-- Visual
opt.colorcolumn = "80"
opt.termguicolors = true
opt.conceallevel = 0
