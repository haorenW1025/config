" Automatically generated packer.nvim plugin loader code

lua << END
local plugins = {
  ["completion-buffers"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/completion-buffers"
  },
  ["completion-nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/completion-nvim"
  },
  ["completion-tabnine"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/completion-tabnine"
  },
  ["completion-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/completion-treesitter"
  },
  ["diagnostic-nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/diagnostic-nvim"
  },
  ["expressline.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/expressline.nvim"
  },
  ["fzf-preview.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/fzf-preview.vim"
  },
  ["gina.vim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/gina.vim"
  },
  ["luvjob.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/luvjob.nvim"
  },
  ["nvim-ipy"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/nvim-ipy"
  },
  ["nvim-lsp"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/nvim-lsp"
  },
  ["nvim-treesitter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/nvim-treesitter"
  },
  ["packer.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/plenary.nvim"
  },
  ultisnips = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/ultisnips"
  },
  ["vim-gitgutter"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-gitgutter"
  },
  ["vim-smoothie"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-smoothie"
  },
  ["vim-startify"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-startify"
  },
  ["vim-vsnip"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-vsnip"
  },
  ["vim-vsnip-integ"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-vsnip-integ"
  },
  ["vim-wiki"] = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vim-wiki"
  },
  vimtex = {
    loaded = false,
    only_sequence = false,
    only_setup = false,
    path = "/home/whz861025/.local/share/nvim/site/pack/packer/opt/vimtex"
  }
}

local function handle_bufread(names)
  for _, name in ipairs(names) do
    local path = plugins[name].path
    for _, dir in ipairs({ 'ftdetect', 'ftplugin', 'after/ftdetect', 'after/ftplugin' }) do
      if #vim.fn.finddir(dir, path) > 0 then
        vim.api.nvim_command('doautocmd BufRead')
        return
      end
    end
  end
end

_packer_load = nil

local function handle_after(name, before)
  local plugin = plugins[name]
  plugin.load_after[before] = nil
  if next(plugin.load_after) == nil then
    _packer_load({name}, {})
  end
end

_packer_load = function(names, cause)
  local some_unloaded = false
  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      some_unloaded = true
      break
    end
  end

  if not some_unloaded then return end

  local fmt = string.format
  local del_cmds = {}
  local del_maps = {}
  for _, name in ipairs(names) do
    if plugins[name].commands then
      for _, cmd in ipairs(plugins[name].commands) do
        del_cmds[cmd] = true
      end
    end

    if plugins[name].keys then
      for _, key in ipairs(plugins[name].keys) do
        del_maps[key] = true
      end
    end
  end

  for cmd, _ in pairs(del_cmds) do
    vim.api.nvim_command('silent! delcommand ' .. cmd)
  end

  for key, _ in pairs(del_maps) do
    vim.api.nvim_command(fmt('silent! %sunmap %s', key[1], key[2]))
  end

  for _, name in ipairs(names) do
    if not plugins[name].loaded then
      vim.api.nvim_command('packadd ' .. name)
      if plugins[name].config then
        for _i, config_line in ipairs(plugins[name].config) do
          loadstring(config_line)()
        end
      end

      if plugins[name].after then
        for _, after_name in ipairs(plugins[name].after) do
          handle_after(after_name, name)
          vim.api.nvim_command('redraw')
        end
      end

      plugins[name].loaded = true
    end
  end

  handle_bufread(names)

  if cause.cmd then
    local lines = cause.l1 == cause.l2 and '' or (cause.l1 .. ',' .. cause.l2)
    vim.api.nvim_command(fmt('%s%s%s %s', lines, cause.cmd, cause.bang, cause.args))
  elseif cause.keys then
    local keys = cause.keys
    local extra = ''
    while true do
      local c = vim.fn.getchar(0)
      if c == 0 then break end
      extra = extra .. vim.fn.nr2char(c)
    end

    if cause.prefix then
      local prefix = vim.v.count and vim.v.count or ''
      prefix = prefix .. '"' .. vim.v.register .. cause.prefix
      if vim.fn.mode('full') == 'no' then
        if vim.v.operator == 'c' then
          prefix = '' .. prefix
        end

        prefix = prefix .. vim.v.operator
      end

      vim.fn.feedkeys(prefix, 'n')
    end

    -- NOTE: I'm not sure if the below substitution is correct; it might correspond to the literal
    -- characters \<Plug> rather than the special <Plug> key.
    vim.fn.feedkeys(string.gsub(cause.keys, '^<Plug>', '\\<Plug>') .. extra)
  elseif cause.event then
    vim.api.nvim_command(fmt('doautocmd <nomodeline> %s', cause.event))
  elseif cause.ft then
    vim.api.nvim_command(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeplugin', cause.ft))
    vim.api.nvim_command(fmt('doautocmd <nomodeline> %s FileType %s', 'filetypeindent', cause.ft))
  end
end

-- Pre-load configuration
-- Post-load configuration
-- Conditional loads
END

function! s:load(names, cause) abort
  call luaeval('_packer_load(_A[1], _A[2])', [a:names, a:cause])
endfunction

" Load plugins in order defined by `after`

" Command lazy-loads

" Keymap lazy-loads

augroup packer_load_aucmds
  au!
  " Filetype lazy-loads
  " Event lazy-loads
augroup END

" Runtimepath customization
