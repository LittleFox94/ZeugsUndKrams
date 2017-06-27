" first some basics
set number          " line numbers
set nocompatible    " be VIM, not Vi
set autoread        " Check files for changes automagically
set smartcase       " try to be smart with case when searching
set hlsearch        " highlight search results
set lazyredraw      " more performance
set showmatch       " show matching brackets
set encoding=utf8   " be 2017
set ffs=unix,dos    " prefer unix line endings
set expandtab       " replace tabs with spaces
set smarttab        " .. but be smart with legacy/foreign files
set shiftwidth=4    " 1 tab = 4 spaces
set tabstop=4       "       -""-
set ai              " enable auto indent
set si              " .. but be smart
set nowrap          " never wrap lines
set hidden          " keep buffers in memory
syntax on           " Syntax highlighting

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
Plugin 'rkitover/perl-vim-mxd'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'dbext.vim'
Plugin 'mtth/scratch.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'vitalk/vim-simple-todo'
Plugin 'jonathanfilip/vim-lucius'

call vundle#end()
filetype plugin indent on

" color scheme
let g:lucius_no_term_bg=1
color lucius
LuciusBlackHighContrast

" NERDTree settings
let NERDTreeQuitOnOpen=1
map <C-e> :NERDTreeToggle<CR>
autocmd vimenter * wincmd p   " switch focus to file instead of NERDTree
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
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1

" xuhdev/vim-latex-live-preview
let g:livepreview_previewer = 'evince'

" dbext
let g:dbext_default_profile_VISUV2     = 'type=DBI:user=root:passwd=autinityPlanet:driver=mysql:conn_parms=database=VISUV2;host=dbsrv'
let g:dbext_default_profile_TESTPORTAL = 'type=DBI:user=root:passwd=autinityPlanet:driver=mysql:conn_parms=database=CMS_223;host=testportal'

" habbit breaking

" first, no <esc> but jk to get back to normal mode
inoremap <esc> <nop>
inoremap jk <esc>

" then, no arrow keys but hjkl
noremap <Up>    :echo "Use HJKL!"<CR>
noremap <Down>  :echo "Use HJKL!"<CR>
noremap <Left>  :echo "Use HJKL!"<CR>
noremap <Right> :echo "Use HJKL!"<CR>

" work specific stuff
augroup visuv2
    au!
    autocmd BufRead /mnt/sshfs/autinitysrv/mgr/visuv2/* DBSetOption profile=VISUV2
augroup end

function Sqlscratch()
    Scratch
    set ft=sql
    nnoremap <buffer> q :bd!<CR>
    DBSetOption profile=VISUV2
endfunction

map <C-S> :call Sqlscratch()<CR>
