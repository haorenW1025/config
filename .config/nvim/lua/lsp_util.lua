local lsp = require'lspconfig'
local saga = require 'lspsaga'
local trouble = require 'trouble'
local lspkind = require('lspkind')

trouble.setup()

local cmp = require'cmp'
lspkind.init({
    -- enables text annotations
    --
    -- default: true
    with_text = true,

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',
    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = " ",
      Method = " ",
      Function = " ",
      Constructor = " ",
      Field = "ﰠ ",
      Variable = " ",
      Class = "ﴯ ",
      Interface = " ",
      Module = "  ",
      Property = "ﰠ ",
      Unit = "塞 ",
      Value = " ",
      Enum = "  ",
      Keyword = " ",
      Snippet = "  ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = "פּ ",
      Event = " ",
      Operator = " ",
      TypeParameter = ""
    },
})


cmp.setup({
  snippet = {
    expand = function(args)
      -- For `vsnip` user.
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` user.

      -- For `luasnip` user.
      require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` user.
      -- vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },

    -- For vsnip user.
    -- { name = 'vsnip' },

    -- For luasnip user.
    -- { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = 'buffer' },
  },
  formatting = {
    -- format = lspkind.cmp_format({with_text = false})
      format = function(entry, vim_item)
      vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        latex_symbols = "[Latex]",
      })[entry.source.name]
      return vim_item
    end
  }
})



saga.init_lsp_saga({
  border_style = "round",
  finder_action_keys = {
    open = 'e', vsplit = 'v',split = 'x',quit = 'q',scroll_down = '<C-d>', scroll_up = '<C-u>' -- quit can be a table
  },
})

-- init.lua
vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    position = 'right',
    keymaps = {
        close = "q",
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "K",
        rename_symbol = "r",
        code_actions = "a",
    },
    lsp_blacklist = {},
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = true,
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

local on_attach = function(client, bufnr)
  require'lsp_status'.on_attach(client)
  -- require'lsp_signature'.on_attach(cfg, bufnr)
  -- This came from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/lsp_config.lua
  vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
  vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
  local mapper = function(mode, key, result)
    vim.api.nvim_buf_set_keymap(0, mode, key, result, {noremap=true, silent=true})
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

  mapper('n', '<leader>dh', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  mapper('n', '<leader>dl', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  mapper('n', '<leader>bf', '<cmd>lua vim.lsp.buf.formatting()<CR>')
  mapper('n', '<leader>ic', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>')
  mapper('n', '<leader>oc', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>')
  mapper('n', '<leader>rn', '<cmd>lua require(\'lspsaga.rename\').rename()<CR>')
  mapper('n', 'gC', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  mapper('n', 'gh', '<cmd>lua require\'lspsaga.provider\'.lsp_finder()<CR>')
  mapper('n', '<leader>ca', '<cmd>lua require(\'fzf-lua\').lsp_code_actions()<CR>')
  mapper('n', 'gd', '<cmd>lua require(\'fzf-lua\').lsp_definitions()<CR>')
  mapper('n', 'gp' ,'<cmd>lua require\'lspsaga.provider\'.preview_definiton()<CR>')
  mapper('n', 'K', '<cmd>lua require(\'lspsaga.hover\').render_hover_doc()<CR>')
  mapper('n', 'gD', '<cmd>lua require(\'fzf-lua\').lsp_implementations()<CR>')
  mapper('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  mapper('n', 'gr', '<cmd>lua require(\'fzf-lua\').lsp_references()<CR>')
  mapper('n', 'g0', '<cmd>lua require(\'fzf-lua\').lsp_document_symbols()<CR>')
  mapper('n', 'gW', '<cmd>lua require(\'fzf-lua\').lsp_workspace_symbols()<CR>')
  -- mapper('i', '<c-p>', '<cmd>lua require(\'lspsaga.signaturehelp\').signature_help()<CR>')
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

lsp.pylsp.setup{
  on_attach= on_attach;
}

-- lsp.pyright.setup{
--   on_attach = on_attach;
-- }

lsp.ccls.setup{
  root_dir = lsp.util.root_pattern("compile_commands.json", ".ccls", "compile_flags.txt"),
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

-- lsp.clangd.setup{
--   on_attach = on_attach;
--   capabilities = {
--     textDocument = {
--       completion = {
--         completionItem = {
--           snippetSupport = true
--         }
--       }
--     }
--   },
-- }

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.gopls.setup{
  on_attach = on_attach;
  capabilities = capabilities,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}

