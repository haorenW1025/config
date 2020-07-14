nnoremap <buffer> <CR> <cmd>lua require'markdown'.followLink()<CR>
exe "syn match texMathSymbol '\\\\lceil' contained conceal cchar=⌈"
exe "syn match texMathSymbol '\\\\in' contained conceal cchar=∈"
