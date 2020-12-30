" Chris Conte

" Install Plug if not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
" code style
Plug 'editorconfig/editorconfig-vim'

" linting -- pre compile error catcher
Plug 'w0rp/ale'

" autocomplete
Plug 'Valloric/YouCompleteMe'

" snippets
" Plug 'SirVer/ultisnips'

" write (), {}, '', <> faster
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-markdown'

" template plugin to start files with standard requirements 
Plug 'aperezdc/vim-template'

" for stack traces TODO 
Plug 'mattboehm/vim-unstack'

Plug 'suan/vim-instant-markdown', {'rtp': 'after'}

" auto generate tags
Plug 'ludovicchabant/vim-gutentags'

" show marks
Plug 'kshenoy/vim-signature'

" tabline and statusline
Plug 'vim-airline/vim-airline'

" file browser
Plug 'preservim/nerdtree'


" fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'}
Plug 'junegunn/fzf.vim'

call plug#end()

" set leader
let mapleader=","

" no legacy weirdness, and bug fixes =========================================
"" file watcher doesn't catch changes if this isn't set
set nocompatible 
set encoding=utf-8
set noswapfile
set backupcopy=yes
set nobackup

"" macvim render problems
autocmd FocusGained * redraw!
nmap <F10> :redraw!<CR>

"" fix syntax highlighting http://vim.wikia.com/wiki/Fix_syntax_highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

"" backspace works over whole file
set backspace=indent,eol,start
set laststatus=2

"" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
"" (via http://stackoverflow.com/a/22253548/1626737)
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
let g:UltiSnipsExpandTrigger           = '<C-E>'
let g:UltiSnipsJumpForwardTrigger      = '<C-J>'
let g:UltiSnipsJumpBackwardTrigger     = '<C-K>'
let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']


" visual changes =============================================================
syntax on
set showcmd
set tabstop=4
set colorcolumn=80              " Show the 80th char column.

"" themes
colorscheme desert
highlight Comment gui=italic
highlight ColorColumn guibg=Grey30
set macligatures
set guifont=Fira\ Code\ Regular:h14

"" vim-signature 
hi SignatureMarkText guifg=black

"" folding
set foldcolumn=0
set foldopen=hor,mark,percent,quickfix,search,tag,undo

"" line numbers
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"" airline tabline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1


" File Management =============================================================
au FocusLost * :wa " Save when leaving macvim
set hidden " save buffers
set undofile " preserve undos between sessions

"" open multiple files in seperate tabs
"" http://vim.wikia.com/wiki/Load_multiple_files_with_a_single_command
command! -complete=file -nargs=* Tabe call Tabe(<f-args>)
function! Tabe(...)
  let t = tabpagenr()
  let i = 0
  for f in a:000
    for g in glob(f, 0, 1)
      exe "tabe " . fnameescape(g)
      let i = i + 1
    endfor
  endfor
  if i
    exe "tabn " . (t + 1)
  endif
endfunction

"" add multiple files to buffer list
command! -complete=file -nargs=* Bad call Bad(<f-args>)
function! Bad(...)
  for f in a:000
    for g in glob(f, 0, 1)
      exe "bad " . fnameescape(g)
    endfor
  endfor
endfunction

" close file and delete buffer without fucking up windows
nmap <leader>c <Plug>Kwbd

" Edit vimrc, and source vimrc
map <leader>e :tabe $MYVIMRC<CR>
map <leader>s :source $MYVIMRC<CR>:echo "source ".$MYVIMRC<CR>

" auto-formatting =============================================================
"" editorconfig
set tw=0
set autoindent nosmartindent    " auto/smart indent
set smarttab
set expandtab                   " expand tabs to spaces
set shiftwidth=4
set softtabstop=4

"" linting using ALE
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'PHP': ['phpcs'],
\   'python': ['pylint']
\}
let g:ale_fixers = {
\   'php': ['phpcbf'],
\   'python': ['autopep8',
\              'add_blank_lines_for_python_control_statements',
\              'autopep8',
\              'black',
\              'isort',
\              'reorder-python-imports',
\              'yapf']
\}

let g:ale_python_pylint_executable='/Users/chrisconte/.pyenv/shims/pylint'

""" Map to next error
noremap <F6> :ALENext<CR>

"" Template params for vim-template
let g:username='Christopher Conte'
let g:email='chris@techquity.ai'

"" convert from camel to kebab and back
"" http://vim.wikia.com/wiki/Converting_variables_to_or_from_camel_case
nnoremap <leader>+ :%s/\v%(\$%(\k+))@<=_(\k)/\u\1/g
nnoremap <leader>_ :s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

" set ~ to make selected title case
function! TitleCase(str)
  return substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
endfunction
vnoremap ~ y:call setreg('', TitleCase(@"), getregtype(''))<CR>gv""Pgv

"" Delete trailing character
nmap <leader>tt mZ$x`Z

" Registers/Marks ============================================================= 
" copy to system clipboard
vmap ++ "+y:echo "copied to system keyboard"<CR>


" Mode Switching ==============================================================
"" terminal normal mode remap
tnoremap <Esc> <C-\><C-n>

" conveniently enter ex mode
nnoremap ; :

" conveniently exit insert mode
inoremap jj <ESC>

" Navigation ==================================================================
set scrolloff=3
"" tab across parentheses
nnoremap <tab> %
vnoremap <tab> %

"" navigate lines visually
nnoremap j gj
nnoremap k gk

"" navigate windows
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"" navigate buffers, files, tags with fzf
imap <c-x><c-o> <plug>(fzf-complete-line)
map <leader>b :Buffers<cr>
map <leader>f :Files<cr>
map <leader>g :GFiles<cr>
map <leader>t :Tags<cr>

"" find using no magic
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

nnoremap <leader><space> :noh<cr>

" temp  (training)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" endtemp

" Ex Mode =====================================================================
"" tab completion
set wildmenu
set wildmode=list:longest

"" control line remap
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-R>h hide \| b 


" Terminal ==================================================================== 
"" terminal interaction
set visualbell
set ttyfast
