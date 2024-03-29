autocmd BufWritePost * GitGutter

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

au Filetype c,cpp  setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype ruby  setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype rust   setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype lua    setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype vim    setl omnifunc=v:lua.vim.lsp.omnifunc
au FileType go setl omnifunc=v:lua.vim.lsp.omnifunc

set cmdheight=2

let g:completion_customize_lsp_label = {
      \ 'Function': ' [function]',
      \ 'Method': ' [method]',
      \ 'Reference': ' [refrence]',
      \ 'Enum': ' [enum]',
      \ 'Field': 'ﰠ [field]',
      \ 'Keyword': ' [key]',
      \ 'Variable': ' [variable]',
      \ 'Folder': ' [folder]',
      \ 'Snippet': ' [snippet]',
      \ 'Operator': ' [operator]',
      \ 'Module': ' [module]',
      \ 'Text': 'ﮜ[text]',
      \ 'Class': ' [class]',
      \ 'Interface': ' [interface]'
      \}

" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
" autocmd CursorMoved * lua vim.lsp.util.show_line_diagnostics()

set completeopt=menuone,noinsert,noselect

call sign_define("LspDiagnosticsSignError", {"text" : ">>", "texthl" : "LspDiagnosticsSignError"})
call sign_define("LspDiagnosticsSignWarning", {"text" : "⚠", "texthl" : "LspDiagnosticsSignWarning"})
call sign_define("LspDiagnosticsSignInformation", {"text" : "", "texthl" : "LspDiagnosticsSignInformation"})
call sign_define("LspDiagnosticsSignHint", {"text" : "", "texthl" : "LspDiagnosticsSignWarning"})

" sign define LspDiagnosticsSignError text=">>" texthl=LspDiagnosticsSignError linehl= numhl=
" sign define LspDiagnosticsSignWarning text="⚡" texthl=LspDiagnosticsSignWarning linehl= numhl=
" sign define LspDiagnosticsSignInformation text="" texthl=LspDiagnosticsSignInformation linehl= numhl=
" sign define LspDiagnosticsSignHint text="" texthl=LspDiagnosticsSignHint linehl= numhl=

" diagnostic-nvim
let g:diagnostic_level = 'Warning'
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_virtual_text_prefix = ' '
let g:diagnostic_trimmed_virtual_text = 0
let g:diagnostic_insert_delay = 1

" completion-nvim
let g:completion_enable_auto_hover = 1
let g:completion_auto_change_source = 1
" let g:completion_enable_snippet = 'snippets.nvim'
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_paren = 0
let g:completion_timer_cycle = 80
let g:completion_auto_change_source = 1
let g:completion_matching_ignore_case = 1
" let g:completion_trigger_keyword_length = 3

 let g:completion_chain_complete_list = {
    \ 'default' : {
    \   'default': [
    \       {'complete_items': ['snippet', 'lsp']},
    \],
    \   'comment': [],
    \   'string' : [
    \       {'complete_items': ['path']}
    \]
    \   },
    \ 'python' : [
    \     {'complete_items': ['snippet', 'tabnine']}, 
    \   ],
    \ 'tex' : [
    \     {'complete_items': ['vimtex', 'lsp']}, 
    \   ],
    \ 'verilog': {
    \   'default': [
    \       {'complete_items': ['snippet', 'buffer']}
    \]
    \   },
    \ 'markdown.pandoc': {
    \   'default': [
    \       {'complete_items': ['snippet']}
    \]
    \   }
    \}



function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
" if exists('*complete_info')
"   inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
" else
"   inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" endif

" smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
" imap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ completion#trigger_completion()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

" NerdCommentor
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 0
let g:NERDCompactSexyComs = 1

" ultisnips
" let g:UltiSnipsSnippetDirectories = ["~/.config/nvim/UltiSnips/"]
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsExpandTrigger="jl"
" let g:ultisnips_python_style="google"
" let g:UltiSnipsJumpForwardTrigger="jl"
" let g:UltiSnipsJumpBackwardTrigger="jh"

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['LightBlue', 'LightRed', 'White', 'LightMagenta', 'LightCyan', 'LightGray'],
\	'ctermfgs': ['white', 'yellow', 'lightcyan', 'red', 'blue', 'darkgray'],
\	'guis': [''],
\	'cterms': [''],
\	'operators': '_,_',
\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
\}

" editor config
let g:editorconfig_blacklist = {
    \ 'filetype': ['git.*', 'fugitive'],
    \ 'pattern': ['\.un~$']}
" easy align
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" FloatLf
let g:floatLf_border = 0
let g:floatLf_exec = 'lf'

let g:indentLine_fileTypeExclude = ['startify', 'term', 'markdown.pandoc', 'fzf']
let g:indentLine_setColors = 0

" sneak
let g:sneak#s_next = 1
highlight Sneak guifg=black guibg=#81A1C1 ctermfg=black ctermbg=red
highlight SneakScope guifg=red guibg=green ctermfg=red ctermbg=yellow

lua require'colorizer'.setup()

au BufNewFile,BufRead *.v,*.vh,*.sv,*.svh,*.vs	set filetype=verilog

" startify
let g:startify_session_persistence = 1
let g:startify_change_to_vcs_root = 0
let g:startify_custom_header =
        \ 'startify#center(startify#fortune#cowsay())'
"vimtex

" word-motion
let g:wordmotion_mappings = {
\ 'w' : '<M-w>',
\ 'b' : '<M-b>',
\ 'e' : '<M-e>',
\ 'ge' : 'g<M-e>',
\ 'aw' : 'a<M-w>',
\ 'iw' : 'i<M-w>',
\ '<C-R><C-W>' : '<C-R><M-w>'
\ }

let g:vimspector_enable_mappings = 'HUMAN'

let g:gitgutter_sign_priority = 1
augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

let g:doge_mapping = '<leader>dg'

let g:nnn#set_default_mappings = 0
nnoremap <silent> <leader>nn :NnnPicker<CR>
" Start n³ in the current file's directory
nnoremap <leader>nc :NnnPicker %:p:h<CR>
let g:nnn#action = {
      \ '<c-t>': 'tab split',
      \ '<c-s>': 'split',
      \ '<c-v>': 'vsplit' }
let g:nnn#session = 'local'

