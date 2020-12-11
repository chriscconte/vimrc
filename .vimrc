" Chris Conte
let g:ycm_log_level = 'debug'
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
Plug 'jacquesbh/vim-showmarks'

" tabline and statusline
Plug 'vim-airline/vim-airline'

call plug#end()

" YouCompleteMe and UltiSnips compatibility, with the helper of supertab
" (via http://stackoverflow.com/a/22253548/1626737)
let g:SuperTabDefaultCompletionType    = '<C-n>'
let g:SuperTabCrMapping                = 0
let g:UltiSnipsExpandTrigger           = '<C-E>'
let g:UltiSnipsJumpForwardTrigger      = '<C-J>'
let g:UltiSnipsJumpBackwardTrigger     = '<C-K>'
let g:ycm_key_list_select_completion   = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']

" visual
set number
set foldcolumn=0
set hlsearch
syntax on

"" line numbers
:set number relativenumber

:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

"" File Browser
let g:netrw_liststyle= 3

" folding
set foldopen=hor,mark,percent,quickfix,search,tag,undo

" editorconfig
set tw=0
" let g:EditorConfig_core_mode='python_builtin'

" linting
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'vue': ['eslint'],
\   'PHP': ['phpcs'],
\   'python': ['flake8', 'pylint']
\}
let g:ale_fixers = {
\   'php': ['phpcbf'],
\   'python': ['autopep8', 'add_blank_lines_for_python_control_statements', 'autopep8', 'black', 'isort', 'reorder-python-imports', 'yapf']
\}

nmap <F8> <Plug>(ale_fix)

"tabline
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#tabline#enabled = 1

" themes
colorscheme desert
highlight Comment gui=italic
set macligatures
set guifont=Fira\ Code\ Regular:h14

" file watcher doesn't catch changes if this isn't set
set backupcopy=yes
set noswapfile
set nobackup

" change + and _ keys to 
" http://vim.wikia.com/wiki/Converting_variables_to_or_from_camel_case
" nnoremap + :%s/\v%(\$%(\k+))@<=_(\k)/\u\1/g
" nnoremap _ :s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g

" fix syntax highlighting http://vim.wikia.com/wiki/Fix_syntax_highlighting
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" edit multiple files in one command http://vim.wikia.com/wiki/Load_multiple_files_with_a_single_command
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

" bclose
nmap <C-W>! <Plug>Kwbd

" add multiple files to buffer list
command! -complete=file -nargs=* Bad call Bad(<f-args>)
function! Bad(...)
  for f in a:000
    for g in glob(f, 0, 1)
      exe "bad " . fnameescape(g)
    endfor
  endfor
endfunction

" Template params
let g:username='Christopher Conte'
let g:email='Christopher@Jubiwee.com'

"" Custom Mappings
" Edit source
map <C-x>e <Esc>:tabe ~/.vimrc<CR>
map <C-x>s <Esc>:source ~/.vimrc<CR>:echo "source ~/.vimrc"<CR>

" bw
noremap <C-Q> <Esc>:bw<CR>

" control line remap
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <C-R>h hide \| b 

" Map to scroll faster
noremap <C-J> 3j
noremap <C-K> 3k

" Map to next error
noremap <F6> :ALENext<CR>

" Delete trailing character
nnoremap tt mZ$x`Z

" split and vsplit
nnoremap <C-S> :split<CR>

" macvim render problems
autocmd FocusGained * redraw!
nmap <F10> :redraw!<CR>

" close file and delete buffer without fucking up windows
nmap <C-B> <Plug>Kwbd

"open php files
"use App\Http\Controllers\Controller;
function! OpenFileUnderCursor(str)
  let path = substitute(a:str, ';', '', 'g')
  if &filetype == 'php'
    let path = substitute(path, '\\', '\/', 'g')
    let path = path.'.php'
  endif
  execute 'edit '.path
endfunction

nmap g9 vEy:call OpenFileUnderCursor(@")<CR>

" copy to system clipboard
vmap ++ "+y:echo "copied to system keyboard"<CR>

" bind K to grep word under cursor
"" nnoremap K :grep -rn "\b<C-R><C-W>\b" .<CR>:cw<CR>

function! TitleCase(str)
  return substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
endfunction
vnoremap ~ y:call setreg('', TitleCase(@"), getregtype(''))<CR>gv""Pgv

" terminal normal mode remap
tnoremap <Esc> <C-\><C-n>

set tabstop=4
