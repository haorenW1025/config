

au Filetype c,cpp  setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype rust   setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype lua    setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype vim    setl omnifunc=v:lua.vim.lsp.omnifunc
au FileType scala  setl omnifunc=v:lua.vim.lsp.omnifunc

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

call sign_define("LspDiagnosticsErrorSign", {"text" : ">>", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚡", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "", "texthl" : "LspDiagnosticsWarning"})

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

let g:completion_confirm_key = "\<CR>"
" imap <expr> <cr> pumvisible() ? complete_info()["selected"] != "-1" ?
"                                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :
"                                 \ "\<CR>"
" let g:completion_confirm_key_rhs = "\<Plug>AutoPairsReturn"
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
    \ 'markdown.pandoc': {
    \   'default': [
    \       {'complete_items': ['snippet']}
    \]
    \   }
    \}


augroup CompletionStartUp
    autocmd!
    autocmd BufEnter *.md lua require'completion'.on_attach()
augroup end


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
let g:UltiSnipsSnippetDirectories = ["~/.local/share/nvim/UltiSnips/"]
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="jl"
let g:ultisnips_python_style="google"
let g:UltiSnipsJumpForwardTrigger="jl"
let g:UltiSnipsJumpBackwardTrigger="jh"

" vim-vsnip
imap <expr> <c-f>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<c-f>'
smap <expr> <c-f>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<c-f>'
imap <expr> <c-b> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<c-b>'
smap <expr> <c-b> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<c-b>'
let g:vsnip_snippet_dir = "~/.local/share/nvim/vsnip"

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
let g:matchup_override_vimtex = 1
let g:matchup_matchparen_deferred = 1
let g:vimtex_syntax_enabled = 0
let g:vimtex_latexmk_progname= '/usr/bin/nvr'
let g:vimtex_latexmk_progname= '/usr/bin/nvr'
let g:vimtex_latexmk_options="-pdf -pdflatex='pdflatex -file-line-error -shell-escape -synctex=1'"
let g:vimtex_fold_enabled = 0
let g:vimtex_toc_resize = 0
let g:vimtex_toc_hide_help = 1
let g:vimtex_indent_enabled = 1
let g:vimtex_latexmk_enabled = 1
let g:vimtex_latexmk_callback = 1
let g:vimtex_complete_recursive_bib = 0
let g:vimtex_view_method = 'zathura'
let g:vimtex_complete_close_braces = 1
let g:vimtex_quickfix_mode = 2
let g:vimtex_quickfix_open_on_warning = 1
let g:vimtex_quickfix_ignored_warnings = [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to',
      \ ]
let g:tex_flavor = "latex"

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

augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

