-- loading packages
-- treesitter
-- LSP
vim.cmd('packadd nvim-lsp')
vim.cmd('packadd! vim-vsnip')

-- Utils
vim.cmd('packadd plenary.nvim')
vim.cmd('packadd popup.nvim')
vim.cmd('packadd vim-doge')
-- vim.cmd('packadd! telescope.nvim')
vim.cmd('packadd! vim-gitgutter')
vim.cmd('packadd! delimitMate')
vim.cmd('packadd! vimtex')
vim.cmd('packadd! indentLine')
vim.cmd('packadd! lspsaga.nvim')
-- treesitter
vim.cmd('packadd nvim-treesitter')
vim.cmd('packadd nvim-treesitter-textobjects')

-- local if_mac = io.popen('uname -s','r'):read('*l') == "Darwin"
require('treesitter_config')
require('lsp_util')
require('mapping')
require('snippets')
-- require('feline')
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff',
                  {'diagnostics', sources={'nvim_lsp', 'coc'}}},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}
require('neoscroll').setup({
    -- All these keys will be mapped to their corresponding default scrolling animation
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,        -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,              -- Function to run after the scrolling animation ends
})

