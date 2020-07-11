" lsp
nnoremap <silent> <leader>f <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> ]d :NextDiagnostic<CR>
nnoremap <silent> [d :PrevDiagnostic<CR>
nnoremap <silent> <leader>do :OpenDiagnostic<CR>
nnoremap <leader>dl <cmd>lua require'diagnostic.util'.show_line_diagnostics()<CR>


" fzf
nnoremap <silent> ,f    :<C-u>FzfPreviewDirectoryFiles<CR>
nnoremap <silent> ,gm    :<C-u>FzfPreviewFromResources project_mru git<CR>
nnoremap <silent> ,b     :<C-u>FzfPreviewBuffers<CR>
nnoremap <silent> ,B     :<C-u>FzfPreviewAllBuffers<CR>
nnoremap <silent> ,m     :<C-u>FzfPreviewFromResources buffer project_mru<CR>
nnoremap <silent> ,o     :<C-u>FzfPreviewJumps<CR>
nnoremap <silent> ,g     :<C-u>FzfPreviewChanges<CR>
nnoremap <silent> ,l     :<C-u>FzfPreviewLines -add-fzf-arg=--no-sort<CR>
nnoremap          ,w     :<C-u>FzfPreviewProjectCommandGrep<CR>
nnoremap          ,c     :<C-u>FzfPreviewProjectGrep "<C-r>=expand('<cword>')<CR>" <Space><CR>
nnoremap <silent> ,q     :<C-u>FzfPreviewQuickFix<CR>
nnoremap <silent> ,l     :<C-u>FzfPreviewLocationList<CR>

" git
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>ghp <Plug>(GitGutterPreviewHunk)
nmap <leader>ghu <Plug>(GitGutterUndoHunk)
nmap <leader>ghs <Plug>(GitGutterStageHunk)

nmap <leader>es :UltiSnipsEdit<CR>

" pandoc
autocmd Filetype markdown nnoremap  <leader>pdf <cmd>lua require'markdown'.convertFile()<CR>

" tmux like terminal
tnoremap <c-a><CR> <C-\><C-n>

nmap <c-n> :tabnew term://zsh<CR>
nmap <c-a>v :vsplit term://zsh<CR>i
nmap <c-a>x :split term://zsh<CR>i
" tmap <c-n> <c-a><CR>:tabnew term://zsh<CR>i
tmap <c-a>v <c-a><CR>:vsplit term://zsh<CR>i
tmap <c-a>x <c-a><CR>:split term://zsh<CR>i
tmap <c-a>] <c-a>:+tabmove<cr>
tmap <c-a>[ <c-a>:-tabmove<cr>
tmap <a-h> <c-a><CR><c-w>h
tmap <a-j> <c-a><CR><c-w>j
tmap <a-k> <c-a><CR><C-w>k
tmap <a-l> <c-a><CR><c-w>l
tmap <c-a>J <c-a><CR><c-w>J
tmap <c-a>K <c-a><CR><c-w>K
tmap <c-a>H <c-a><CR><c-w>H
tmap <c-a>L <c-a><CR><c-w>L


function! ClosingTerminal()
    let answer = confirm('closing this terminal?', "&Yes\n&No", 1)
    if answer == 1
        bwipeout!
    endif
endfunction
nmap <c-q> :call ClosingTerminal()<CR>
tmap <c-q> <c-a><CR>:call ClosingTerminal()<CR>

function! ClosingTab()
    let answer = confirm('closing this tab?', "&Yes\n&No", 1)
    if answer == 1
        tabc
    endif
endfunction

nmap <a-]> gt
nmap <a-[> gT
tmap <a-]> <c-a><CR>gt
tmap <a-[> <c-a><CR>gT
nmap <a-1> 1gt
tmap <a-1> <c-a><CR>1gt
nmap <a-2> 2gt
tmap <a-2> <c-a><CR>2gt
nmap <a-3> 3gt
tmap <a-3> <c-a><CR>3gt
nmap <a-4> 4gt
tmap <a-4> <c-a><CR>4gt
nmap <a-5> 5gt
tmap <a-5> <c-a><CR>5gt

" gina
nmap <leader>gs :Gina status<CR>
nmap <leader>gb :Gina blame<CR>

" for mac specific
nmap ‘ gt
nmap “ gT
tmap ‘ <c-a><CR>gt
tmap “ <c-a><CR>gT
nmap ¡ 1gt
tmap ¡ <c-a><CR>1gt
nmap ™ 2gt
tmap ™ <c-a><CR>2gt
nmap £ 3gt
tmap £ <c-a><CR>3gt
nmap ¢ 4gt
tmap ¢ <c-a><CR>4gt
nmap ∞ 5gt
tmap ∞ <c-a><CR>5gt

nmap ˙ <C-w>h
nmap ∆ <C-w>j
nmap ˚ <C-w>k
nmap ¬ <C-w>l
tmap ˙ <c-a><CR><c-w>h
tmap ∆ <c-a><CR><c-w>j
tmap ˚ <c-a><CR><C-w>k
tmap ¬ <c-a><CR><c-w>l
" startify
nmap <leader>ss :SSave<CR>
nmap <leader>sl :SLoad<CR>

" term-nvim
nmap tt :TermToggle<CR>
nmap t<CR> :TermSend<Space>
nmap tl :TermSend !! <CR>
nmap tk :TermKill<CR>
nmap tc :TermSend clear<CR>
autocmd FileType python nmap <buffer> <leader>tr :TermSend python %<CR>
autocmd FileType sh nmap <buffer> <leader>tr:TermSend bash %<CR>
autocmd FileType rust nmap <buffer> <leader>tr:TermSend cargo run<CR>
autocmd FileType lua nmap <buffer> <leader>tr:TermSend lua %<CR>

" floatLf
nmap \ :LfToggle<CR>
nmap <leader>\ :LfToggleCurrentBuf<CR>
let g:floatLf_lf_close = '\'

" fold
nmap <leader><leader> za

" leetcode cli
nmap <localleader>lt :T leetcode test %<CR>
nmap <localleader>ls :T leetcode submit %<CR>

nmap <leader>cd :cd %:p:h<CR>
nmap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nmap ]e  :<c-u>execute 'move +'. v:count1<cr>
nmap + <C-w>+
nmap - <C-w>-
nmap S :%s//g<left><left>
nmap <Leader>+ 20+ 
nmap <Leader>- 20- 
nmap <left> <C-w>>
nmap <right> <C-w><
nmap <silent><a-h> <C-w>h
nmap <silent><a-j> <C-w>j
nmap <silent><a-k> <C-w>k
nmap <silent><a-l> <C-w>l
nmap <Leader>y "+yy
vmap <Leader>y "+y
nmap <leader>qj <C-w>j:q<CR>
nmap <leader>qh <C-w>h:q<CR>
nmap <leader>qk <C-w>k:q<CR>
nmap <leader>ql <C-w>l:q<CR>
nmap <leader>= <c-w>=
noremap ' ;
noremap ; :


nmap ]b :bnext<CR>
nmap [b :bprevious<CR>
nmap ]q :cnext<CR>
nmap [q :cprevious<CR>
nmap <leader>qq :ccl<CR>
nmap <leader>qo :copen<CR>


inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
inoremap jk <Esc>`^
inoremap JK <Esc>`^
nmap <leader>n :noh<CR><Esc>
nmap x "_dl
nmap <leader>cof :e ~/.config/nvim/init.vim<CR>
nmap <leader>wo <C-w>o
nmap <leader>bc :bd<CR>
nmap <leader>w :w<CR>
nmap :: :<c-f>
nmap Y y$

