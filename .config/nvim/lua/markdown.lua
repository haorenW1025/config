local M = {}
local loop = vim.loop
local api = vim.api

function M.convertFile()
  local shortname = vim.fn.expand('%:t:r')
  local fullname = api.nvim_buf_get_name(0)
  handle = vim.loop.spawn('pandoc', {
    args = {fullname, '--to=pdf', '-o', string.format('%s.pdf', shortname), '-s', '--pdf-engine=xelatex', '--template', 'eisvogel', '--listings', '--toc', '--number-sections'}
  },
  function()
    print('DOCUMENT CONVERSION COMPLETE')
    handle:close()
  end
  )
end

function M.followLink()
  local dir = api.nvim_call_function('expand', {'%:p:h'})
  local line = api.nvim_get_current_line()
  if line:match("^.*%[.*%]%(.*%)") then
    local link = line:match("%(.*%)")
    link = link:sub(2, #link-1)
    link = dir..'/'..link
    print(link)
    api.nvim_command("e "..link)
  end
end

return M
