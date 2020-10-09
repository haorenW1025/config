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


packadd! vim-gitgutter
packadd! delimitMate
packadd! vim-smoothie
packadd! ultisnips
packadd! vim-vsnip
packadd! vim-vsnip-integ
packadd! nvim-lsp
packadd! nvim-treesitter
packadd! nvim-treesitter-textobjects
packadd! completion-nvim
packadd! diagnostic-nvim
packadd! completion-buffers
" packadd! completion-tabnine
" packadd! gina.vim
packadd! vim-startify
" packadd! fzf-preview.vim
" packadd! vimtex
packadd! indentLine
packadd! fzf.vim
packadd! vim-cpp-modern
packadd! colorbuddy.vim
" packadd! snippets.nvim
" packadd! nvim-metals
" packadd! express_line.nvim
packadd! plenary.nvim
packadd! popup.nvim
packadd! telescope.nvim
" packadd! vimspector
" packadd! nvim-metals
" packadd! typeracer.nvim
" packadd! luvjob.nvim
" packadd! expressline.nvim

" packadd! coc.nvim


luafile ~/.config/nvim/init.lua
