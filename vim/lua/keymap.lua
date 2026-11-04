local map = vim.keymap.set

-- Moving lines up/down
map("n", "<S-Down>", ":m+<CR>", { silent = true, desc = "Move line down" })
map("n", "<S-Up>", ":m-2<CR>", { silent = true, desc = "Move line up" })
map("v", "<S-Down>", ":m'>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "<S-Up>", ":m'<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Relative file name
map("n", "<leader>rf", ':echo fnamemodify(expand("%"), ":~:.")<CR>', { silent = true, desc = "Show relative path" })

-- Select surrounding HTML tags
map("n", "<leader>T", "vat", { silent = true, desc = "Select tag" })
map("v", "<leader>tu", "at", { silent = true, desc = "Expand to tag" })

-- Tab navigation
map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", ":tabprev<CR>", { desc = "Prev tab" })
map("n", "<leader>tc", ":tabnew<CR>", { desc = "New tab" })
map("n", "<leader>td", ":tabclose<CR>", { desc = "Close tab" })

-- Next diagnostic, wraps around (was ALE's <C-e>)
map("n", "<C-e>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })

-- Toggle comment on the current line (built-in gcc)
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })

-- Auto-indent whole file
map("n", "<leader>ai", "mzgg=G`z", { desc = "Auto-indent file" })

-- Copy/paste to system clipboard
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

-- Live grep limited to frontend/backend files (snacks picker)
map("n", "<leader>sfe", function()
  Snacks.picker.grep({ title = "Grep frontend", glob = "*.{js,jsx,ts,tsx,css,scss,sass,html}" })
end, { desc = "Search frontend files" })

map("n", "<leader>sbe", function()
  Snacks.picker.grep({ title = "Grep backend", glob = "*.{jinja2,py,rb,php,yml,yaml}" })
end, { desc = "Search backend files" })

map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Search all files" })

-- EasyAlign in markdown
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    map("v", "<leader>ea", ":EasyAlign*|<CR>", { buffer = true, desc = "Align tables" })
  end,
})
