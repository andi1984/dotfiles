" Customize global settings
" Use around source.
" https://github.com/Shougo/ddc-around
call ddc#custom#patch_global('sources', ['around', 'ale', 'tabnine', 'nvimlsp'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', {
      \ '_': {
      \   'matchers': ['matcher_head'],
      \   'sorters': ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', {
      \ 'around': {'mark': 'A'},
      \ })
call ddc#custom#patch_global('sourceParams', {
      \ 'around': {'maxSize': 500},
      \ 'ale': {'cleanResultsWhitespace': v:false},
      \ })

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
      \ 'clangd': {'mark': 'C'},
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', {
      \ 'around': {'maxSize': 100},
      \ })

" Tabnine
call ddc#custom#patch_global('sourceOptions', {
    \ 'tabnine': {
    \   'mark': 'TN',
    \   'maxCandidates': 5,
    \   'isVolatile': v:true,
    \ }})

" LSP
call ddc#custom#patch_global('sourceOptions', {
      \ '_': { 'matchers': ['matcher_head'] },
      \ 'nvimlsp': {
      \   'mark': 'lsp',
      \   'forceCompletionPattern': '\.\w*|:\w*|->\w*' },
      \ })

" Use Customized labels
call ddc#custom#patch_global('sourceParams', {
      \ 'nvimlsp': { 'kindLabels': { 'Class': 'c' } },
      \ })

" Mappings

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()
