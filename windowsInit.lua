-- Bootstrap lazy.nvim if it's not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Prepend lazy.nvim to the runtimepath
vim.opt.rtp:prepend("C:/Users/devin/.local/share/nvim/lazy/lazy.nvim")

-- Set up plugins using lazy.nvim
require("lazy").setup({
  -- File tree and utility plugins
  {
    "preservim/nerdtree", -- File tree
    lazy = false, -- Load immediately
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim", -- Add this line
    },
    lazy = false,
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = require("telescope.actions").move_selection_previous, -- Move up
              ["<C-j>"] = require("telescope.actions").move_selection_next, -- Move down
            },
          },
        },
      })

      -- Load the fzf extension
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = false,
  },
  {
    "vim-airline/vim-airline", -- Status line
    lazy = false, -- Load immediately
  },
  {
    "tpope/vim-fugitive", -- Git integration
    lazy = false, -- Load immediately
  },
  {
    "akinsho/toggleterm.nvim", -- Floating terminal
    branch = "main",
    lazy = false, -- Load immediately
    opts = {
      size = 20,
      direction = "float",
    },
  },

  -- Themes and appearance
  {
    "jonathanfilip/vim-lucius",
    name = "lucius",
    lazy = false,
  },
  --{
  --  "morhetz/gruvbox",
  --  lazy = false, -- Load immediately
  -- },
  -- New theme plugins
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
  },
  {
    "EdenEast/nightfox.nvim", -- For carbonfox theme
    lazy = false,
  },
  {
    "norcalli/nvim-colorizer.lua", -- For colorizer functionality
    lazy = false,
  },
  
  -- Markdown Plugins
  {
    "plasticboy/vim-markdown", -- Popular Markdown plugin
    lazy = false,
    ft = "markdown", -- Load only for Markdown files
  },
  {
    "preservim/vim-pencil", -- Improves editing for Markdown and text files
    lazy = false,
    ft = "markdown", -- Load only for Markdown files
  },
  {
    "godlygeek/tabular", -- Helps with table formatting in Markdown
    lazy = false,
    ft = "markdown",
  },

  -- Auto-completion
  {
    "hrsh7th/nvim-cmp", -- Completion plugin
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
    },
    lazy = false,
  },
})

-- Set colorscheme to carbonfox
vim.cmd [[colorscheme carbonfox]]

-- Configure transparent background
vim.cmd([[
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
]])

-- Initialize colorizer if available
pcall(function() require('colorizer').setup() end)

-- General Neovim settings
vim.cmd([[set number]])
vim.cmd([[set syntax=on]])

-- Make window separators less bright
vim.cmd [[
  highlight WinSeparator guifg=#3b3b3b guibg=None
]]

vim.g.mapleader = " " -- Set space as leader
vim.api.nvim_set_keymap("n", "<leader>x", ":echo 'Leader key works!'<CR>", { noremap = true, silent = true })

-- Indentation settings
vim.o.tabstop = 2       -- Number of spaces that a <Tab> counts for
vim.o.shiftwidth = 2    -- Number of spaces for auto-indent
vim.o.softtabstop = 2   -- Number of spaces for <Tab> in insert mode
vim.o.expandtab = true  -- Use spaces instead of tabs
vim.o.smarttab = true   -- Makes Tab behavior smarter
vim.o.autoindent = true -- Copy indent from current line
vim.o.smartindent = true -- Auto-indent in programming languages

-- Cursor and Scrolling Behavior
vim.o.scrolloff = 0 -- Prevent cursor movement on scrolling

-- Relative Line Numbers
vim.o.number = true           -- Enable absolute line number for the current line
vim.o.relativenumber = true   -- Enable relative line numbers for all other lines

-- Clipboard settings
vim.o.clipboard = "unnamedplus"

-- GUI font
vim.o.guifont = "Monaco:h24"

-- Markdown Settings
vim.cmd([[
  augroup MarkdownSettings
    autocmd!
    autocmd BufRead,BufNewFile *.md set filetype=markdown
    autocmd FileType markdown setlocal conceallevel=0
  augroup END
]])

-- Configure vim-markdown
vim.g.vim_markdown_folding_disabled = 1 -- Disable folding
vim.g.vim_markdown_conceal = 0         -- Show all symbols (like stars for bold)
vim.g.vim_markdown_math = 1           -- Enable math rendering

-- NERDTree keybinding with refresh functionality
vim.api.nvim_set_keymap("n", "<C-n>", ":call ToggleAndRefreshNERDTree()<CR>", { noremap = true, silent = true })
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

-- Telescope keybindings
vim.api.nvim_set_keymap("n", "<C-q>", ":Telescope find_files<CR>", { noremap = true, silent = true })

-- Keybinding for live grep search
vim.api.nvim_set_keymap("n", "<leader>f", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- Keybinding for selecting all text
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Keybinding for selecting current block
vim.api.nvim_set_keymap("n", "<C-a><C-a>", "vip", { noremap = true, silent = true })

-- ToggleTerm keybindings
require("toggleterm").setup({
  size = 20,
  shade_filetypes = {},
  direction = "float",
  float_opts = {
    border = "curved",
    width = 100,
    height = 30,
    winblend = 3,
  },
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  persist_size = true,
  close_on_exit = true,
})

vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-S-t>", "<cmd>ToggleTerm direction=float 2<CR>", { noremap = true, silent = true })

-- Configure Auto-completion
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
