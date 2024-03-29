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

" paste without yanking selection
vnoremap p "_dP

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'christoomey/vim-conflicted'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'Valloric/YouCompleteMe'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'vim-perl/vim-perl'
Plugin 'leafgarland/typescript-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'jamessan/vim-gnupg'
Plugin 'cpp.vim'
Plugin 'rkitover/perl-vim-mxd'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'kien/ctrlp.vim'
Plugin 'jonathanfilip/vim-lucius'
Plugin 'perl-support.vim'
Plugin 'cstrahan/vim-capnp'
Plugin 'fatih/vim-go'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'derekwyatt/vim-scala'
Plugin 'pbrisbin/vim-syntax-shakespeare'
Plugin 'peterhoeg/vim-qml'
Plugin 'kergoth/vim-bitbake'
Plugin 'hashivim/vim-terraform'
Plugin 'juliosueiras/vim-terraform-completion'

let g:yesod_handlers_directories = ['Handler', 'src']
Plugin 'alx741/yesod.vim'

call vundle#end()
filetype plugin indent on

" color scheme
let g:lucius_no_term_bg=1
color lucius
silent! LuciusBlackHighContrast

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
let g:syntastic_javascript_checkers = ['jshint']

" YouCompleteMe settings
let g:ycm_rust_src_path = '/home/littlefox/tmp/rustc-1.10.0'

" Vim-Airline settings
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
let g:airline_section_y = airline#section#create_right(['ffenc', '%{wordcount().chars}/%{wordcount().words}'])

" xuhdev/vim-latex-live-preview
let g:livepreview_previewer = 'evince'

" configure vim-go to pass "-tags integration" to gopls
let g:go_gopls_settings = {'buildFlags': ['-tags=integration']}

" first, no <esc> but jk to get back to normal mode
if has('gui_running')
    inoremap <esc> <nop>
end
inoremap jk <esc>
vnoremap jk <esc>

" habbit breaking
nnoremap <Up>    :echo "Use HJKL!"<CR>
nnoremap <Down>  :echo "Use HJKL!"<CR>
nnoremap <Left>  :echo "Use HJKL!"<CR>
nnoremap <Right> :echo "Use HJKL!"<CR>


if has("autocmd")
    augroup templates
        autocmd BufNewFile *.yml :command Service    read ~/.vim/templates/k8s/service.yml
        autocmd BufNewFile *.yml :command Ingress    read ~/.vim/templates/k8s/ingress.yml
        autocmd BufNewFile *.yml :command Pvc        read ~/.vim/templates/k8s/pvc.yml
        autocmd BufNewFile *.yml :command Deployment read ~/.vim/templates/k8s/deployment.yml
    augroup END
endif

map <C-S> :call Sqlscratch()<CR>

" language specific settings
autocmd FileType typescript setlocal sw=2
autocmd FileType xml        setlocal sw=2
autocmd FileType yaml       setlocal sw=2
autocmd FileType html       setlocal sw=2
autocmd FileType scss       setlocal sw=2
autocmd FileType css        setlocal sw=2

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
