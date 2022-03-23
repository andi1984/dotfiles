nnoremap <expr> <Leader>sfe ":Rg " . fnameescape(input("fe topic: ")) . " -g \"*.{js,jsx,ts,tsx,css,scss,sass,html}\""
nnoremap <expr> <Leader>sbe ":Rg " . fnameescape(input("be topic: ")) . " -g \"*.{jinja2,py,rb,php,yml,yaml}\""
nnoremap <expr> gr ":Rg " . expand("<cword>") . "<CR>"
nnoremap <expr> <Leader>sg ":Rg " . fnameescape(input("topic: "))
nnoremap <silent> K :call <SID>show_documentation()<CR>
au FileType markdown vmap <Leader>ea :EasyAlign*<Bar><Enter>

" Tab nav

nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprev<CR>
nnoremap <Leader>tc :tabnew<CR>
nnoremap <Leader>td :tabclose<CR>

" Auto-indent whole file (https://stackoverflow.com/a/42124544)
nmap <leader>ai mzgg=G`z

" cf. https://github.com/nickjj/dotfiles/blob/master/.vimrc#L604
" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
  \ :let @s='\<'.expand('<cword>').'\>'<CR>
  \ :Grepper -cword -noprompt<CR>
  \ :cfdo %s/<C-r>s//g \| update
  \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>R
    \ "sy
    \ gvgr
    \ :cfdo %s/<C-r>s//g \| update
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
