" TODO: why ever fzf_preview_command has no effect (at least on Ubuntu)
" let g:fzf_preview_command="bat --style=ansi,numbers,changes,header,grid --wrap never --color always {} || cat {} || tree -C {}"
let g:fzf_layout = { 'down': '90%' }
let g:fzf_preview_window = 'up:50%'
" ripgrep
if executable('rg')
	let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
	set grepprg=rg\ --vimgrep
        command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"',1, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}),<bang>0)
	command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".(<q-args>), 1, fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}),<bang>0)
	" Rg
	nnoremap <silent> <Leader>fa :Find<CR>
	" Rg current word
	nnoremap <Leader>fw :Rg <C-R><C-W><space>
endif
