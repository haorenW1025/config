inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
au Filetype c,cpp setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype rust setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype lua setl omnifunc=v:lua.vim.lsp.omnifunc
au Filetype vim setl omnifunc=v:lua.vim.lsp.omnifunc
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


" nmap a :test<c
let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp']},
            \       {'complete_items': ['path'], 'triggered_only': ['/']},
            \       {'complete_items': ['buffers']}],
            \   'string' : [
            \       {'complete_items': ['path'], 'triggered_only': ['/']}]
            \   },
            \ 'python' : {
            \   'default': [
            \       {'complete_items': ['tabnine']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [
            \       {'complete_items': ['path']}]
            \   },
            \ 'cpp' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [
            \       {'complete_items': ['path']}]
            \   },
            \ 'markdown' : {
            \   'default': [
            \       {'mode': 'spel'}],
            \   'comment': [],
            \   },
            \ 'verilog' : {
            \   'default': [
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   }
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
" let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 0
let g:completion_timer_cycle = 80
let g:completion_auto_change_source = 1
let g:completion_matching_ignore_case = 1
" let g:completion_trigger_keyword_length = 3

" let g:completion_confirm_key = ""
" imap <expr> <cr> pumvisible() ? complete_info()["selected"] != "-1" ?
"                                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :
"                                 \ "\<CR>"
" let g:completion_confirm_key_rhs = "\<Plug>AutoPairsReturn"

imap  <c-j> <Plug>(completion_next_source)
imap  <c-k> <Plug>(completion_prev_source)

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction


" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
" imap <silent><expr> <TAB>
"   \ pumvisible() ? "\<C-n>" :
"   \ vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' :
"   \ <SID>check_back_space() ? "\<TAB>" :
"   \ completion#trigger_completion()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" NerdCommentor
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 0
let g:NERDCompactSexyComs = 1

" autopair
let g:AutoPairsShortcutFastWrap="jw"

" ultisnips
let g:UltiSnipsSnippetDirectories = ["/home/whz861025/.config/nvim/pack/packager/start/vim-snippets/UltiSnips"]
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="jl"
let g:ultisnips_python_style="google"
let g:UltiSnipsJumpForwardTrigger="jl"
let g:UltiSnipsJumpBackwardTrigger="jh"
imap <expr> <C-f>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\	'guifgs': ['white', 'lightcyan', 'lightred', 'red', 'blue', 'darkgray'],
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

let g:indentLine_fileTypeExclude = ['startify']

" sneak
let g:sneak#s_next = 1
highlight Sneak guifg=black guibg=#81A1C1 ctermfg=black ctermbg=red
highlight SneakScope guifg=red guibg=green ctermfg=red ctermbg=yellow

lua require'colorizer'.setup()

au BufNewFile,BufRead *.v,*.vh,*.sv,*.svh,*.vs	set filetype=verilog

" startify
let g:startify_session_persistence = 1
let g:startify_custom_header =
        \ 'startify#center(startify#fortune#cowsay())'


