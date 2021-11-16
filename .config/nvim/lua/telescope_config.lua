local builtin = require("telescope.builtin")
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')
local conf = require('telescope.config').values
local M = {}

local my_theme_opts = {
  theme = "dropdown",

  sorting_strategy = "ascending",
  layout_strategy = "center",
  results_title = false,
  preview_title = "Preview",
  -- preview_cutoff = 1, -- Preview should always show (unless previewer = false)
  -- width = 120,
  -- results_height = 20,
  winblend = 10,
  borderchars = {
    { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
    results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
    preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
  },
}

M.themes = require('telescope.themes').get_dropdown(my_theme_opts)

local filter = function (list, test)
  local result = {}
  for i, v in ipairs(list) do
    if test(i, v) then
      table.insert(result, v)
    end
  end
  return result
end

-- my own document symbols
M.document_symbols = function(opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params()
  local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params, opts.timeout or 10000)

  if not results_lsp or vim.tbl_isempty(results_lsp) then
    print("No results from textDocument/documentSymbol")
    return
  end

  local locations = {}
  for _, server_results in pairs(results_lsp) do
    vim.list_extend(locations, vim.lsp.util.symbols_to_items(server_results.result, 0) or {})
  end

  if vim.tbl_isempty(locations) then
    return
  end

  locations = filter(locations,
    function(_, v)
      return v.kind == 'Class' or v.kind == 'Function' or v.kind == 'Method'
    end)

  pickers.new(opts, {
    prompt_title = 'LSP Document Symbols',
    finder    = finders.new_table {
      results = locations,
      entry_maker = make_entry.gen_from_quickfix(opts)
    },
    previewer = conf.qflist_previewer(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

M.workspace_symbols = function(opts)
  opts = opts or {}
  opts.shorten_path = utils.get_default(opts.shorten_path, true)

  local params = {query = opts.query or ''}
  local results_lsp = vim.lsp.buf_request_sync(0, "workspace/symbol", params, opts.timeout or 10000)

  if not results_lsp or vim.tbl_isempty(results_lsp) then
    print("No results from workspace/symbol")
    return
  end

  local locations = {}
  for _, server_results in pairs(results_lsp) do
    if server_results.result then
      vim.list_extend(locations, vim.lsp.util.symbols_to_items(server_results.result, 0) or {})
    end
  end

  if vim.tbl_isempty(locations) then
    return
  end

  locations = filter(locations,
    function(_, v)
      return v.kind == 'Class' or v.kind == 'Function' or v.kind == 'Method'
    end)

  pickers.new(opts, {
    prompt_title = 'LSP Workspace Symbols',
    finder    = finders.new_table {
      results = locations,
      entry_maker = make_entry.gen_from_quickfix(opts)
    },
    previewer = previewers.qflist.new(opts),
    sorter = conf.generic_sorter(opts),
  }):find()
end

return M
