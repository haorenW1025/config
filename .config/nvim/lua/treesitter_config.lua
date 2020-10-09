require'nvim-treesitter.configs'.setup {
  textobjects = {
    swap = {
      enable = true,
      disable = {"cpp"},
      swap_next = {
        ["<leader>sn"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sp"] = "@parameter.inner",
      },
    },
  },
}


require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {'cpp'}
    },
    incremental_selection = {
        enable = false,
        disable = {"cpp"},
        keymaps = {
          init_selection = 'gnn',
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        }
    },
    ensure_installed = {'rust', 'lua', 'python'}
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      disable = {'cpp'},
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      disable = {"cpp"},
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
        },
      },
    },
  },
}
require'nvim-treesitter.configs'.setup {
  textobjects = {
    swap = {
      enable = true,
      disable = {"cpp"},
      swap_next = {
        ["<leader>sn"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>sp"] = "@parameter.inner",
      },
    },
  },
}


require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
        disable = {'cpp'}
    },
    incremental_selection = {
        enable = false,
        disable = {"cpp"},
        keymaps = {
          init_selection = 'gnn',
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        }
    },
    ensure_installed = {'rust', 'lua', 'python'}
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      disable = {'cpp'},
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      disable = {"cpp"},
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function",
        },
      },
    },
  },
}

