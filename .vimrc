call plug#begin('~/.vim/plugged')
"Plugin 'Valloric/YouCompleteMe'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
"Plugin 'tomtom/tcomment_vim'
Plug '2072/PHP-Indenting-for-VIm'
"Bundle 'Lokaltog/vim-easymotion'
"Bundle 'mileszs/ack.vim'
"Bundle 'chase/vim-ansible-yaml'
" Plug 'klen/python-mode'
"Plug 'lambdalisue/vim-pyenv'
Plug 'fatih/vim-go'

" Snippets
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" Colorscheme syntax
Plug 'sheerun/vim-polyglot'
Plug 'elzr/vim-json'
Plug 'Yggdroot/indentLine'
"Plug 'valloric/MatchTagAlways'
Plug 'Raimondi/delimitMate'
" Plug 'scrooloose/syntastic'
Plug 'benekastah/neomake'
Plug 'junegunn/vim-easy-align'
" Plug 'tmhedberg/matchit'

" Utils
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'bling/vim-airline'
Plug 'tomtom/tcomment_vim'
"Plug 'xolox/vim-notes'
Plug 'xolox/vim-misc'

" Git Helpers
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'Xuyuanp/nerdtree-git-plugin'


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
nmap <leader>t :term<cr>


highlight OverLength ctermbg=red ctermfg=white guibg=#592929
fun! UpdateMatch()
    if &ft !~ '^\%(Jenkinsfile\|rb\)$'
        match OverLength /\%181v.*/
    else
        match NONE
    endif
endfun
autocmd BufEnter,BufWinEnter * call UpdateMatch()

:let g:notes_directories = ['~/Dropbox/Notes']
imap <C-]> <C-o>:SearchNotes<CR>
nmap <C-]> :SearchNotes<CR>

let g:pymode_folding = 0


" NERDTree ------------------------------------------------------------------{{{

  map <C-\> :NERDTreeToggle<CR>
  autocmd StdinReadPre * let s:std_in=1
  " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  let NERDTreeShowHidden=1
  let g:NERDTreeWinSize=45
  let g:NERDTreeAutoDeleteBuffer=1
  " NERDTress File highlighting
  function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
  endfunction

  call NERDTreeHighlightFile('jade', 'green', 'none', 'green', 'none')
  call NERDTreeHighlightFile('md', 'blue', 'none', '#6699CC', 'none')
  call NERDTreeHighlightFile('config', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('conf', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('json', 'green', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('html', 'yellow', 'none', '#d8a235', 'none')
  call NERDTreeHighlightFile('css', 'cyan', 'none', '#5486C0', 'none')
  call NERDTreeHighlightFile('scss', 'cyan', 'none', '#5486C0', 'none')
  call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', 'none')
  call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', 'none')
  call NERDTreeHighlightFile('ts', 'Blue', 'none', '#6699cc', 'none')
  call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
  call NERDTreeHighlightFile('gitconfig', 'black', 'none', '#686868', 'none')
  call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#7F7F7F', 'none')
"}}}


" Snipppets -----------------------------------------------------------------{{{

" Enable snipMate compatibility feature.
  let g:neosnippet#enable_snipmate_compatibility = 1
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)
" Tell Neosnippet about the other snippets
" let g:neosnippet#snippets_directory='~/.config/repos/github.com/Shougo/neosnippet-snippets/neosnippets, ~/Github/ionic-snippets, ~/.config/repos/github.com/matthewsimo/angular-vim-snippets/snippets'

" SuperTab like snippets behavior.
  imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: pumvisible() ? "\<C-n>" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)"
  \: "\<TAB>"

"}}}

"" associate Jenkinfile* with groovy filetype
au BufRead,BufNewFile Jenkinsfile* setfiletype groovy

" 1. base64-encode(visual-selection) -> F2 -> encoded base64-string
:vnoremap <F2> c<c-r>=system("base64 -w 0", @")<cr><esc>

" 2. base64-decode(visual-selection) -> F3 -> decoded string
:vnoremap <F3> c<c-r>=system("base64 -d", @")<cr> 
