call plug#begin('~/.vim/plugged')
"Plugin 'kien/ctrlp.vim'
"Plugin 'Valloric/YouCompleteMe'
Plug 'scrooloose/nerdtree'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tmhedberg/matchit'
"Plugin 'tomtom/tcomment_vim'
Plug '2072/PHP-Indenting-for-VIm'
Plug 'bling/vim-airline'
"Bundle 'Lokaltog/vim-easymotion'
Plug 'scrooloose/syntastic'
Plug 'junegunn/vim-easy-align'
"Bundle 'mileszs/ack.vim'
"Bundle 'chase/vim-ansible-yaml'
"Bundle 'xolox/vim-notes'
"Bundle 'xolox/vim-misc'
" Plug 'klen/python-mode'
"Plug 'lambdalisue/vim-pyenv'
Plug 'fatih/vim-go'



"Plugin 'tpope/vim-fugitive'
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" All of your Plugins must be added before the following line
call plug#end()

filetype plugin indent on    " required

syntax on
set number
set hlsearch
set smartcase
set autoindent
set nowrap
set incsearch
set noerrorbells
set history=1000
set undolevels=1000
set t_vb=
"
" tabs to spaces
set expandtab
set tabstop=4
set shiftwidth=4

set nobackup
set noswapfile
set wildmenu
set wildmode=list:longest,full
set ignorecase
set nohidden


let mapleader=","

nnoremap <leader>/ :nohlsearch<CR>

nnoremap <leader>ev tabnew: ~/.vimrc<CR>
vmap <Enter> <Plug>(EasyAlign)


" Plugin settings
nnoremap <leader>n :NERDTreeToggle<CR>

let g:ctrlp_working_path_mode='r'
colorscheme slate

"Vim Fugitive mappings
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gw :Gwrite<CR>
nnoremap <leader>gp :Gpush<CR>

highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/


:let g:notes_directories = ['~/Dropbox/Notes']

let g:pymode_folding = 0
