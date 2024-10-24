call plug#begin('~/.local/share/nvim/plugged')

" Plugin installations
Plug 'morhetz/gruvbox'            " Gruvbox theme
Plug 'preservim/nerdtree'          " NERDTree for file tree
Plug 'vim-airline/vim-airline'     " Status line
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Autocompletion
Plug 'akinsho/toggleterm.nvim', {'branch': 'main'}  " ToggleTerm plugin for terminal

call plug#end()

" Theme and appearance
colorscheme gruvbox
set number
syntax on

" NERDTree keybinding
nnoremap <C-n> :NERDTreeToggle<CR>

" Keybinding for selecting all text with Ctrl + A
nnoremap <C-a> ggVG

" Keybinding for selecting current block with Ctrl + A + A
nnoremap <C-a><C-a> vip

" Keybinding for deleting current line with Ctrl + X
nnoremap <C-x> dd

" Enable system clipboard
set clipboard=unnamedplus

" ToggleTerm setup for multiple terminals
lua << EOF
  require("toggleterm").setup{
    size = 20,
    shade_filetypes = {},
    direction = 'float',  -- Open terminal as a floating window
    float_opts = {
      border = 'curved',  -- Curved border for the terminal
      width = 100,
      height = 30,
      winblend = 3,
    },
    hide_numbers = true,  -- Hide line numbers in terminal
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,  -- Start in insert mode
    persist_size = true,
    close_on_exit = true,
  }

  -- Keybinding for Terminal 1 (Ctrl + T)
  vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>ToggleTerm direction=float<CR>", {noremap = true, silent = true})

  -- Keybinding for Terminal 2 (Ctrl + Alt + T)
  vim.api.nvim_set_keymap("n", "<C-A-t>", "<cmd>ToggleTerm direction=float 2<CR>", {noremap = true, silent = true})
EOF

