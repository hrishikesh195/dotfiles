" Use vim instead of vi
set nocompatible

" <Vundle>
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" Plugins can be specified by github 'username/repo' or simply 'plugin' from
" the vim scripts website
" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'Lokaltog/vim-easymotion'
Plugin 'tomtom/tcomment_vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'fatih/vim-go'
Plugin 'github-theme'
" Plugin 'AutoComplPop'
" Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" </Vundle>

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set backup		" keep a backup file
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set wildmenu		" better command line completion

" In many terminal emulators the mouse works just fine, thus enable it.
" if has('mouse')
"   set mouse=a
" endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
  au FileType python setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4
  au FileType haskell setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4 shiftround
  au FileType markdown setlocal expandtab ts=4 sts=4 sw=4
  au FileType javascript setlocal ts=4 expandtab sw=4 sts=4 textwidth=78
  au FileType html setlocal ts=4 expandtab sw=4 sts=4
  au! BufRead,BufNewFile *.txt setfiletype text
  autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 textwidth=80 sts=4 expandtab
  autocmd FileType c setlocal tabstop=8 shiftwidth=8 textwidth=80 sts=8 noexpandtab

  " For go files
  au! BufRead,BufNewFile *.go setfiletype go
  au FileType go hi goSpaceError ctermfg=white
  " au FileType go nmap <Leader>r :!go run %<CR>
  au FileType go nmap <Leader>r <Plug>(go-run)
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <leader>T <Plug>(go-test)
  " au FileType go nmap <leader>c <Plug>(go-coverage)
  au FileType go nmap <Leader>s <Plug>(go-implements)
  au FileType go nmap <Leader>d <Plug>(go-def)
  au FileType go nmap <Leader>i :GoImports<CR>
  au FileType go nmap <Leader>f :GoFmt<CR>
  let g:go_fmt_command = "goimports"

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Use C-w C-o (or :only) and then :diffoff to go back to original
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

let mapleader=','
se nu

if &t_Co > 255 || has("gui_running")
  silent! colorscheme github
else
  " uses the default colorscheme
  highlight LineNr ctermfg=gray
endif

nnoremap <Leader>r :!./a.out<CR>

" Copy entire buffer to clipboard (Mac)
nnoremap <Leader>c :%w !pbcopy<CR><CR>
" Copy visual mode selection to clipboard (Mac)
vnoremap <Leader>c :w !pbcopy<CR><CR>

" Perforce
" p4 edit the current file
nnoremap <Leader>e :!p4 edit %<CR>

" set paste/nopaste
set pastetoggle=<F9>

" For markdown section/sub-section
nnoremap <Leader>= yyp:s/./=/g<CR>:noh<CR>
nnoremap <Leader>- yyp:s/./-/g<CR>:noh<CR>

" Quote/unquote selection
vnoremap <Leader>q :s/^/> /<CR>:noh<CR>
vnoremap <Leader>Q :s/^> //<CR>:noh<CR>

" nerdtree toggle
map <Leader>t :NERDTreeToggle<CR>

" For GNU Global
" Run 'gtags' in root directory to generate tags; 'global -u' to update
nnoremap <Leader>g :GtagsCursor<CR>
nnoremap <C-n> :cn<CR>
nnoremap <C-p> :cp<CR>
nnoremap <C-l> :ccl<CR>
" Type C-v after last character to avoid expansion
cnoreabbrev gt Gtags
