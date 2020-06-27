syntax enable
syntax on
filetype indent plugin on
set nocompatible
set number
let mapleader = " "
let maplocalleader = ","


" Load packager only when you need it
function! PackagerInit() abort
    packadd vim-packager
    call packager#init()
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
    call packager#add('yuki-ycino/fzf-preview.vim', {'type': 'opt'})
    call packager#add('liuchengxu/vim-clap', { 'do': ':Clap install-binary', 'type': 'opt'})
    call packager#add('arcticicestudio/nord-vim', {'type': 'opt'})
    call packager#add('Raimondi/delimitMate', {'type': 'opt'})
    call packager#add('luochen1990/rainbow', {'type': 'opt'})
    call packager#add('tpope/vim-surround')
    call packager#add('tpope/vim-repeat')
    call packager#add('tpope/vim-obsession')
    call packager#add('tpope/vim-commentary')
    call packager#add('hardcoreplayers/dashboard-nvim', {'type': 'opt'})
    call packager#add('airblade/vim-gitgutter', {'type': 'opt'})
    call packager#add('haorenW1025/vim-snippets')
    call packager#add('lervag/vimtex', {'type': 'opt'})

    " utility plugins
    call packager#add('psliwka/vim-smoothie', {'type': 'opt'})
    call packager#add('Yggdroot/indentLine', {'type': 'opt'})

    " alignment plugin
    call packager#add('junegunn/vim-easy-align', {'type': 'opt'})

    call packager#add('kana/vim-textobj-user')
    call packager#add('Julian/vim-textobj-variable-segment')
    call packager#add('justinmk/vim-sneak')

    call packager#add('sgur/vim-editorconfig')
    " colorizer
    call packager#add('norcalli/nvim-colorizer.lua')

    call packager#add('tpope/vim-fugitive', {'type': 'opt'})
    call packager#add('neovim/nvim-lsp', {'type': 'opt'})
    call packager#add('SirVer/ultisnips', {'type': 'opt'})
    " tree-sitter
    call packager#add('nvim-treesitter/nvim-treesitter', {'type': 'opt'})
    call packager#add('bfredl/nvim-ipy', { 'type': 'opt' })

    call packager#add('hrsh7th/vim-vsnip-integ', {'type': 'opt'})
    call packager#add('hrsh7th/vim-vsnip', {'type': 'opt'})

    call packager#add('steelsojka/completion-buffers', {'type': 'opt'})
    " my plugins
    call packager#add('git@github.com:haorenW1025/completion-nvim.git', {'type': 'opt'})
    call packager#add('git@github.com:haorenW1025/diagnostic-nvim.git', {'type': 'opt'})
    call packager#add('git@github.com:haorenW1025/term-nvim.git')
    call packager#add('git@github.com:haorenW1025/floatLf-nvim.git')

endfunction

command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call PackagerInit() | call packager#clean()
command! PackagerStatus call PackagerInit() | call packager#status()
packadd! nord-vim
packadd! vim-gitgutter
packadd! delimitMate
packadd! indentLine
packadd! vim-easy-align
packadd! vim-smoothie
packadd! ultisnips
" packadd! vim-vsnip
" packadd! vim-vsnip-integ
packadd! nvim-lsp
" packadd! nvim-treesitter
packadd! completion-nvim.git
packadd! diagnostic-nvim.git
packadd! completion-buffers
packadd! dashboard-nvim
packadd! fzf-preview.vim
" packadd! fzf.vim
" packadd! vim-fugitive


luafile ~/.config/nvim/init.lua
