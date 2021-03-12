local lsp = require'lspconfig'
local saga = require 'lspsaga'

saga.init_lsp_saga()

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
    enable_auto_signature = 1,
    enable_auto_hover = 1,
    matching_strategy_list = {'exact', 'fuzzy'},
    abbr_length = 30,
    menu_length = 30,
    syntax_at_point = syntax_at_point
  })
  -- This came from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/lsp_config.lua
  vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  local mapper = function(mode, key, result)
    vim.fn.nvim_buf_set_keymap(0, mode, key, result, {noremap=true, silent=true})
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec ([[
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end

  mapper('n', '<leader>dh', '<cmd>lua require\'lspsaga.diagnostic\'.lsp_jump_diagnostic_prev()<CR>')
  mapper('n', '<leader>dl', '<cmd>lua require\'lspsaga.diagnostic\'.lsp_jump_diagnostic_next()<CR>')
  mapper('n', '<leader>bf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  mapper('n', '<leader>ic', '<cmd>lua require(\'lsp_call\').incoming_calls()<CR>')
  mapper('n', '<leader>rn', '')
  mapper('n', 'gC', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  mapper('n', 'gh', '<cmd>lua require\'lspsaga.provider\'.lsp_finder()<CR>')
  mapper('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', 'gp' ,'<cmd>lua require\'lspsaga.provider\'.preview_definiton()<CR>')
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

lsp.jedi_language_server.setup{
  on_attach = on_attach;
}

-- lsp.pyright.setup{
--   on_attach = on_attach;
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
  capabilities = {
    ["rust-analyzer"] = {
      completion = {
        autoimport = {
          enable = true
        }
      }
    },
  }
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.gopls.setup{
  on_attach = on_attach;
	cmd = {"gopls", "serve"},
	-- capabilities = capabilities,
	-- settings = {
		-- gopls = {
			-- analyses = {
			-- 	unusedparams = true,
			-- },
			-- staticcheck = true,
		-- },
	-- },
}

