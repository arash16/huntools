" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" apt install fonts-powerline ripgrep universal-ctags vim-gtk3

set nocompatible
filetype off
filetype plugin indent on

syntax on
set fileformat=unix
set encoding=UTF-8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |

set number
set relativenumber
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smartindent
set smarttab
set expandtab

set ignorecase
set smartcase
set incsearch
set hlsearch
noremap <silent> <cr> :noh<cr>

set termwinsize=12x0
set splitbelow
set mouse=a
set scrolloff=8

set nowrap
set nolist
set listchars=eol:.,tab:>-,trail:~,extends:>,precedes:<

set showcmd
set noshowmode
set termguicolors
set clipboard=unnamed

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin('~/.vim/plugged')
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'sheerun/vim-polyglot'
  Plugin 'preservim/nerdtree'
  Plugin 'Yggdroot/indentLine'
  Plugin 'vim-airline/vim-airline'
  Plugin 'editorconfig/editorconfig-vim'
  Plugin 'freitass/todo.txt-vim'
  Plugin 'arash16/vim-man2'
  Plugin 'mcchrish/nnn.vim'
  Plugin 'junegunn/fzf.vim'
  Plugin 'junegunn/fzf'
  Plugin 'NLKNguyen/papercolor-theme'
call vundle#end()

let g:PaperColor_Theme_Options = {
  \   'theme': {
  \     'default': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
set background=dark
autocmd vimenter * ++nested colorscheme PaperColor

" :PluginInstall
nnoremap <C-t> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeRespectWildIgnore=1
set wildignore+=*.DS_Store,*.min.*
autocmd BufWinEnter * silent NERDTreeMirror

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
let g:NERDTreeFileLines = 1

let g:airline_powerline_fonts = 1
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
