nnoremap <expr> <Leader>sfe ":Rg " . fnameescape(input("fe topic: ")) . " -g \"*.{js,jsx,ts,tsx,css,scss,sass,html}\""
nnoremap <expr> <Leader>sbe ":Rg " . fnameescape(input("be topic: ")) . " -g \"*.{jinja2,py,rb,php,yml,yaml}\""
nnoremap <expr> <Leader>sg ":Rg " . fnameescape(input("topic: "))


