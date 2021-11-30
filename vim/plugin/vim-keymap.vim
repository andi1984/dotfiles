nnoremap <expr> <Leader>sfe ":Rg " . fnameescape(input("fe topic: ")) . " -g \"*.{js,jsx,ts,tsx,css,scss,sass,html}\""
nnoremap <expr> <Leader>sbe ":Rg " . fnameescape(input("be topic: ")) . " -g \"*.{jinja2,py,rb,php,yml,yaml}\""
nnoremap <expr> <Leader>sg ":Rg " . fnameescape(input("topic: "))
nnoremap <silent> K :call <SID>show_documentation()<CR>
au FileType markdown vmap <Leader>ea :EasyAlign*<Bar><Enter>

" Tab nav

nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprev<CR>
nnoremap <Leader>tc :tabnew<CR>
nnoremap <Leader>td :tabclose<CR>
