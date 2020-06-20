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


let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'complete_items': ['path'], 'triggered_only': ['/']},
            \       {'complete_items': ['buffers']}],
            \   'string' : [
            \       {'complete_items': ['path'], 'triggered_only': ['/']}]
            \   },
            \ 'vim' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'complete_items': ['path'], 'triggered_only': ['/']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'string' : [
            \       {'complete_items': ['path'], 'triggered_only': ['/']}]
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
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 0
let g:completion_timer_cycle = 80
let g:completion_auto_change_source = 1
" let g:completion_trigger_keyword_length = 3

let g:completion_confirm_key = ""
imap <expr> <cr> pumvisible() ? complete_info()["selected"] != "-1" ?
                                \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :
                                \ "\<CR>"
" let g:completion_confirm_key_rhs = "\<Plug>AutoPairsReturn"

imap <c-j> <cmd>lua require'source'.prevCompletion()<CR>
imap <c-k> <cmd>lua require'source'.nextCompletion()<CR>

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ vsnip#available(1)  ? '<Plug>(vsnip-jump-next)' :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"


" treesitter-nvim
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

" firenvim 
" let fc['.*'] = { 'cmdline' : 'firenvim' }
au BufEnter www.firecode.*.txt set filetype=cpp
au BufEnter github.com_*.txt set filetype=markdown
if exists('g:started_by_firenvim') && g:started_by_firenvim
    " general options
    setl laststatus=0
    setl showtabline=0
    colorscheme nord
endif
function! s:IsFirenvimActive(event) abort
  if !exists('*nvim_get_chan_info')
    return 0
  endif
  let l:ui = nvim_get_chan_info(a:event.chan)
  return has_key(l:ui, 'client') && has_key(l:ui.client, "name") &&
      \ l:ui.client.name is# "Firenvim"
endfunction

function! OnUIEnter(event) abort
  if s:IsFirenvimActive(a:event)
    set laststatus=0
  endif
endfunction
autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
nnoremap <Esc><Esc> :call firenvim#focus_page()<CR>
nnoremap <C-z> :call firenvim#hide_frame()<CR>

" fzf
let g:fzf_colors =
\ { 'fg':      ['bg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['fg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment']}

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%'), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%'), <bang>0)

command! -bang -nargs=? -complete=dir History
    \ call fzf#vim#history(fzf#vim#with_preview('right:70%'), <bang>0)

command! -bang -nargs=? -complete=dir Chistory
    \ call fzf#vim#command_history()

command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --max-columns=80 --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 2,
\   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:60%'),  <bang>0)

let $FZF_DEFAULT_OPTS = "--layout=reverse"
'
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow(0)' }
let g:clap_layout = { 'relative': 'editor' }
let g:clap_theme = { 'display': {'guibg': '#404040'},
                   \ 'preview': {'guibg': '#202020'},
                   \ 'input': {'guifg': '#81A1C1'},
                   \ 'spinner': {'gui': 'bold', 'guifg': '#A3BE8C'}}


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

" indentLine
let g:indentLine_fileTypeExclude = ['dashboard']

" dashboard
nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :<C-u>Clap history<CR>
nnoremap <silent> <Leader>ff :<C-u>Clap files ++finder=rg --ignore --hidden --files<cr>
nnoremap <silent> <Leader>tc :<C-u>Clap colors<CR>
nnoremap <silent> <Leader>fa :<C-u>Clap grep2<CR>
nnoremap <silent> <Leader>fb :<C-u>Clap marks<CR>

let g:dashboard_custom_shortcut={
  \ 'last_session' : 'SPC s l',
  \ 'find_history' : 'SPC f h',
  \ 'find_file' : 'SPC f f',
  \ 'change_colorscheme' : 'SPC t c',
  \ 'find_word' : 'SPC f a',
  \ 'book_marks' : 'SPC f b',
  \ }
" let g:dashboard_custom_header = [
"     \'',
"     \' _   _ _____ _____     _____ __  __ ',
"     \'| \ | | ____/ _ \ \   / /_ _|  \/  |',
"     \'|  \| |  _|| | | \ \ / / | || |\/| |',
"     \'| |\  | |__| |_| |\ V /  | || |  | |',
"     \'|_| \_|_____\___/  \_/  |___|_|  |_|',
"     \'',
" \]

" sneak
let g:sneak#s_next = 1
highlight Sneak guifg=black guibg=#81A1C1 ctermfg=black ctermbg=red
highlight SneakScope guifg=red guibg=green ctermfg=red ctermbg=yellow

lua require'colorizer'.setup()

au BufNewFile,BufRead *.v,*.vh,*.sv,*.svh,*.vs	set filetype=verilog
