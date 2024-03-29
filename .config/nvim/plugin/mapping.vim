" git
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <leader>ghp <Plug>(GitGutterPreviewHunk)
nmap <leader>ghu <Plug>(GitGutterUndoHunk)
nmap <leader>ghs <Plug>(GitGutterStageHunk)

nmap Q @a
nmap <leader>es :UltiSnipsEdit<CR>

" pandoc
autocmd Filetype markdown nnoremap  <leader>pdf <cmd>lua require'markdown'.convertFile()<CR>

" goto my personal wiki
nmap <leader>w :e ~/workplace/note/index.md<CR>

" tmux like terminal
tnoremap <c-a> <c-\><c-n>

nmap <c-n> :tabnew term://zsh<CR>
nmap <c-t>v :vsplit term://zsh<CR>i
nmap <c-t>x :split term://zsh<CR>i
" tmap <c-n> <c-a><CR>:tabnew term://zsh<CR>i
tmap <c-t>v <c-a><CR>:vsplit term://zsh<CR>i
tmap <c-t>x <c-a><CR>:split term://zsh<CR>i
tmap <c-t>] <c-a>:+tabmove<cr>
tmap <c-t>[ <c-a>:-tabmove<cr>
tmap <a-h> <c-a><CR><c-w>h
tmap <a-j> <c-a><CR><c-w>j
tmap <a-k> <c-a><CR><C-w>k
tmap <a-l> <c-a><CR><c-w>l
tmap <c-t>J <c-t><CR><c-w>J
tmap <c-t>K <c-t><CR><c-w>K
tmap <c-t>H <c-t><CR><c-w>H
tmap <c-t>L <c-t><CR><c-w>L

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

" custom function
nnoremap <buffer> <leader>cc <cmd> lua require'util'.toggleConceal()<CR>

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

" lazygit
function! ToggleLazyGit()
    call ToggleNoBorderTerm('lazygit')
endfunction
nnoremap <silent> <leader>tg :call ToggleLazyGit()<CR>

" fold
nmap <leader><leader> za

function CloseBuffer()
    bprevious
    bdelete! #
endfunction

nmap <leader>bq :call CloseBuffer()<CR>

nmap <leader>cd :cd %:p:h<CR>
nmap [e  :<c-u>execute 'move -1-'. v:count1<cr>
nmap ]e  :<c-u>execute 'move +'. v:count1<cr>
nmap + <C-w>+
nmap - <C-w>-
nmap S :%s//g<left><left>
nmap <Leader>s+ 20+ 
nmap <Leader>s- 20- 
nmap <leader>ss :split<CR>
nmap <leader>sv :vsplit<CR>
nmap <leader>tn :tabnew<CR>
nmap <leader>v+ :vertical resize +20<CR>
nmap <leader>v- :vertical resize -20<CR>
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
nmap <leader>= <c-w>=
noremap ' ;
noremap ; :


nmap ]b :bnext<CR>
nmap [b :bprevious<CR>
nmap ]q :cnext<CR>
nmap [q :cprevious<CR>
nmap <leader>qq :ccl<CR>
nmap <leader>qo :copen<CR>
nmap gd <c-]>


imap jk <esc>
imap JK <esc>
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <leader>n :noh<CR><Esc>
nmap x "_dl
nmap <leader>cof :e ~/.config/nvim/init.vim<CR>
nmap <leader>bc :bd<CR>
nmap :: :<c-f>
nmap Y y$

" vimspector
" nmap <leader>dr <Plug>VimspectorRestart
" nmap <leader>dc <Plug>VimspectorContinue
" nmap <leader>db <Plug>VimspectorToggleBreakpoint
" nmap <leader>dB <Plug>VimspectorToggleConditionBreakpoint
" nmap <leader>dr <Plug>VimspectorRestart
" nmap <leader>dr <Plug>VimspectorRestart
" nmap <leader>dr <Plug>VimspectorRestart
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>

nmap go :SymbolsOutline<CR>
nnoremap do <cmd>LspTroubleToggle<cr>
