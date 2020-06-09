-- lsp setup
local lsp = require'nvim_lsp'

require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = false,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = 'gnn',
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        }
    },
    ensure_installed = {'rust', 'cpp', 'lua', 'python'}
}


local on_attach = function(client)
  require'lsp_status'.on_attach(client)
  require'diagnostic'.on_attach()
  require'completion'.on_attach({
      sorter = 'alphabet',
      matcher = {'exact', 'fuzzy'}
    })
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
        keywordSnippet = "Disable";
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
    },
  };
}

lsp.vimls.setup{
  on_attach = on_attach;
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
  filetypes = { "python", "python.ipython" }
}

-- lsp.pyls_ms.setup{
  -- on_attach = require'on_attach'.on_attach;
-- }

lsp.clangd.setup{
  on_attach = on_attach;
  -- capabilities = {
  --   textDocument = {
  --     completion = {
  --       completionItem = {
  --         snippetSupport = true
  --       }
  --     }
  --   }
  -- },
  -- init_options = {
  --   usePlaceholders = true,
  --   completeUnimported = true
  -- }
}

lsp.rust_analyzer.setup{
  on_attach = on_attach;
}

lsp.metals.setup{
  on_attach = on_attach;
}
-- local metals = require'metals'

