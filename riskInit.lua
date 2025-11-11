-----------------------------------------------------------
-- Neovim config for Star64 / RISC-V (no LuaJIT required)
-- Uses packer.nvim and Lua 5.1 only
-----------------------------------------------------------

-------------------------
-- Bootstrap packer.nvim
-------------------------
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

local ok_packer, packer = pcall(require, "packer")
if not ok_packer then
  return
end

packer.init({
  display = { non_interactive = true },
})

-------------------------
-- Plugins
-------------------------
packer.startup(function(use)
  use "wbthomason/packer.nvim"

  -- File tree / statusline / git
  use "preservim/nerdtree"
  use "vim-airline/vim-airline"
  use "tpope/vim-fugitive"

  -- Telescope (no LuaJIT / no ffi)
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local ok, telescope = pcall(require, "telescope")
      if not ok then return end

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

      -- Optional: fzy-native (pure C, no LuaJIT/ffi requirement)
      local has_fzy, _ = pcall(require, "telescope._extensions.fzy_native")
      if has_fzy then
        pcall(telescope.load_extension, "fzy_native")
      end
    end,
  }

  -- Optional: fast sorter that works without LuaJIT
  use {
    "nvim-telescope/telescope-fzy-native.nvim",
    run = "make",
  }

  -- ToggleTerm floating terminal
  use {
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      local ok, toggleterm = pcall(require, "toggleterm")
      if not ok then return end

      toggleterm.setup({
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
      vim.api.nvim_set_keymap(
        "n",
        "<C-S-t>",
        "<cmd>ToggleTerm direction=float 2<CR>",
        { noremap = true, silent = true }
      )
    end,
  }

  -- Themes
  use "jonathanfilip/vim-lucius"
  use { "catppuccin/nvim", as = "catppuccin" }
  use {
    "EdenEast/nightfox.nvim",
    config = function()
      -- Set carbonfox here so it's only called once plugin is loaded
      vim.cmd("colorscheme carbonfox")
    end,
  }

  -- Colors / appearance helpers
  use "norcalli/nvim-colorizer.lua"

  -- Markdown plugins
  use { "plasticboy/vim-markdown", ft = { "markdown" } }
  use { "preservim/vim-pencil", ft = { "markdown" } }
  use { "godlygeek/tabular", ft = { "markdown" } }

  -- Completion (pure Lua)
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local ok, cmp = pcall(require, "cmp")
      if not ok then return end

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

-------------------------
-- Post-plugin config
-------------------------

-- Safe colorizer init
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

vim.g.mapleader = " "
vim.o.guifont = "Monaco:h12"

-- Transparent background for all colorschemes
vim.cmd([[
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
]])

-- Window separator style
vim.cmd([[
  highlight WinSeparator guifg=#3b3b3b guibg=None
]])

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
vim.api.nvim_set_keymap(
  "n",
  "<C-q>",
  ":Telescope find_files<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>f>",
  ":Telescope live_grep<CR>",
  { noremap = true, silent = true }
)

-- Select all text
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Select current block
vim.api.nvim_set_keymap("n", "<C-a><C-a>", "vip", { noremap = true, silent = true })

-- Simple test mapping for leader
vim.api.nvim_set_keymap(
  "n",
  "<leader>x",
  ":echo 'Leader key works!'<CR>",
  { noremap = true, silent = true }
)