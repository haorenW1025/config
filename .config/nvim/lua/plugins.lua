local packer = nil
local function init()
  if packer == nil then
    packer = require('packer')
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer
  use {'~/projects/personal/packer.nvim', opt = true}

  -- Colors
  use {'arcticicestudio/nord-vim', opt = false }
  use {'luochen1990/rainbow', opt = false }

  -- Tpope plugins
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'tpope/vim-scriptease'
  -- use 'tpope/vim-projectionist'

  use {'mhinz/vim-startify', opt = true}
  use {'airblade/vim-gitgutter', opt = true}
  use {'lervag/vimtex', opt = true}

  -- snippet
  use {'SirVer/ultisnips', opt = true}
  use {'haorenW1025/vim-snippets'}

  -- paring
  use {'Raimondi/delimitMate', opt = false}

  -- Movement
  use 'chaoren/vim-wordmotion'

  -- Indentation tracking
  use {'yggdroot/indentLine', opt = true}

  -- Prettification
  use 'junegunn/vim-easy-align'

  -- Search
  use {'junegunn/fzf', run = './install --all && ln -s $(pwd) ~/.fzf'}
  use {'junegunn/fzf.vim', opt = true}

  -- Completion and linting
  use {'neovim/nvim-lsp', opt = true}
  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }

  -- extra sources
  use {'steelsojka/completion-buffers', opt = true}
  use {'aca/completion-tabnine', opt = true}

  -- treesitter
  use {'nvim-treesitter/completion-treesitter', opt = true}
  use {'nvim-treesitter/nvim-treesitter', opt = true}

  use {'haorenW1025/diagnostic-nvim', opt = true}

  -- Highlight colors
  use 'norcalli/nvim-colorizer.lua'

  -- smooth scrolling
  use {'psliwka/vim-smoothie', opt = true}

  -- gina
  use {'lambdalisue/gina.vim', opt = true}

  -- movement
  use {'justinmk/vim-sneak'}

  -- ipython integration
  use {'bfredl/nvim-ipy', opt = true}

  -- utility
  use {'nvim-lua/plenary.nvim', opt = true}

  -- statusline
  use {'tjdevries/luvjob.nvim', opt = true}
  use {'tjdevries/expressline.nvim', opt = true}

  -- my plugins
  use {'haorenW1025/term-nvim'}
  use {'haorenW1025/floatLf-nvim'}

  -- wiki
  use {'vim-pandoc/vim-pandoc-syntax'}
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
