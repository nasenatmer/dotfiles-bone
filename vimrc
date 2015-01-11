" Start with Vundle 
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/ScrollColors'
Plugin 'lervag/vim-latex'
	let g:latex_enabled = 1
Plugin 'transvim.vim'
	let g:trv_dictionary="/usr/share/dict/de-en.txt"
Plugin 'altercation/vim-colors-solarized'
Plugin 'edkolev/tmuxline.vim'
Plugin 'bling/vim-airline'
	let g:airline_powerline_fonts = 1
	let g:airline#extensions#branch#enabled = 1
	let g:airline#extensions#whitespace#enabled = 0
	let g:airline#extensions#tmuxline#enabled = 0
	let g:airline_theme = "understated" "nice ones: wombat, murmur and understated
Plugin 'SirVer/ultisnips'
	" Trigger configuration. Do not use <tab> if you use YouCompleteMe.
	let g:UltiSnipsListSnippets="<c-L>"
	let g:UltiSnipsExpandTrigger="<tab>"
	let g:UltiSnipsJumpForwardTrigger="<tab>"
	let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit="vertical"
Plugin 'Sirver/vim-snippets'
Plugin 'vim-pandoc/vim-pandoc-syntax'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

set shell=zsh			" shell to start with
set encoding=utf-8		" set encoding to utf-8
set backspace=indent,eol,start	" allow backspacing over everything in insert mode
set nobackup			" don't make backup files
set history=50			" keep 50 lines of command line history
set laststatus=2		" Always show the statusline (required for powerline)
set noshowmode			" don't show current mode (done by powerline)
set t_Co=256			" tell vim that terminal supports 256 colors (required for powerline)
set ttimeoutlen=50		" shorten pause when leaving insert mode
set ruler			" show the cursor position all the time
set showcmd			" display incomplete commands
set ignorecase			" case insensitive
set smartcase			" if search pattern has uppercase letter, case sensitive, if not c. insensitive
set hlsearch			" highlight all search results	
colorscheme evening
"also nice: tango2, earendel, elflord, blackbeauty breeze, marklar, sean,  caramel, oceanlight, dante, slate
set nocursorline		" disable cursorline with schemes like tango2
syntax on			" Switch Syntax Highlighting on
let g:xml_syntax_folding = 1	" automatic syntax based folding for xml files
"let $PAGER=''			" clear $PAGER for vim
setlocal textwidth=78		" have a default textwidth
set mouse=a			" enable scrolling with mouse (keyboard god, please don't beat me!)

"""" keyboard mappings adapted to bone2 keyboard layout: https://wiki.neo-layout.org/bone2
no j h
no h j
no l k
no k l

"""" other mappings to make life easier
" use tabedit
nmap t :tabedit 
" alias üü to <Esc> key. Handy for people with German keyboard layouts.
inoremap üü <Esc>
vnoremap üü <Esc>
" alias "mm" to :write and "q" to :quit without saving
map mm :w!
map q :q!
" start a new change before doing <c-u> (and be able to undo it with u)
" (wikia/recover from accidental Ctrl-U)
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

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

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  au BufEnter * checktime
augroup END

else
  set autoindent		" always set autoindenting on
endif " has("autocmd")

""""""" Functions
" Toggle NuMode
function! g:ToggleNuMode()
	if(&rnu == 1)
		set nu
	else
		set rnu
	endif
endfunc

" formatoptions toggle
function! ToggleFO ()
   if (&formatoptions == 'tcqwan')
      set formatoptions=tcqwn
      echo "formatoptions -> tcqwn"
   else
      set formatoptions=tcqwan
      echo "formatoptions -> tcqwan"
   endif
endfunction

" Spell Check
let b:myLang=0
let g:myLangList=["nospell","en_gb,de_de","de_de","en_gb"]
function! ToggleSpell()
  let b:myLang=b:myLang+1
  if b:myLang>=len(g:myLangList) | let b:myLang=0 | endif
  if b:myLang==0
    setlocal nospell
  else
    execute "setlocal spell spelllang=".get(g:myLangList, b:myLang)
  endif
  echo "spell checking language:" g:myLangList[b:myLang]
endfunction

" UltiSnips: Use <c-l> to list snippets when not the whole trigger is typed yet
function! ExpandPossibleShorterSnippet()
  if len(UltiSnips#SnippetsInCurrentScope()) == 1 "only one candidate...
    let curr_key = keys(UltiSnips#SnippetsInCurrentScope())[0]
    normal diw
    exe "normal a" . curr_key
    exe "normal a "
    return 1
  endif
  return 0
endfunction
inoremap <silent> <C-l> <C-R>=(ExpandPossibleShorterSnippet() == 0? '': UltiSnips#ExpandSnippet())<CR>

" Different completions mapped to some FN keys
" <F1> (formerly: <c-x><c-L> whole line), now: toggle spell option
	nmap <silent> <F1> :call ToggleSpell()<CR>
" <F2> <c-x><c-T> completion: keywords using thesaurus
	ino <silent> <F2> <c-x><c-t>
	set thesaurus+=/home/jakob/.vim/thesaurus/roget13a.txt
" <F3> <c-x><c-I> completion: keywords in current and included files
	ino <silent> <F3> <c-x><c-i>
" <F4> <c-x><c-O> completion: omni completion
	ino <silent> <F4> <c-x><c-o>
" <F5> toggle relative/absolute linenumbers
	nnoremap <f5> :call g:ToggleNuMode()<CR>
" <F6> saves file  in insert mode
	imap <F6> :w<CR>a
" <F8> toggle formatoptions=a value
	no <F8> :call ToggleFO()<CR>
	ino <F8> :call ToggleFO()<CR>
" <F10> toggle Paste mode
	set pastetoggle=<F10>
" <F12> echo all FN key functions
	ino <silent> <F12>  :echo '[F1:spelltoggle F2:thes F3:keywrd F4:omni - F5:toggle-no/rnu F6:":w" F8:fo-toggle F10:pastetoggle]' <CR>
	no <silent> <F12>  :echo '[F1:spelltoggle F2:thes F3:keywrd F4:omni - F5:toggle-no/rnu F6:":w" F8:fo-toggle F10:pastetoggle]' <CR>
