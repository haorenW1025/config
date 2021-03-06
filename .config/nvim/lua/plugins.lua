local packer = nil
local function init()
  if packer == nil then
    packer = require('packer')
    packer.init()
  end

  local use = packer.use
  packer.reset()

  -- Packer
  use {'wbthomason/packer.nvim', opt = true}

  -- Colors

  -- Tpope plugins
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'tpope/vim-scriptease'
  -- use 'tpope/vim-projectionist'

  use {'mhinz/vim-startify', opt = true}
  use {'airblade/vim-gitgutter', opt = true}
  use {'lervag/vimtex', opt = true}

  -- paring
  use {'Raimondi/delimitMate', opt = false}

  -- Movement
  use 'chaoren/vim-wordmotion'

  -- Indentation tracking
  use {'yggdroot/indentLine', opt = true}

  -- Prettification
  use 'junegunn/vim-easy-align'

  -- Completion and linting
  use {'SirVer/ultisnips'}
  use {'kkoomen/vim-doge', opt = true}
  use {'neovim/nvim-lsp', opt = true}
  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }
  use {'glepnir/lspsaga.nvim', opt = true}

  -- extra sources
  use {'steelsojka/completion-buffers', opt = true}
  use {'aca/completion-tabnine', opt = true, run = "./install.sh"}

  -- treesitter
  use {'nvim-treesitter/completion-treesitter', opt = true}
  use {'nvim-treesitter/nvim-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}
  use {'nvim-treesitter/playground'}

  -- Highlight colors
  use 'norcalli/nvim-colorizer.lua'

  -- smooth scrolling
  use {'psliwka/vim-smoothie', opt = true}

  -- movement
  use {'justinmk/vim-sneak'}
  use {'rhysd/clever-f.vim'}

  use {'junegunn/goyo.vim', opt = true}
  use {'junegunn/limelight.vim', opt = true}

  -- utility
  use {'nvim-lua/plenary.nvim', opt = true}
  use {'nvim-lua/popup.nvim', opt = true}
  use {'nvim-lua/telescope.nvim', opt = true}

  use {'tjdevries/colorbuddy.vim'}

  -- my plugins
  use {'haorenW1025/term-nvim'}
  use {'haorenW1025/floatLf-nvim'}

  use {'vim-pandoc/vim-pandoc-syntax'}

  -- devicons
  use {'kyazdani42/nvim-web-devicons'}

  -- texobject
  use {'kana/vim-textobj-user'}
  use {'Julian/vim-textobj-variable-segment'}
  use {'jeetsukumaran/vim-indentwise'}
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
