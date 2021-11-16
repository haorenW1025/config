local M = {}
local util = require 'vim.lsp.util'
local validate = vim.validate

local function request(method, params, handler)
  validate {
    method = {method, 's'};
    handler = {handler, 'f', true};
  }
  return vim.lsp.buf_request(0, method, params, handler)
end

local function pick_call_hierarchy_item(call_hierarchy_items)
  if not call_hierarchy_items then return end
  print(vim.inspect(call_hierarchy_items))
  if #call_hierarchy_items == 1 then
    return call_hierarchy_items[1]
  end
  local items = {}
  for i, item in ipairs(call_hierarchy_items) do
    local entry = item.detail or item.name
    table.insert(items, string.format("%d. %s", i, entry))
  end
  local choice = vim.fn.inputlist(items)
  if choice < 1 or choice > #items then
    return
  end
  return choice
end

function M.incoming_calls()
  local params = util.make_position_params()
  request('textDocument/prepareCallHierarchy', params, function(_, _, result)
    local call_hierarchy_item = pick_call_hierarchy_item(result)
    vim.lsp.buf_request(0, 'callHierarchy/incomingCalls', { item = call_hierarchy_item })
  end)
end

return M
