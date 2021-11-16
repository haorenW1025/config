local M = {}

--- Check if a file or directory exists in this path
function M.exists(file)
  local ok, err, code = os.rename(file, file)
  if not ok then
    if code == 13 then
      -- Permission denied, but it exists
      return true
    end
  end
  return ok, err
end

--- Check if a directory exists in this path
function M.is_dir(path)
  -- "/" works on both Unix and Windows
  return M.exists(path.."/")
end

function M.has_value (tab, val)
  for _, value in ipairs(tab) do
    if value == val then
      return true
    end
  end
  return false
end


function M.syntax_at_point()
    if vim.g.loaded_nvim_treesitter and vim.g.loaded_nvim_treesitter > 0 then
        local current_node = require('nvim-treesitter/ts_utils').get_node_at_cursor()
        if current_node then
            print(current_node:type())
            return
        end
    end
    -- fallback
    local pos = vim.api.nvim_win_get_cursor(0)
    print(vim.fn.synIDattr(vim.fn.synID(pos[1], pos[2], 1), "name"))
end

return M
