-- Finding files
vim.api.nvim_set_keymap('n', '<Leader>ff',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb',  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fi', ':Rg ', { noremap = true })
--vim.api.nvim_set_keymap('n', '<Leader>fe', ':Rg <EXPR> -g "*.{js,jsx,ts,tsx}"', { noremap = true, 'expr': v.true })

-- Moving lines up/down
vim.api.nvim_set_keymap('n', '<S-Down>',  ':m+<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>',  ':m-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Down>',  ':m\'>+1<CR>gv=gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Up>',  ':m\'<-2<CR>gv=gv', { noremap = true, silent = true })

-- Toggle commenting line
vim.api.nvim_set_keymap('n', '<Leader>c', ':Commentary<CR>', { noremap = true, silent = true })

-- TroubleToggle
vim.api.nvim_set_keymap('n', '<Leader>xx', '<cmd>Trouble<cr>', { noremap = true, silent = true })

-- Relative file name
vim.api.nvim_set_keymap('n', '<Leader>rf', ':echo fnamemodify(expand("%"), ":~:.")<CR>', { noremap = true, silent = true})

-- Experimental shortcuts


-- Select surrounding HTML tags
vim.api.nvim_set_keymap('n', '<Leader>t',  'vat', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>tu',  'at', { noremap = true, silent = true })

