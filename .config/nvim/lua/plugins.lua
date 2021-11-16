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
  use {'TimUntersberger/neogit'}
  use {'lervag/vimtex', opt = true}

  -- paring
  use {'Raimondi/delimitMate', opt = false}

  -- Indentation tracking
  use {'yggdroot/indentLine', opt = true}

  -- Prettification
  use 'junegunn/vim-easy-align'

  -- Completion and linting
  -- use {'SirVer/ultisnips'}
  use {'kkoomen/vim-doge', opt = true}
  use {'neovim/nvim-lsp', opt = true}
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'hrsh7th/cmp-buffer'}
  use {'hrsh7th/cmp-vsnip'}
  use {'hrsh7th/vim-vsnip'}
  use {'saadparwaiz1/cmp_luasnip'}
  use {'L3MON4D3/LuaSnip'}
  use {'onsails/lspkind-nvim'}


  use {
    'haorenW1025/completion-nvim',
    opt = true,
    requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
  }
  use {'tami5/lspsaga.nvim', opt = true}
  use {'folke/lsp-trouble.nvim'}
  -- use {"ray-x/lsp_signature.nvim"}
  use {'simrat39/symbols-outline.nvim'}

  -- treesitter
  use {'nvim-treesitter/nvim-treesitter'}
  use {'nvim-treesitter/nvim-treesitter-textobjects'}
  use {'nvim-treesitter/playground'}

  -- Highlight colors
  use 'norcalli/nvim-colorizer.lua'

  -- movement
  use {'justinmk/vim-sneak'}
  use {'rhysd/clever-f.vim'}

  -- utility
  use {'ibhagwan/fzf-lua'}
  use {'vijaymarupudi/nvim-fzf'}

  use {'nvim-lua/plenary.nvim', opt = true}
  use {'nvim-lua/popup.nvim', opt = true}

  use {'tjdevries/colorbuddy.vim'}

  -- my plugins
  use {'haorenW1025/term-nvim'}
  use {'haorenW1025/floatLf-nvim'}

  use {'vim-pandoc/vim-pandoc-syntax'}

  -- devicons
  use {'kyazdani42/nvim-web-devicons'}
  -- use {'kyazdani42/nvim-tree.lua'}
  -- use {'mcchrish/nnn.vim'}
  use {"mcchrish/nnn.vim"}


  -- use {'glepnir/galaxyline.nvim'}
  use {'nvim-lualine/lualine.nvim'}

  use {'lfv89/vim-interestingwords'}
  use {'akinsho/nvim-bufferline.lua'}
  -- texobject
  use {'kana/vim-textobj-user'}
  use {'Julian/vim-textobj-variable-segment'}
  use 'karb94/neoscroll.nvim'
  use 'bfrg/vim-cpp-modern'
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end
})

return plugins
