local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local utils = require('telescope.utils')

local rgargs = {'--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'}

-- fuzzy find files in current directory (may be slow in root dir)
finders.fd = function(opts)
  opts = opts or {}

  opts.entry_maker = opts.entry_maker or make_entry.gen_from_file(opts)
  if opts.cwd then
    opts.cwd = vim.fn.expand(opts.cwd)
  end

  pickers.new(opts, {
    prompt = 'Find Files',
    finder    = finders.new_oneshot_job(
      { "fd", "-t", "file", "-H", "-E", ".git" },
      opts
    ),
    previewer = previewers.cat.new(opts),
    sorter = sorters.get_fuzzy_file(),
  }):find()
end

-- fuzzy find in references to symbol under cursor
finders.lsp_references = function(opts)
  local params = vim.lsp.util.make_position_params()
  params.context = { includeDeclaration = false }

  local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/references", params)
  local locations = {}
  for _, server_results in pairs(results_lsp) do
    vim.list_extend(locations, vim.lsp.util.locations_to_items(server_results.result) or {})
  end

  local results = utils.quickfix_items_to_entries(locations)

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt    = 'LSP References',
    finder    = finders.new_table(results),
    previewer = previewers.qflist,
    sorter    = sorters.get_norcalli_sorter(),
  }):find()
end

-- fuzzy find in document symbols
finders.lsp_document_symbols = function(opts)
  local params = vim.lsp.util.make_position_params()
  local results_lsp = vim.lsp.buf_request_sync(0, "textDocument/documentSymbol", params)
  local locations = {}
  for _, server_results in pairs(results_lsp) do
    vim.list_extend(locations, vim.lsp.util.symbols_to_items(server_results.result, 0) or {})
  end

  local results = utils.quickfix_items_to_entries(locations)

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt    = 'LSP Document Symbols',
    finder    = finders.new_table(results),
    previewer = previewers.qflist,
    sorter    = sorters.get_norcalli_sorter(),
  }):find()
end

-- fuzzy find in all workspace symbols (may need longer timeout!)
finders.lsp_workspace_symbols = function(opts)
  local params = {query = ''}
  local results_lsp = vim.lsp.buf_request_sync(0, "workspace/symbol", params, 1000)
  local locations = {}
  for _, server_results in pairs(results_lsp) do
    vim.list_extend(locations, vim.lsp.util.symbols_to_items(server_results.result, 0) or {})
  end

  local results = utils.quickfix_items_to_entries(locations)

  if vim.tbl_isempty(results) then
    return
  end

  pickers.new(opts, {
    prompt    = 'LSP Workspace Symbols',
    finder    = finders.new_table(results),
    previewer = previewers.qflist,
    sorter    = sorters.get_norcalli_sorter(),
  }):find()
end


return finders
