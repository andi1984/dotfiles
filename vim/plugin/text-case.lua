local textcase = require('textcase')

textcase.setup {}

vim.api.nvim_set_keymap('n', 'cau', '<cmd>lua require(\'textcase\').current_word(\'to_upper_case\')<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'cal', '<cmd>lua require(\'textcase\').current_word(\'to_lower_case\')<cr>', { noremap = true, silent = true })

-- Example of custom keymapping
--
-- nnoremap gau :lua require('textcase').current_word('to_upper_case')<CR>
-- nnoremap gal :lua require('textcase').current_word('to_lower_case')<CR>
-- nnoremap gas :lua require('textcase').current_word('to_snake_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dash_case')<CR>
-- nnoremap gan :lua require('textcase').current_word('to_constant_case')<CR>
-- nnoremap gad :lua require('textcase').current_word('to_dot_case')<CR>
-- nnoremap gaa :lua require('textcase').current_word('to_phrase_case')<CR>
-- nnoremap gac :lua require('textcase').current_word('to_camel_case')<CR>
-- nnoremap gap :lua require('textcase').current_word('to_pascal_case')<CR>
-- nnoremap gat :lua require('textcase').current_word('to_title_case')<CR>
-- nnoremap gaf :lua require('textcase').current_word('to_path_case')<CR>

-- nnoremap gaU :lua require('textcase').lsp_rename('to_upper_case')<CR>
-- nnoremap gaL :lua require('textcase').lsp_rename('to_lower_case')<CR>
-- nnoremap gaS :lua require('textcase').lsp_rename('to_snake_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dash_case')<CR>
-- nnoremap gaN :lua require('textcase').lsp_rename('to_constant_case')<CR>
-- nnoremap gaD :lua require('textcase').lsp_rename('to_dot_case')<CR>
-- nnoremap gaA :lua require('textcase').lsp_rename('to_phrase_case')<CR>
-- nnoremap gaC :lua require('textcase').lsp_rename('to_camel_case')<CR>
-- nnoremap gaP :lua require('textcase').lsp_rename('to_pascal_case')<CR>
-- nnoremap gaT :lua require('textcase').lsp_rename('to_title_case')<CR>
-- nnoremap gaF :lua require('textcase').lsp_rename('to_path_case')<CR>

-- nnoremap geu :lua require('textcase').operator('to_upper_case')<CR>
-- nnoremap gel :lua require('textcase').operator('to_lower_case')<CR>
-- nnoremap ges :lua require('textcase').operator('to_snake_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dash_case')<CR>
-- nnoremap gen :lua require('textcase').operator('to_constant_case')<CR>
-- nnoremap ged :lua require('textcase').operator('to_dot_case')<CR>
-- nnoremap gea :lua require('textcase').operator('to_phrase_case')<CR>
-- nnoremap gec :lua require('textcase').operator('to_camel_case')<CR>
-- nnoremap gep :lua require('textcase').operator('to_pascal_case')<CR>
-- nnoremap get :lua require('textcase').operator('to_title_case')<CR>
-- nnoremap gef :lua require('textcase').operator('to_path_case')<CR>
