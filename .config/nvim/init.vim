syntax enable
syntax on
filetype indent plugin on
set nocompatible
set number
let mapleader = " "
let maplocalleader = ","

execute 'luafile ' . stdpath('config') . '/lua/plugins.lua'
command! PackerInstall packadd packer.nvim | lua require('plugins').install()
command! PackerUpdate packadd packer.nvim | lua require('plugins').update()
command! PackerSync packadd packer.nvim | lua require('plugins').sync()
command! PackerClean packadd packer.nvim | lua require('plugins').clean()
command! PackerCompile packadd packer.nvim | lua require('plugins').compile('~/.config/nvim/plugin/packer_load.vim')

packadd! nord-vim
packadd! vim-gitgutter
packadd! delimitMate
packadd! indentLine
packadd! vim-smoothie
packadd! ultisnips
packadd! vim-vsnip
packadd! vim-vsnip-integ
packadd! nvim-lsp
packadd! nvim-treesitter
packadd! completion-nvim
packadd! diagnostic-nvim
" packadd! completion-buffers
packadd! completion-tabnine
packadd! gina.vim
packadd! vim-startify
packadd! fzf-preview.vim

" packadd! coc.nvim


luafile ~/.config/nvim/init.lua
