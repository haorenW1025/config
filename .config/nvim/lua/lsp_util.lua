local lsp = require'lspconfig'
local callback = require'callback'

local function preview_location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    vim.lsp.log.info(method, 'No location found')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,
    underline = false,
    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

local on_attach = function(client)
  require'lsp_status'.on_attach(client)
  require'completion'.on_attach({
    sorting = 'alphabet',
    enable_auto_signature = 0,
    enable_auto_hover = 0,
    matching_strategy_list = {'exact', 'fuzzy'},
    abbr_length = 30,
    menu_length = 30,
    syntax_at_point = syntax_at_point
  })
  -- This came from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/lsp_config.lua
  local mapper = function(mode, key, result)
    vim.fn.nvim_buf_set_keymap(0, mode, key, result, {noremap=true, silent=true})
  end

  mapper('n', '<leader>dj', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  mapper('n', '<leader>dk', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  mapper('n', '<leader>bf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  mapper('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  mapper('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
  mapper('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  mapper('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  mapper('n', 'gr', '<cmd>lua require(\'telescope.builtin\').lsp_references(require"telescope_config".themes)<CR>')
  mapper('n', 'g0', '<cmd>lua require(\'telescope_config\').document_symbols(require"telescope_config".themes)<CR>')
  mapper('n', 'gW', '<cmd>lua require(\'telescope_config\').workspace_symbols(require"telescope_config".themes)<CR>')
  mapper('i', '<c-p>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
end

local lua_on_attach = function (client)
  on_attach(client)
  client.server_capabilities.completionProvider.triggerCharacters = {'.'}
end

lsp.sumneko_lua.setup {
  on_attach= lua_on_attach;
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
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true
        }
      }
    }
  },
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

lsp.clangd.setup{
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

lsp.tsserver.setup {
  on_attach = on_attach;
}

lsp.bashls.setup{
  on_attach = on_attach
}

lsp.rust_analyzer.setup{
  on_attach = on_attach;
}

lsp.texlab.setup{
  on_attach = on_attach;
  filetypes = { "plaintex", "tex" }
}

lsp.metals.setup{
  on_attach = on_attach;
}

lsp.solargraph.setup {
  on_attach = on_attach,
}

lsp.hls.setup{
  on_attach = on_attach;
}

lsp.gopls.setup{
  on_attach= on_attach;
}
