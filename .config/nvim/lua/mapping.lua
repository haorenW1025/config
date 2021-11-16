-- This came from https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/lsp_config.lua
local mapper = function(mode, key, result)
  vim.api.nvim_set_keymap(mode, key, result, {noremap=true, silent=true})
end

mapper('n', ',p', '<cmd>lua require"util".syntax_at_point()<CR>')
mapper('n', ',f', '<cmd>lua require(\'fzf-lua\').files()<CR>')
mapper('n', ',g', '<cmd>lua require(\'fzf-lua\').git_files()<CR>')
mapper('n', ',b', '<cmd>lua require(\'fzf-lua\').buffers()<CR>')
mapper('n', ',m', '<cmd>lua require(\'fzf-lua\').oldfiles()<CR>')
mapper('n', ',ww', '<cmd>lua require(\'fzf-lua\').grep()<CR>')
mapper('n', ',wi', '<cmd>lua require(\'fzf-lua\').live_grep()<CR>')
mapper('n', ',wc', '<cmd>lua require(\'fzf-lua\').grep_cword()<CR>')
mapper('n', ',wl', '<cmd>lua require(\'fzf-lua\').grep_last()<CR>')
mapper('n', ',wb', '<cmd>lua require(\'fzf-lua\').grep_curbuf()<CR>')
mapper('n', ',k', '<cmd>lua require(\'fzf-lua\').keymaps()<CR>')

vim.api.nvim_set_keymap("i", "<c-f>", "<Plug>luasnip-expand-or-jump", {})
vim.api.nvim_set_keymap("s", "<c-f>", "<Plug>luasnip-expand-or-jump", {})
vim.api.nvim_set_keymap("i", "<c-b>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("s", "<c-b>", "<Plug>luasnip-jump-prev", {})
vim.api.nvim_set_keymap("i", "<c-n>", "<Plug>luasnip-next-choice", {})
vim.api.nvim_set_keymap("s", "<c-n>", "<Plug>luasnip-next-choice", {})


local actions = require "fzf-lua.actions"
require'fzf-lua'.setup {
  winopts = {
    -- split         = "belowright new",-- open in a split instead?
                                        -- "belowright new"  : split below
                                        -- "aboveleft new"   : split above
                                        -- "belowright vnew" : split right
                                        -- "aboveleft vnew   : split left
    -- Only valid when using a float window
    -- (i.e. when 'split' is not defined)
    win_height       = 0.85,            -- window height
    win_width        = 0.80,            -- window width
    win_row          = 0.30,            -- window row position (0=top, 1=bottom)
    win_col          = 0.50,            -- window col position (0=left, 1=right)
    -- win_border    = false,           -- window border? or borderchars?
    win_border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
    hl_normal        = 'Normal',        -- window normal color
    hl_border        = 'Normal',        -- change to 'FloatBorder' if exists
    fullscreen       = false,           -- start fullscreen?
  },
  files = {
    -- previewer         = "cat",       -- uncomment to override previewer
    prompt            = 'Files❯ ',
    cmd               = 'fd . -t f',             -- "find . -type f -printf '%P\n'",
    git_icons         = true,           -- show git icons?
    file_icons        = true,           -- show file icons?
    color_icons       = true,           -- colorize file|git icons
    actions = {
      -- set bind to 'false' to disable
      ["default"]     = actions.file_edit,
      ["ctrl-s"]      = actions.file_split,
      ["ctrl-v"]      = actions.file_vsplit,
      ["ctrl-t"]      = actions.file_tabedit,
      ["alt-q"]       = actions.file_sel_to_qf,
      -- custom actions are available too
      ["ctrl-y"]      = function(selected) print(selected[1]) end,
    }
  },
  keymap = {
    -- These override the default tables completely
    -- no need to set to `false` to disable a bind
    -- delete or modify is sufficient
    builtin = {
      -- neovim `:tmap` mappings for the fzf win
      ["<F2>"]        = "toggle-fullscreen",
      -- Only valid with the 'builtin' previewer
      ["<F3>"]        = "toggle-preview-wrap",
      ["<F4>"]        = "toggle-preview",
      -- Rotate preview clockwise/counter-clockwise
      ["<F5>"]        = "toggle-preview-ccw",
      ["<F6>"]        = "toggle-preview-cw",
      ["<S-down>"]    = "preview-page-down",
      ["<S-up>"]      = "preview-page-up",
      ["<S-left>"]    = "preview-page-reset",
    },
    fzf = {
      -- fzf '--bind=' options
      ["ctrl-z"]      = "unix-line-discard",
      ["ctrl-f"]      = "half-page-down",
      ["ctrl-b"]      = "half-page-up",
      ["ctrl-a"]      = "beginning-of-line",
      ["ctrl-e"]      = "end-of-line",
      ["alt-a"]       = "toggle-all",
      -- Only valid with fzf previewers (bat/cat/git/etc)
      ["f3"]          = "toggle-preview-wrap",
      ["f4"]          = "toggle-preview",
      ["shift-down"]      = "preview-page-down",
      ["shift-up"]      = "preview-page-up",
    },
  },
  preview_border      = 'border',       -- border|noborder
  preview_wrap        = 'nowrap',       -- wrap|nowrap
  preview_opts        = 'nohidden',     -- hidden|nohidden
  preview_vertical    = 'down:75%',     -- up|down:size
  preview_horizontal  = 'right:60%',    -- right|left:size
  preview_layout      = 'vertical',         -- horizontal|vertical|flex
  flip_columns        = 120,            -- #cols to switch to horizontal on flex
  -- default_previewer   = "bat",       -- override the default previewer?
}

local function copy_to_clipboard(files)
	files = table.concat(files, "\n")
	vim.fn.setreg("+", files)
	print(files:gsub("\n", ", ") .. " copied to register")
end

local function cd_to_path(files)
	local dir = files[1]:match(".*/")
	local read = io.open(dir, "r")
	if read ~= nil then
		io.close(read)
		vim.fn.execute("cd "..dir)
		print("working directory changed to: " .. dir)
	end
end
