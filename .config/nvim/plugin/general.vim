syntax enable
syntax on
filetype indent plugin on
set nocompatible
set number
let mapleader=" "
let localleader=","

execute 'luafile ' . stdpath('config') . '/lua/plugins.lua'
command! PackerInstall packadd packer.nvim | lua require('plugins').install()
command! PackerUpdate packadd packer.nvim | lua require('plugins').update()
command! PackerSync packadd packer.nvim | lua require('plugins').sync()
command! PackerClean packadd packer.nvim | lua require('plugins').clean()
command! PackerCompile packadd packer.nvim | lua require('plugins').compile('~/.config/nvim/plugin/packer_load.vim')

set wildmode=longest,list,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__,node_modules
set pumblend=20
set pumheight=20
set noswapfile

if has("autocmd")
" Highlight TODO, FIXME, NOTE, etc.
autocmd Syntax * call matchadd('Todo', '\W\zs\(TODO\|FIXME\|CHANGED\|BUG\|HACK\)')
autocmd Syntax * call matchadd('Debug', '\W\zs\(NOTE\|INFO\|IDEA\)')
endif

" Terminal settings

augroup neovim_terminal
	autocmd!

	" Disables number lines on terminal buffers
	autocmd TermOpen * :setl nonumber norelativenumber
augroup END

au TermEnter * setlocal scrolloff=0
au TermEnter * setlocal scrollback=5000
au TermLeave * setlocal scrolloff=5

command! -nargs=+ -complete=dir -bar Grep lua require'grep'.asyncGrep(<q-args>)

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{ higroup="IncSearch", timeout=500}
augroup END

nnoremap  ]z :call NextClosedFold('j')<cr>
nnoremap  [z :call NextClosedFold('k')<cr>

function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction


function! Osc52Yank()
    let buffer=system('base64 -w0 ', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    " let tty = $SSH_TTY
    " echo tty
    silent exe "!echo -ne ".shellescape(buffer)." > ".shellescape($NVIM_TTY)
    " silent exe "!echo -ne ".shellescape(buffer)." > ".tty
endfunction
command! Osc52CopyYank call Osc52Yank()
augroup Example
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call Osc52Yank() | endif
augroup END

let defaults = {'placeholder': '⋯',   'line': '▤', 'multiplication': '×' }
let g:FoldText_placeholder    = get(g:, 'FoldText_placeholder',    defaults['placeholder'])
let g:FoldText_line           = get(g:, 'FoldText_line',           defaults['line'])
let g:FoldText_multiplication = get(g:, 'FoldText_multiplication', defaults['multiplication'])
let g:FoldText_info           = get(g:, 'FoldText_info',           1)
let g:FoldText_width          = get(g:, 'FoldText_width',          0)

function! MyFoldText()
    let fs = v:foldstart
    while getline(fs) =~ '^\s*$'
        let fs = nextnonblank(fs + 1)
    endwhile
    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let spaces = repeat(' ', &tabstop)
        let line = substitute(getline(fs), '\t', spaces, 'g')
    endif

    let endBlockChars   = ['end', '}', ']', ')', '})', '},', '}}}']
    let endBlockRegex = printf('^\(\s*\|\s*\"\s*\)\(%s\);\?$', join(endBlockChars, '\|'))
    let endCommentRegex = '\s*\*/\s*$'
    let startCommentBlankRegex = '\v^\s*/\*!?\s*$'

    let foldEnding = strpart(getline(v:foldend), indent(v:foldend), 3)

    if foldEnding =~ endBlockRegex
        if foldEnding =~ '^\s*\"'
            let foldEnding = strpart(getline(v:foldend), indent(v:foldend)+2, 3)
        end
        let foldEnding = " " . g:FoldText_placeholder . " " . foldEnding
    elseif foldEnding =~ endCommentRegex
        if getline(v:foldstart) =~ startCommentBlankRegex
            let nextLine = substitute(getline(v:foldstart + 1), '\v\s*\*', '', '')
            let line = line . nextLine
        endif
        let foldEnding = " " . g:FoldText_placeholder . " " . foldEnding
    else
        let foldEnding = " " . g:FoldText_placeholder
    endif
    let foldEnding = substitute(foldEnding, '\s\+$', '', '')

    redir =>signs | exe "silent sign place buffer=".bufnr('') | redir end
    let signlist = split(signs, '\n')
    let foldColumnWidth = (&foldcolumn ? &foldcolumn : 0)
    let numberColumnWidth = &number ? strwidth(line('$')) : 0
    let signColumnWidth = len(signlist) >= 2 ? 2 : 0
    let width = winwidth(0) - foldColumnWidth - numberColumnWidth - signColumnWidth

    let ending = ""
    if g:FoldText_info
        if g:FoldText_width > 0 && g:FoldText_width < (width-6)
            let endsize = "%-" . string(width - g:FoldText_width + 4) . "s"
        else
            let endsize = "%-11s"
        end
        let foldSize = 1 + v:foldend - v:foldstart
        let ending = printf("%s%s%s", g:FoldText_line, g:FoldText_multiplication, foldSize)
        let ending = printf(endsize, ending)

        if strwidth(line . foldEnding . ending) >= width
            let line = strpart(line, 0, width - strwidth(foldEnding . ending) - 2)
        endif
    endif

    let expansionStr = repeat(" ", width - strwidth(line . foldEnding . ending))
    return line . foldEnding . expansionStr . ending
endfunction

set foldtext=MyFoldText()
set fillchars=fold:-

autocmd FileType text,markdown
    \ setlocal spell  |
    \ set spelllang=en_gb |
    \ setl noai nocin nosi inde= |
    \ setl smartindent |
    \ setl conceallevel=0 |
    \ inoremap <C-c> <c-g>u<Esc>[s1z=`]a<c-g>u |

set dir^=$HOME/.config/nvim//storage/swaps//
set undodir^=$HOME/.config/nvim/storage/undos//
set backupdir^=$HOME/.config/nvim//storage/backups//


" folding
autocmd BufWrite * mkview
autocmd BufRead * silent! loadview

autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
autocmd BufEnter *.ipy setlocal filetype=python.ipython

set hidden
set nobackup
set nowritebackup
set cmdheight=1
set updatetime=300
set shortmess+=ac
set signcolumn=yes


" tab
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set expandtab
autocmd filetype lua,javascript,vue setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab
set shiftround " round indent to a multiple of 'shiftwidth'
set nowrap
set nolinebreak
set textwidth=0 
set wrapmargin=0


autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
cnoremap <c-n> <down>
cnoremap <c-p> <up>

set nospell
set inccommand=split
set nofoldenable
set laststatus=2
set showtabline=2
set conceallevel=0
set termguicolors
set complete=.,w,b,u,t,kspell
set encoding=utf8
set ttyfast
set lazyredraw
set synmaxcol=200
set cul!
set noerrorbells
set visualbell
set t_vb=
set tm=500
set autoread
set backspace=indent,eol,start
set shellpipe=>
set ruler
set history=100
set splitbelow splitright
set wildmenu
set ignorecase
set cursorline
set hlsearch
set noincsearch
set so=5
set bg=dark
set relativenumber
set mouse=v
set t_Co=256
set ai
set si
