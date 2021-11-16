local api = vim.api
local status = require'lsp_status'
local vcs = require'vcs'
local icons = require 'devicon'
local M = {}

-- Different colors for mode
local purple = '#B48EAD'
local blue = '#8BE9FD'
local yellow = '#FFFFA5'
local green = '#69FF94'
local red = '#FF6E6E'
local orange = '#D08770'

-- fg and be
local white_fg = '#e6e6e6'
local black_fg = '#282c34'
local bg = '#4C566A'

-- Separators
local left_separator = ''
-- local left_separator = ''
local right_separator = ''
-- local right_separator = ''

-- Blank Between Components
local blank = ' '

------------------------------------------------------------------------
--                             StatusLine                             --
------------------------------------------------------------------------

-- Mode Prompt Table
local current_mode = setmetatable({
      ['n'] = 'NORMAL',
      ['no'] = 'N·Operator Pending',
      ['v'] = 'VISUAL',
      ['V'] = 'V·Line',
      ['^V'] = 'V·Block',
      ['s'] = 'Select',
      ['S'] = 'S·Line',
      ['^S'] = 'S·Block',
      ['i'] = 'INSERT',
      ['ic'] = 'INSERT',
      ['ix'] = 'INSERT',
      ['R'] = 'Replace',
      ['Rv'] = 'V·Replace',
      ['c'] = 'COMMAND',
      ['cv'] = 'Vim Ex',
      ['ce'] = 'Ex',
      ['r'] = 'Prompt',
      ['rm'] = 'More',
      ['r?'] = 'Confirm',
      ['!'] = 'Shell',
      ['t'] = 'TERMINAL'
    }, {
      -- fix weird issues
      __index = function(_, _)
        return 'V·Block'
      end
    }
)

-- Filename Color
local file_bg = purple
local file_fg = black_fg
local file_gui = 'bold'
api.nvim_command('hi File guibg='..file_bg..' guifg='..file_fg..' gui='..file_gui)
api.nvim_command('hi FileSeparator guifg='..file_bg)

-- Working directory Color
local dir_bg = black_fg
local dir_fg = white_fg
local dir_gui = 'bold'
api.nvim_command('hi Directory guibg='..dir_bg..' guifg='..dir_fg..' gui='..dir_gui)
api.nvim_command('hi DirSeparator guifg='..dir_bg)

-- FileType Color
local filetype_bg = blue
local filetype_fg = black_fg
local filetype_gui = 'italic'
api.nvim_command('hi Filetype guibg='..filetype_bg..' guifg='..filetype_fg..' gui='..filetype_gui)

local error_status_bg = '#4c566a'
local error_status_fg = white_fg
api.nvim_command('hi error_status guibg='..error_status_bg..' guifg='..error_status_fg)

local branch_bg = '#4c566a'
local branch_fg = orange
local branch_gui = 'italic'
api.nvim_command('hi branch guibg='..branch_bg..' guifg='..branch_fg..' gui='..branch_gui)

local warning_status_bg = '#4c566a'
local warning_status_fg = white_fg
api.nvim_command('hi warning_status guibg='..warning_status_bg..' guifg='..warning_status_fg)

local process_bg = '#4c566a'
local process_fg = blue
api.nvim_command('hi process guibg='..process_bg..' guifg='..process_fg)

local function_status_bg = '#4c566a'
local function_status_fg = purple
local function_status_gui = 'italic'
api.nvim_command('hi function_status guibg='..function_status_bg..' guifg='..function_status_fg..' gui='..function_status_gui)

-- row and column Color
local line_bg = white_fg
local line_fg = black_fg
local line_gui = 'italic'
api.nvim_command('hi Line guibg='..line_bg..' guifg='..line_fg..' gui='..line_gui)



-- Redraw different colors for different mode
local RedrawColors = function(mode)
  if mode == 'n' then
    api.nvim_command('hi Mode guibg='..green..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi ModeSeparator guifg='..green)
  end
  if mode == 'i' then
    api.nvim_command('hi Mode guibg='..blue..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi ModeSeparator guifg='..blue)
  end
  if mode == 'v' or mode == 'V' or mode == '^V' then
    api.nvim_command('hi Mode guibg='..purple..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi ModeSeparator guifg='..purple)
  end
  if mode == 'c' then
    api.nvim_command('hi Mode guibg='..yellow..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi ModeSeparator guifg='..yellow)
  end
  if mode == 't' then
    api.nvim_command('hi Mode guibg='..red..' guifg='..black_fg..' gui=bold')
    api.nvim_command('hi ModeSeparator guifg='..red)
  end
end

local TrimmedDirectory = function(dir)
  local home = os.getenv("HOME")
  local _, index = string.find(dir, home, 1)
  if index ~= nil and index ~= string.len(dir) then
    -- TODO Trimmed Home Directory
    return string.gsub(dir, home, '~')
  end
  return dir
end

function M.activeLine()
  local statusline = ""
  -- Component: Mode
  local mode = api.nvim_get_mode()['mode']
  RedrawColors(mode)
  statusline = statusline.."%#ModeSeparator#"..left_separator.."%#Mode# "..current_mode[mode].." %#ModeSeparator#"..right_separator
  -- statusline = statusline..blank
  statusline = statusline.."%#process# "
  statusline = statusline.."%r%m "
  local branch_name = vcs.get_git_branch()
  if branch_name ~= nil then
    statusline = statusline.."%#branch# "..branch_name
  end

  local error_count = vim.lsp.diagnostic.get_count(0, [[Error]])
  local warning_count = vim.lsp.diagnostic.get_count(0, [[Warning]])
  if mode == 'i' or mode == 'ic' or mode == 'ix' then
    error_count = 0
    warning_count = 0
  end
  if error_count ~= 0 then
  statusline = statusline.."%#error_status# "
    statusline = statusline.." "..error_count.." "
  end
  if warning_count ~= 0 then
  statusline = statusline.."%#warning_status# "
    statusline = statusline.."⚠️ "..warning_count.." "
  end
  statusline = statusline.."%#process# "
  local stats = status.status()
  if type(stats) == "table" then
    for _,stat in pairs(stats) do
      if stat ~= nil then
        statusline = statusline..stat
      end
    end
  end
  -- if stats ~= nil then
  -- end
  statusline = statusline.."%#StatusLine#"
  -- local branch = api.nvim_call_function("gina#component#repo#branch", {})
  -- if #branch ~= 0 then
  --   statusline = statusline.."%#Function#  "..branch
  -- end


  -- Alignment to left
  statusline = statusline.."%="

  local lsp_function = vim.b.lsp_current_function
  if lsp_function ~= nil then
    statusline = statusline.."%#function_status# "..lsp_function.." "
  end

  local filetype = api.nvim_buf_get_option(0, 'filetype')
  statusline = statusline.."%#Filetype# Filetype: "..filetype
  statusline = statusline..blank

  -- Component: FileType
  -- Component: row and col
  local line = api.nvim_call_function('line', {"."})
  local col = vim.fn.col('.')
  while string.len(line) < 3 do
    line = line..' '
  end
  while string.len(col) < 3 do
    col = col..' '
  end
  statusline = statusline.."%#Line# ℓ "..line.." 𝚌 "..col

  return statusline
end

local InactiveLine_bg = bg
local InactiveLine_fg = white_fg
api.nvim_command('hi InActive guibg='..InactiveLine_bg..' guifg='..InactiveLine_fg)

function M.inActiveLine()
  local file_name = api.nvim_call_function('expand', {'%F'})
  return "%#InActive# "..file_name
end

------------------------------------------------------------------------
--                              TabLine                               --
------------------------------------------------------------------------

local getTabLabel = function(n)
  local current_win = api.nvim_tabpage_get_win(n)
  local current_buf = api.nvim_win_get_buf(current_win)
  local file_name = api.nvim_buf_get_name(current_buf)
  if string.find(file_name, 'term://') ~= nil then
    return ' '..api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
  end
  file_name = api.nvim_call_function('fnamemodify', {file_name, ":p:t"})
  if file_name == '' then
    return "No Name"
  end
  local icon = icons.deviconTable[file_name]
  if icon ~= nil then
    return icon..' '..file_name
  end
  return file_name
end


function M.TabLine()
  local tabline = ''
  local tab_list = api.nvim_list_tabpages()
  local current_tab = api.nvim_get_current_tabpage()
  for _, val in ipairs(tab_list) do
    local file_name = getTabLabel(val)
    if val == current_tab then
      tabline = tabline.."%#TabLineSelSeparator#"..left_separator
      tabline = tabline.."%#TabLineSel# "..file_name
      tabline = tabline.." %#TabLineSelSeparator#"..right_separator
    else
      tabline = tabline.."%#TabLineSeparator#"..left_separator
      tabline = tabline.."%#TabLine# "..file_name
      tabline = tabline.." %#TabLineSeparator#"..right_separator
    end
  end
  tabline = tabline.."%#TabLineFill#"
  tabline = tabline.."%="
  -- Component: Working Directory
  local dir = api.nvim_call_function('getcwd', {})
  tabline = tabline.."%#DirSeparator#"..left_separator.."%#Directory# "..TrimmedDirectory(dir).." %#DirSeparator#"..right_separator
  return tabline
end
return M


