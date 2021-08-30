vim.api.nvim_set_keymap('n', '<Leader>ff',  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fb',  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Up>',  ':m-2<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Down>',  ':m+<CR>', { noremap = true, silent = true })

