local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search: case-insensitive unless the pattern contains uppercase
opt.ignorecase = true
opt.smartcase = true

-- Editor behavior
opt.exrc = true
opt.wrap = false
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 300
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case"
end

-- Command line (lualine already shows the mode)
opt.cmdheight = 1
opt.showmode = false
opt.shortmess:append("c")

-- Visual
opt.colorcolumn = "80"
opt.termguicolors = true
opt.conceallevel = 0

-- Files: no swap/backup, persistent undo instead
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

-- Autocommands
local group = vim.api.nvim_create_augroup("user_opts", { clear = true })

-- Search highlighting: only show while typing the pattern
vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = group,
  pattern = { "/", "?" },
  callback = function() vim.opt.hlsearch = true end,
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  pattern = { "/", "?" },
  callback = function() vim.opt.hlsearch = false end,
})

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})
