augroup pandoc_syntax
    au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
    " au! BufNewFile,BufFilePre,BufRead *.pyx set filetype=python
augroup END
luafile ~/.config/nvim/lua/color.lua
autocmd! gitgutter CursorHold,CursorHoldI
