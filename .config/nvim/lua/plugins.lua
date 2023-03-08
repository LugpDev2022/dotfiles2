local status, packer = pcall(require, 'packer')
if (not status) then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'neovim/nvim-lspconfig' -- LSP

  -- Autocompletion
  use 'onsails/lspkind-nvim'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  -- Syntax highlighters
  use 'wuelnerdotexe/vim-astro'

  -- Snippets
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'

  use { 'akinsho/bufferline.nvim', tag = "v3.*" } -- Bufferline

  use 'nvim-tree/nvim-web-devicons' -- Icons

  use { "catppuccin/nvim", as = "catppuccin" } -- Colorscheme
  use 'nvim-lualine/lualine.nvim' -- Lualine


  -- Autopair
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  -- Telescope
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { { 'nvim-lua/plenary.nvim' } }
  }
  use { "nvim-telescope/telescope-file-browser.nvim" }

  use 'norcalli/nvim-colorizer.lua' -- Colorizer
  use 'mattn/emmet-vim' -- Emmet

  -- Prettier
  use 'MunifTanjim/prettier.nvim'
  use 'jose-elias-alvarez/null-ls.nvim'

  use 'easymotion/vim-easymotion' -- Easymotion
end)
