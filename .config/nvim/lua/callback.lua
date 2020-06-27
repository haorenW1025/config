local util = vim.lsp.util
local api = vim.api
local log = require 'vim.lsp.log'
local M = {}

local function location_callback(_, method, result)
  if result == nil or vim.tbl_isempty(result) then
    local _ = log.info() and log.info(method, 'No location found')
    return nil
  end

  -- textDocument/definition can return Location or Location[]
  -- https://microsoft.github.io/language-server-protocol/specifications/specification-current/#textDocument_definition

  if vim.tbl_islist(result) then
    util.jump_to_location(result[1])
  end

  util.set_qflist(util.locations_to_items(result))
  api.nvim_command("FzfPreviewQuickFix")
end

-- modified from source to escape variable
local function symbols_to_items(symbols, bufnr)
  local function _symbols_to_items(_symbols, _items, _bufnr)
    for _, symbol in ipairs(_symbols) do
      if symbol.location then -- SymbolInformation type
        local range = symbol.location.range
        local kind = util._get_symbol_kind_name(symbol.kind)
        table.insert(_items, {
          filename = vim.uri_to_fname(symbol.location.uri),
          lnum = range.start.line + 1,
          col = range.start.character + 1,
          kind = kind,
          text = '['..kind..'] '..symbol.name,
        })
      elseif symbol.range then -- DocumentSymbole type
        local kind = util._get_symbol_kind_name(symbol.kind)
        if kind == 'Variable' then
          goto continue
        end
        table.insert(_items, {
          -- bufnr = _bufnr,
          filename = vim.api.nvim_buf_get_name(_bufnr),
          lnum = symbol.range.start.line + 1,
          col = symbol.range.start.character + 1,
          kind = kind,
          text = '['..kind..'] '..symbol.name
        })
        if symbol.children then
          for _, v in ipairs(_symbols_to_items(symbol.children, _items, _bufnr)) do
            vim.list_extend(_items, v)
          end
        end
      end
      ::continue::
    end
    return _items
  end
  return _symbols_to_items(symbols, {}, bufnr)
end


local symbol_callback = function(_, _, result, _, bufnr)
  if not result or vim.tbl_isempty(result) then return end

  util.set_qflist(symbols_to_items(result, bufnr))
  api.nvim_command("FzfPreviewQuickFix")
end

M['textDocument/references'] = function(_, _, result)
  if not result then return end
  util.set_qflist(util.locations_to_items(result))
  api.nvim_command("FzfPreviewQuickFix")
end
M['textDocument/declaration'] = location_callback
M['textDocument/definition'] = location_callback
M['textDocument/typeDefinition'] = location_callback
M['textDocument/implementation'] = location_callback
vim.lsp.callbacks['textDocument/documentSymbol'] = symbol_callback

return M
