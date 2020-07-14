vim.api.nvim_command('packadd nvim-lsp')
vim.api.nvim_command('packadd autocomplete-nvim')

vim.api.nvim_command("command! -nargs=1  LuaPrint    lua print(vim.inspect(<args>))")
vim.api.nvim_command("imap <c-j> <cmd>lua require'autocomplete.completion'.nextSource()<CR>")
vim.api.nvim_command("inoremap <expr> <tab> pumvisible() ? \"\\<C-N>\" : \"\\<C-O>:lua require'autocomplete'.manualCompletion()<CR>\"")
vim.api.nvim_command("autocmd BufEnter * call autocomplete#attach()")

local has_lsp, nvim_lsp = pcall(require, 'nvim_lsp')

if not has_lsp then
  return
end

local M = {}
-- local has_completion, completion = pcall(require, 'completion')
-- local has_diagnostic, diagnostic = pcall(require, 'diagnostic')

local bufmap = vim.api.nvim_buf_set_keymap
local cmd = vim.api.nvim_command

cmd("command! LspInfo lua print(vim.inspect(vim.lsp.buf_get_clients()))")

-- highlights
vim.fn.sign_define('LspDiagnosticsErrorSign', {text='✖ ' or 'E', texthl='LspDiagnosticsError', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsWarningSign', {text='⚠' or 'W', texthl='LspDiagnosticsWarning', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsInformationSign', {text='ℹ' or 'I', texthl='LspDiagnosticsInformation', linehl='', numhl=''})
vim.fn.sign_define('LspDiagnosticsHintSign', {text='➤' or 'H', texthl='LspDiagnosticsHint', linehl='', numhl=''})

-- -- wrapper for go to definition that jumps to the first match, if qfix is populated
-- function M.definition()
--   local oldqf = vim.fn.getqflist()
--   vim.fn.setqflist({})
--   vim.lsp.buf.definition()
--   local timer = vim.loop.new_timer()
--   timer:start(200, 0, vim.schedule_wrap(function()
--     if #vim.fn.getqflist() > 0 then cmd('cc')
--     elseif #oldqf then vim.fn.setqflist(oldqf) end
--     timer:stop()
--     timer:close()
--   end))
-- end

local function on_attach(client, bufnr)
  -- if has_diagnostic then
  --   diagnostic.on_attach()
  -- end

  -- if has_completion then
  --   completion.on_attach()
  -- end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  local com = '<Cmd>lua vim.lsp.'
  bufmap(bufnr, 'n', 'K',      com .. 'buf.hover()<CR>', opts)
  -- bufmap(bufnr, 'n', '<c-]>',  '<Cmd>lua require"initnvim".definition()<CR>', opts)
  bufmap(bufnr, 'n', '<tab><c-]>',  '<c-w>s' .. com .. 'buf.definition()<CR>', opts)
  bufmap(bufnr, 'n', '<c-]>',  com .. 'buf.definition()<CR>', opts)
  bufmap(bufnr, 'n', 'gd',     com .. 'buf.declaration()<CR>', opts)
  bufmap(bufnr, 'n', '\\li',   com .. 'buf.implementation()<CR>', opts)
  bufmap(bufnr, 'n', '\\la',   com .. 'buf.code_action()<CR>', opts)
  bufmap(bufnr, 'n', '\\lr',   com .. 'buf.references()<CR>', opts)
  bufmap(bufnr, 'n', '\\lt',   com .. 'buf.type_definition()<CR>', opts)
  bufmap(bufnr, 'n', '\\ld',   com .. 'util.show_line_diagnostics()<CR>', opts)
  bufmap(bufnr, 'n', '\\ls',   com .. 'buf.document_symbol()<CR>', opts)
  bufmap(bufnr, 'n', '\\lw',   com .. 'buf.workspace_symbol()<CR>', opts)

  -- if client.resolved_capabilities.document_highlight then
  --   cmd('autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()')
  --   cmd('autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()')
  --   cmd('autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()')
  -- end
end

------------------------------------------------------------------------
--                          init lsp servers                          --
------------------------------------------------------------------------

local clangd = ( vim.fn.executable('clangd') == 1 and {"clangd", "--background-index"} ) or
               ( vim.fn.executable('clangd.exe') == 1 and {"clangd.exe", "--background-index"} ) or nil

local servers = {
  {
    name = 'pyls',
    can_attach = vim.fn.executable('pyls') == 1
  },
  {
    name = 'clangd',
    can_attach = clangd,
    config = { cmd = clangd }
  },
  {
    name = 'sumneko_lua',
    can_attach = true,
    config = {
      cmd = {
        "/home/whz861025/packages/lua-language-server/bin/Linux/lua-language-server",
        "-E",
        "/home/whz861025/packages/lua-language-server/main.lua"
      },
      settings = {
        Lua = {
          runtime={
            version="LuaJIT",
          },
          diagnostics={
            enable=true,
            globals={"vim", "spoon", "hs"},
          },
        }
      },
    }
  },
}

for _, serv in ipairs(servers) do
  if serv.can_attach then
    if serv.config then
      serv.config.on_attach = on_attach
    else
      serv.config = {
        on_attach = on_attach
      }
    end
    nvim_lsp[serv.name].setup(serv.config)
  end
end

return M
