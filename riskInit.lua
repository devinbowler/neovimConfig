-- Bootstrap packer.nvim (works without LuaJIT, good for RISC-V)
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  vim.cmd("packadd packer.nvim")
end

require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  -- File tree / git / statusline
  use "preservim/nerdtree"
  use "vim-airline/vim-airline"
  use "tpope/vim-fugitive"

  -- Telescope + fzf native
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-j>"] = actions.move_selection_next,
            },
          },
        },
      })

      telescope.load_extension("fzf")
    end,
  }

  -- ToggleTerm
  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        direction = "float",
        float_opts = {
          border = "curved",
          width = 100,
          height = 30,
          winblend = 3,
        },
        hide_numbers = true,
        start_in_insert = true,
        persist_size = true,
        close_on_exit = true,
      })
      vim.api.nvim_set_keymap(
        "n",
        "<C-t>",
        "<cmd>ToggleTerm direction=float<CR>",
        { noremap = true, silent = true }
      )
    end,
  }

  -- Themes / appearance
  use "jonathanfilip/vim-lucius"
  use { "catppuccin/nvim", as = "catppuccin" }
  use {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd("colorscheme carbonfox")
    end,
  }
  use "norcalli/nvim-colorizer.lua"

  -- Markdown
  use { "plasticboy/vim-markdown", ft = { "markdown" } }
  use { "preservim/vim-pencil", ft = { "markdown" } }
  use { "godlygeek/tabular", ft = { "markdown" } }

  -- Completion
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        },
      })
    end,
  }
end)

-- === Shared settings and extras ===

-- Colorizer (safe if missing)
pcall(function()
  require("colorizer").setup()
end)

-- General options
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.scrolloff = 0
vim.o.clipboard = "unnamedplus"
vim.o.guifont = "Monaco:h12"
vim.g.mapleader = " "

-- Markdown settings
vim.cmd([[
  augroup MarkdownSettings
    autocmd!
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd FileType markdown setlocal conceallevel=0
  augroup END
]])

vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_math = 1

-- Transparent background
vim.cmd([[
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
]])

-- Window separator color
vim.cmd([[
  highlight WinSeparator guifg=#3b3b3b guibg=None
]])

-- NERDTree toggle+refresh
vim.api.nvim_set_keymap(
  "n",
  "<C-n>",
  ":call ToggleAndRefreshNERDTree()<CR>",
  { noremap = true, silent = true }
)

vim.cmd([[
function! ToggleAndRefreshNERDTree()
  let l:nerdtree_exists = bufexists("NERD_tree_1")
  if l:nerdtree_exists
    execute "NERDTreeClose"
  else
    execute "NERDTree"
    execute "NERDTreeRefreshRoot"
  endif
endfunction
]])

-- Telescope mappings
vim.api.nvim_set_keymap("n", "<C-q>", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- Select all
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-a><C-a>", "vip", { noremap = true, silent = true })

-- Test leader
vim.api.nvim_set_keymap("n", "<leader>x", ":echo 'Leader key works!'<CR>", { noremap = true, silent = true })