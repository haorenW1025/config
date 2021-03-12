-- loading packages
-- treesitter
-- LSP
vim.cmd('packadd nvim-lsp')
-- vim.cmd('packadd vim-ccls')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd completion-buffers')
vim.cmd('packadd! vim-vsnip')
vim.cmd('packadd! vim-vsnip-integ')
-- Utils
vim.cmd('packadd plenary.nvim')
vim.cmd('packadd popup.nvim')
vim.cmd('packadd! telescope.nvim')
vim.cmd('packadd! vim-gitgutter')
vim.cmd('packadd! delimitMate')
vim.cmd('packadd! vim-smoothie')
vim.cmd('packadd! vimtex')
vim.cmd('packadd! indentLine')
vim.cmd('packadd! vim-doge')
vim.cmd('packadd! lspsaga.nvim')
-- treesitter
vim.cmd('packadd nvim-treesitter')
vim.cmd('packadd nvim-treesitter-textobjects')

-- local if_mac = io.popen('uname -s','r'):read('*l') == "Darwin"
require('treesitter_config')
require('lsp_util')
require('mapping')

