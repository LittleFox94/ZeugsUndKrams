" first some basics
set number          " line numbers
set nocompatible    " be VIM, not Vi
set autoread        " Check files for changes automagically
set smartcase       " try to be smart with case when searching
set hlsearch        " highlight search results
set lazyredraw      " more performance
set showmatch       " show matching brackets
set encoding=utf8   " be 2016
set ffs=unix,dos    " prefer unix line endings
set expandtab       " replace tabs with spaces
set smarttab        " .. but be smart with legacy/foreign files
set shiftwidth=4    " 1 tab = 4 spaces
set tabstop=4       "       -""-
set ai              " enable auto indent
set si              " .. but be smart
set nowrap          " never wrap lines
syntax on           " Syntax highlighting
color molokai       " Color scheme

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rust-lang/rust.vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-perl/vim-perl'
Plugin 'benmills/vimux'
Plugin 'sigidagi/vim-cmake-project'
Plugin 'leafgarland/typescript-vim'
Plugin 'Icinga/icinga2', { 'rtp': 'icinga2/tools/syntax/vim' }
Plugin 'vim-airline/vim-airline'
Plugin 'ahri/vim-sesspit'

call vundle#end()
filetype plugin indent on

" NERDTree settings
map <C-e> :NERDTreeToggle<CR>
autocmd vimenter * wincmd p    " switch focus to file instead of NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Syntastic settings
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=0
let g:syntastic_check_on_open=1
let g:syntastic_cpp_compiler_options=' -std=c++11'

" YouCompleteMe settings
let g:ycm_rust_src_path = '/home/littlefox/tmp/rustc-1.10.0'

" Vim-Airline settings
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
