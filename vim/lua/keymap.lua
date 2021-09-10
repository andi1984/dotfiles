-- Finding files
vim.api.nvim_set_keymap('n', '<Leader>ff',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb',  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fi', ':Rg ', { noremap = true })
--vim.api.nvim_set_keymap('n', '<Leader>fif', ':Rg <EXPR> -g "*.{js,jsx,ts,tsx}"', { noremap = true, 'expr': v.true })

-- Moving lines up/down
vim.api.nvim_set_keymap('n', '<S-Down>',  ':m+<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>',  ':m-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Down>',  ':m\'>+1<CR>gv=gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<S-Up>',  ':m\'<-2<CR>gv=gv', { noremap = true, silent = true })
