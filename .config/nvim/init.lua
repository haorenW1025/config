-- lsp setup
local lsp = require'nvim_lsp'
local callback = require'callback'

require'nvim-treesitter.configs'.setup {
  refactor = {
    highlight_definitions = { enable = true },
    highlight_current_scope = { enable = false },
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    swap = {
      enable = true,
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
        keymaps = {
          init_selection = 'gnn',
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        }
    },
    ensure_installed = {'rust', 'cpp', 'lua', 'python'}
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
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
local function syntax_at_point()
    if vim.g.loaded_nvim_treesitter and vim.g.loaded_nvim_treesitter > 0 then
        local current_node = require('nvim-treesitter/ts_utils').get_node_at_cursor()
        if current_node then
            return current_node:type()
        end
    end
    -- fallback
    local pos = vim.api.nvim_win_get_cursor(0)
    return vim.fn.synIDattr(vim.fn.synID(pos[1], pos[2], 1), "name")
end

local on_attach = function(client)
  require'lsp_status'.on_attach(client)
  require'diagnostic'.on_attach({
    -- enable_virtual_text = 1,
    -- virtual_text_prefix = 'F',
  })
  require'completion'.on_attach({
    sorting = 'alphabet',
    enable_auto_signature = 1,
    matching_strategy_list = {'exact', 'fuzzy'},
    syntax_at_point = syntax_at_point
  })
  -- This came from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/lsp_config.lua
  local mapper = function(mode, key, result)
    vim.fn.nvim_buf_set_keymap(0, mode, key, result, {noremap=true, silent=true})
  end

  mapper('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  mapper('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  mapper('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  mapper('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  mapper('n', 'gr', '<cmd>lua require(\'telescope.builtin\').lsp_references()<CR>')
  mapper('n', 'g0', '<cmd>lua require(\'telescope.builtin\').lsp_document_symbols()<CR>')
  mapper('n', 'gW', '<cmd>lua require(\'telescope.builtin\').lsp_workspace_symbols()<CR>')
  mapper('i', '<c-p>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
end

lsp.sumneko_lua.setup {
  on_attach= on_attach;
  cmd = {
    "/home/whz861025/packages/lua-language-server/bin/Linux/lua-language-server",
    "-E",
    "/home/whz861025/packages/lua-language-server/main.lua"
  };
  settings = {
    Lua = {
      completion = {
        -- keywordSnippet = "Disable";
      };
      runtime = {
        version = "LuaJIT";
        };
      diagnostics={
        enable=true,
        globals={
          "vim", "Color", "c", "Group", "g", "s", "describe", "it", "before_each", "after_each"
        },
      },
      workspace = {
        library = {
          [vim.fn.expand("~/packages/neovim/runtime/lua")] = true,
          [vim.fn.expand("~/packages/neovim/src/nvim/lua")] = true,
        },
      },
    },
  };
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
}

lsp.vimls.setup{
  on_attach = on_attach;
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
}

lsp.pyls.setup{
  on_attach = on_attach;
  settings = {
    pyls = {
      plugins = {
        pycodestyle = { enabled = false; },
      }
    }
  };
  filetypes = { "python"}
}

-- lsp.pyls_ms.setup{
  -- on_attach = require'on_attach'.on_attach;
-- }

lsp.ccls.setup{
  on_attach = on_attach;
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
}

lsp.rls.setup{
  on_attach = on_attach;
}

lsp.texlab.setup{
  on_attach = on_attach;
  filetypes = { "plaintex", "tex" }
}

lsp.metals.setup{
  on_attach = on_attach;
}

lsp.hls.setup{
  on_attach = on_attach;
}

lsp.gopls.setup{
  on_attach= on_attach;
}
