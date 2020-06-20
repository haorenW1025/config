-- lsp setup
local lsp = require'nvim_lsp'
local callback = require'callback'
local dap = require'dap'

dap.adapters.cpp = {
  attach = {
    pidProperty = "pid",
    pidSelect = "ask"
  },
  command = 'lldb-vscode', -- my binary was called 'lldb-vscode-11'
  env = {
    LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
  },
  name = "lldb"
}

vim.cmd [[
    command! -complete=file -nargs=* DebugC lua require "my_debug".start_c_debugger({<f-args>}, "gdb")
]]
vim.cmd [[
    command! -complete=file -nargs=* DebugRust lua require "my_debug".start_c_debugger({<f-args>}, "gdb", "rust-gdb")
]]

dap.repl.commands = {
  continue = {'.continue', '.c'},
  next_ = {'.next', '.n'},
  into = {'.into', '.i'},
  out = {'.out', '.o'},
  scopes = {'.scopes'},
  threads = {'.threads'},
  frames = {'.frames'},
  exit = {'exit', '.exit'},
  up = {'.up'},
  down = {'.down'},
  goto_ = {'.goto'},
}

-- require'nvim-treesitter.configs'.setup {
--     highlight = {
--         enable = true,
--         disable = {'cpp'}
--     },
--     incremental_selection = {
--         enable = true,
--         keymaps = {
--           init_selection = 'gnn',
--           node_incremental = "grn",
--           scope_incremental = "grc",
--           node_decremental = "grm",
--         }
--     },
--     ensure_installed = {'rust', 'cpp', 'lua', 'python'}
-- }



local on_attach = function(client)
  require'lsp_status'.on_attach(client)
  require'diagnostic'.on_attach()
  require'completion'.on_attach({
      sorter = 'alphabet',
      matcher = {'exact', 'substring', 'fuzzy'}
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
  mapper('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  mapper('n', 'g0', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
  mapper('i', '<c-l>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
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

lsp.tsserver.setup{
  on_attach = on_attach;
  cmd = "typescript-language-server --stdio"
}

lsp.metals.setup{
  on_attach = on_attach;
}
-- local metals = require'metals'

