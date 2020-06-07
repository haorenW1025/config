syntax enable
syntax on
set nocompatible
set number
let mapleader = " "
let maplocalleader = ","

" Load packager only when you need it
function! PackagerInit() abort
    packadd vim-packager
    call packager#init()
    call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
    call packager#add('arcticicestudio/nord-vim')
    call packager#add('junegunn/fzf.vim')
    call packager#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
    call packager#add('Raimondi/delimitMate')
    call packager#add('luochen1990/rainbow')
    call packager#add('tpope/vim-surround')
    call packager#add('tpope/vim-repeat')
    call packager#add('tpope/vim-obsession')
    call packager#add('tpope/vim-commentary')
    call packager#add('airblade/vim-gitgutter')
    call packager#add('neovim/nvim-lsp', {'type': 'opt'})
    call packager#add('SirVer/ultisnips')
    call packager#add('haorenW1025/vim-snippets')

    " utility plugins
    call packager#add('psliwka/vim-smoothie')
    call packager#add('Yggdroot/indentLine')

    " alignment plugin
    call packager#add('junegunn/vim-easy-align')

    call packager#add('kana/vim-textobj-user')
    call packager#add('Julian/vim-textobj-variable-segment')
    call packager#add('justinmk/vim-sneak')

    call packager#add('sgur/vim-editorconfig')
    " colorizer
    call packager#add('norcalli/nvim-colorizer.lua')

    " tree-sitter
    call packager#add('nvim-treesitter/nvim-treesitter', {'type': 'opt'})
    " Plug 'mfussenegger/nvim-dap'
    call packager#add('bfredl/nvim-ipy', { 'type': 'opt' })

    call packager#add('hrsh7th/vim-vsnip-integ', {'type': 'opt'})
    call packager#add('hrsh7th/vim-vsnip', {'type': 'opt'})

    call packager#add('steelsojka/completion-buffers', {'type': 'opt'})
    " my plugins
    call packager#add('git@github.com:haorenW1025/completion-nvim.git', {'type': 'opt'})
    call packager#add('git@github.com:haorenW1025/diagnostic-nvim.git', {'type': 'opt'})
    call packager#add('git@github.com:haorenW1025/term-nvim.git')
    call packager#add('git@github.com:haorenW1025/floatLf-nvim.git')

  "Loaded only for specific filetypes on demand. Requires autocommands below.
endfunction

command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call PackagerInit() | call packager#clean()
command! PackagerStatus call PackagerInit() | call packager#status()
packadd vim-vsnip
packadd vim-vsnip-integ
packadd nvim-lsp
packadd nvim-treesitter
packadd completion-nvim.git
packadd diagnostic-nvim.git
packadd completion-buffers
packadd fzf.vim

luafile ~/.config/nvim/init.lua
