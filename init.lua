-- Lua config for NeoVim.

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
    "nvim-telescope/telescope.nvim", -- File finder
    dependencies = { "nvim-lua/plenary.nvim" },
    lazy = false, -- Load immediately
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
    "sixfourtwelve/bore.vim", -- Bore theme
    lazy = false,
    config = function()
      vim.opt.background = "dark"
      vim.cmd("colorscheme bore")
      if vim.fn.has("termguicolors") == 1 then
        vim.opt.termguicolors = true
      end
    end,
  },

  -- Other Themes
  {
    "morhetz/gruvbox",
    lazy = false, -- Load immediately
  },
  {
    "sainnhe/everforest",
    lazy = false, -- Load immediately
  },

  -- Markdown plugins
  {
    "plasticboy/vim-markdown", -- Syntax highlighting and conceal for markdown
    lazy = false,
  },
  {
    "ellisonleao/glow.nvim", -- Render Markdown in terminal
    lazy = true,
    config = function()
      require('glow').setup()
    end,
    cmd = "Glow", -- Load only when Glow is called
  },
  {
    "nvim-treesitter/nvim-treesitter", -- Tree-sitter support for Markdown
    lazy = false,
    run = ":TSUpdate",
  },

  -- Avante.nvim (lazy-loaded)
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "openai",
      openai = {
        model = "gpt-4o-mini",
      },
      cache_path = "C:/Users/devin/AppData/Local/nvim/avante_cache",
      auto_suggestions_provider = "openai",
      mappings = {
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
        },
      },
      behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = false,
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
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

-- General Neovim settings
vim.cmd([[set number]])
vim.cmd([[set syntax=on]])

-- Highlight window separators
vim.cmd [[
  highlight WinSeparator guifg=#3b3b3b guibg=None
]]

vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "<leader>x", ":echo 'Leader key works!'<CR>", { noremap = true, silent = true })

-- Indentation settings
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Cursor and scrolling behavior
vim.o.scrolloff = 0

-- Relative Line Numbers
vim.o.number = true
vim.o.relativenumber = true

-- Clipboard settings
vim.o.clipboard = "unnamedplus"

-- GUI font
vim.o.guifont = "Monaco:h24"

-- Filetype settings for Markdown
vim.cmd([[
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType markdown setlocal wrap
  autocmd FileType markdown setlocal spell
]])

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

-- Keybinding for selecting all text
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Keybinding for selecting current block
vim.api.nvim_set_keymap("n", "<C-a><C-a>", "vip", { noremap = true, silent = true })

-- Glow keybinding to preview Markdown in terminal
vim.api.nvim_set_keymap("n", "<leader>p", ":Glow<CR>", { noremap = true, silent = true })

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

