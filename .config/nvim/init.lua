-- loading packages
-- treesitter
vim.cmd('packadd nvim-treesitter')
vim.cmd('packadd nvim-treesitter-textobjects')
-- LSP
vim.cmd('packadd nvim-lsp')
vim.cmd('packadd completion-nvim')
vim.cmd('packadd completion-buffers')
vim.cmd('packadd! vim-vsnip')
vim.cmd('packadd! vim-vsnip-integ')
-- Utils
vim.cmd('packadd plenary.nvim')
vim.cmd('packadd popup.nvim')
vim.cmd('packadd! telescope.nvim')
vim.cmd('packadd! colorbuddy.vim')
vim.cmd('packadd! vim-gitgutter')
vim.cmd('packadd! delimitMate')
vim.cmd('packadd! vim-smoothie')
vim.cmd('packadd! vimtex')
vim.cmd('packadd! indentLine')

require('treesitter_config')
require('lsp_util')
require('mapping')

-- local if_mac = io.popen('uname -s','r'):read('*l') == "Darwin"

