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
      -- Enable the Bore theme
      vim.opt.background = "dark" -- Set the background to dark
      vim.cmd("colorscheme bore") -- Set the Bore colorscheme
      -- Enable true colors for the best experience
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

  -- Avante.nvim (lazy-loaded)
  {
    "yetone/avante.nvim",
    event = "VeryLazy", -- Load only when required
    lazy = false,
    version = false, -- Always use the latest version
    opts = {
      provider = "openai",
      openai = {
        model = "gpt-4o-mini", -- Replace with your desired OpenAI model
      },
      cache_path = "C:/Users/devin/AppData/Local/nvim/avante_cache", -- Custom cache path
      auto_suggestions_provider = "openai",
      mappings = {
        suggestion = {
          accept = "<M-l>", -- Accept suggestion
          next = "<M-]>", -- Next suggestion
          prev = "<M-[>", -- Previous suggestion
          dismiss = "<C-]>", -- Dismiss suggestion
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
    build = "make", -- Use prebuilt binaries (or replace with "make BUILD_FROM_SOURCE=true" to build manually)
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

-- Custom :Delete command to delete the current file
vim.cmd([[
command! Delete call DeleteCurrentFile()
function! DeleteCurrentFile()
  let l:current_file = expand('%:p')
  if filereadable(l:current_file)
    let l:confirm = confirm("Delete current file?", "&Yes\n&No", 2)
    if l:confirm == 1
      call delete(l:current_file)
      bdelete!
      echo "File deleted: " . l:current_file
      call ToggleAndRefreshNERDTree()
    endif
  else
    echo "No file to delete"
  endif
endfunction
]])

-- Custom keybindings for creating files and folders
vim.cmd([[
nnoremap <C-f> :call CreateNewFile()<CR>
function! CreateNewFile()
  let l:filename = input("Enter new file name: ")
  if l:filename != ""
    execute "edit " . l:filename
    call ToggleAndRefreshNERDTree()
  endif
endfunction

nnoremap <C-A-f> :call CreateNewFolder()<CR>
function! CreateNewFolder()
  let l:foldername = input("Enter new folder name: ")
  if l:foldername != ""
    let l:status = mkdir(l:foldername, "p")
    if l:status == 0
      echo "Failed to create folder: " . l:foldername
    else
      echo "Folder created: " . l:foldername
      call ToggleAndRefreshNERDTree()
    endif
  endif
endfunction
]])

-- Avante.nvim keybindings
vim.api.nvim_set_keymap("n", "<C-c>", ":lua require('avante').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<C-s>", ":lua require('avante').get_suggestion():suggest()<CR>", { noremap = true, silent = true })

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

