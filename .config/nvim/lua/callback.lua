local util = vim.lsp.util
local api = vim.api
local M = {}

local symbol_callback = function(_, _, result, _, bufnr)
  if not result or vim.tbl_isempty(result) then return end

  util.set_qflist(util.symbols_to_items(result, bufnr))
  api.nvim_command("Clap quickfix")
end

M.get_symbol = function()
end

vim.lsp.callbacks['textDocument/documentSymbol'] = symbol_callback

return M
