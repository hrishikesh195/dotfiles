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
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'github-theme'
Plugin 'wincent/command-t'
Plugin 'rust-lang/rust.vim'
Plugin 'racer-rust/vim-racer'

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
if has('mouse')
  set mouse=a ttymouse=sgr
endif

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
  autocmd FileType text setlocal textwidth=78 expandtab ts=4 sts=4 sw=4
  au FileType python setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4
  au FileType haskell setlocal tabstop=4 expandtab shiftwidth=4 softtabstop=4 shiftround
  au FileType markdown setlocal expandtab ts=4 sts=4 sw=4
  au FileType javascript setlocal ts=4 expandtab sw=4 sts=4 textwidth=78
  au FileType html setlocal ts=4 expandtab sw=4 sts=4
  au FileType cpp setlocal tabstop=4 shiftwidth=4 textwidth=80 sts=4 expandtab
  au FileType c setlocal tabstop=8 shiftwidth=8 textwidth=80 sts=8 noexpandtab shiftround

  au! BufRead,BufNewFile *.txt setfiletype text

  " For go files
  au! BufRead,BufNewFile *.go setfiletype go
  au FileType go hi goSpaceError ctermfg=white
  au FileType go nmap <leader>b <Plug>(go-build)
  au FileType go nmap <Leader>R <Plug>(go-run)
  au FileType go nmap <Leader>r <Plug>(go-referrers)
  au FileType go nmap <Leader>i <Plug>(go-implements)
  au FileType go nmap <Leader>d <Plug>(go-doc-vertical)
  au FileType go set mouse=a ttymouse=sgr	" for ctrl+click, scrolling, navigation
  au FileType go cnoreabbrev gd GoDoc
  let g:go_fmt_command = "goimports"
  let g:go_list_type = "quickfix"
  let g:go_doc_max_height = 50

  " For rust files
  " let g:rustfmt_autosave = 1
  au FileType rust nmap gd <Plug>(rust-def)
  au FileType rust nmap gs <Plug>(rust-def-split)
  au FileType rust nmap gx <Plug>(rust-def-vertical)
  au FileType rust nmap <leader>gd <Plug>(rust-doc)
  au FileType rust nmap <Leader>R :w<CR> :!cargo run<CR>

  " Transcript files. Insert a timestamp every time Enter is pressed in insert
  " mode. This doesn't apply while editing in 'paste'.
  au! BufRead,BufNewFile *.transcript setfiletype transcript
  au FileType transcript inoremap <CR> <C-c>:put =system('date \"+(%I:%M:%S %p)\"')<CR>o<CR>
  au FileType transcript set ts=4

  " For C, C++ files
  au FileType c inoreabbrev (s (struct
  au FileType c inoreabbrev s struct
  au FileType c,cpp nnoremap <C-t> :colder<CR>	" for use with GNU Global
  " au! BufRead,BufNewFile,BufEnter *.h setfiletype c

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

" Copy entire buffer to clipboard (Mac)
nnoremap <Leader>c :%w !pbcopy<CR><CR>
if has("clipboard")
	set clipboard=unnamed
else
	" Copy visual mode selection to clipboard (Mac)
	" This doesn't seem to work though; it copies the whole line instead
	" of just the selected word, for example
	vnoremap <Leader>c :w !pbcopy<CR><CR>
endif " has("clipboard")

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

" nerdtree
map <Leader>t :NERDTreeToggle<CR>
map <Leader>f :NERDTreeFind<CR>

" For GNU Global
" Run 'gtags' in root directory to generate tags; 'global -u' to update
nnoremap <Leader>g :GtagsCursor<CR>
" nnoremap <C-t> :colder<CR>
" Type C-v after last character to avoid expansion
cnoreabbrev gt Gtags

" For ctrlp
let g:ctrlp_by_filename = 1	" toggle using c-d
let g:ctrlp_regexp = 1		" toggle using c-r
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:100'
" nnoremap <Leader>p :CtrlP .<CR>

" For command-t
" let g:CommandTFileScanner = "git"
let g:CommandTFileScanner = "watchman"
let g:CommandTMaxFiles=1000000
nnoremap <Leader>p :CommandT<CR>

" Quickfix
nnoremap <C-j> :cnext<CR>
nnoremap <C-k> :cprev<CR>
nnoremap <C-l> :cclose<CR>

" Have run into E363 for some large files; use a bigger mem limit (in KB)
set maxmempattern=32000
