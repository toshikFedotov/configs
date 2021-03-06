"----------------------------------------"
" Autoload plugin manager
"----------------------------------------"
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"----------------------------------------"
" Setup plugins
"----------------------------------------"
call plug#begin('~/.vim/plugged')
Plug 'SirVer/ultisnips'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'akretion/vim-odoo-snippets'
Plug 'bronson/vim-trailing-whitespace'
Plug 'chrisbra/csv.vim'
Plug 'gryf/wombat256grf'
Plug 'heavenshell/vim-jsdoc', {
            \ 'for': ['javascript', 'javascript.jsx','typescript'],
            \ 'do': 'make install' }
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jelera/vim-javascript-syntax'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/vim-easy-align'
Plug 'mattn/emmet-vim'
Plug 'mhartington/vim-angular2-snippets'
Plug 'mtdl9/vim-log-highlighting'
Plug 'pearofducks/ansible-vim'
Plug 'plasticboy/vim-markdown'
Plug 'preservim/nerdtree'
Plug 'prettier/vim-prettier'
Plug 'rakr/vim-one'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-perl/vim-perl'
Plug 'vim-syntastic/syntastic'
Plug 'ycm-core/YouCompleteMe'
Plug 'yko/mojo.vim'
Plug 'zefei/simple-dark'
call plug#end()
"----------------------------------------"
" Helpers declaration
"----------------------------------------"
function SetupPerlSettings()
  imap ;ddp use DDP; p ;<Left>
endfunction

" Run tidyall on the current buffer. If an error occurs, show it and leave it
" in tidyall.ERR, and undo any changes.
command! TidyAll :call TidyAll()
function! TidyAll()
    let cur_pos = getpos( '.' )
    let cmdline = ':1,$!tidyall --mode editor --pipe %:p 2> tidyall.ERR'
    execute( cmdline )
    if v:shell_error
        echo "\nContents of tidyall.ERR:\n\n" . system( 'cat tidyall.ERR' )
        silent undo
    endif
    call system( 'rm tidyall.ERR' )
    call setpos( '.', cur_pos )
endfunction
map <leader>t :TidyAll<cr>

function SetupOtrsHotkeys()
  call SetupPerlSettings()
  imap ;om otrs-om;;
  imap ;err otrs-error;;
  let g:syntastic_perl_checkers       = ['perl']
endfunction

function SetupPhpHotkeys()
  imap ;dmp var_dump();<Left><Left>
endfunction

function! TabEq2()
  set shiftwidth =2
  set softtabstop=2
  set tabstop    =2
endfunction

function! TabEq4()
  set shiftwidth =4
  set softtabstop=4
  set tabstop    =4
endfunction

function! NewPerlScript()
  call setline( line('$'), '#!/usr/bin/env perl' )
  call append( line('$'), ['', 'use strict;'] )
  call append( line('$'), [ 'use warnings;' ] )
  call append( line('$'), [ 'use v5.30;', '', '' ] )
  call cursor( line('$'), 0 )
  call feedkeys('i')
endfunction

" otrs open files by using short monikers
function! OtrsFile(file_moniker)
  let l:path = '/opt/otrs/' . a:file_moniker

  for moniker in keys(g:otrs_short_monikers)
    if l:path =~ moniker
      let l:path = substitute(l:path, moniker, g:otrs_short_monikers[moniker], "g")
    endif
  endfor

  if l:path !~ '\.\w\+$'
    let l:path .= ".pm"
  endif

  let l:path = substitute(l:path, '/\(\w\+\)\(\.\w\+\)', '/\u\1\2', '')

  execute "e " . l:path
endfunction
"----------------------------------------"
" Some in-vim settings
"----------------------------------------"
set number
set autoindent
set smartindent
set smarttab
set ignorecase
set incsearch
set expandtab
set hls!
set directory   =/tmp//
set nowrap
set foldmethod  =indent
set cursorline
set autochdir
set hlsearch
set shiftwidth  =2
set softtabstop =2
set tabstop     =2
set foldlevel   =10
set laststatus  =2
"----------------------------------------"
" Hotkeys
"----------------------------------------"
nmap <F2> :tabnew<CR>
nmap <F4> :tabn<CR>
nmap <F3> :tabp<CR>
xmap GY "+y
nmap GP "+p
nmap M! :call TabEq2()<CR>
nmap M@ :call TabEq4()<CR>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap gb :Git blame<CR>
nmap <F12> :syntax sync fromstart<CR>
nmap J 6<C-E>
nmap K 6<C-Y>
nmap G> 50<C-w>>
nmap G< 50<C-w><
nmap go :call OtrsFile("c:k:s:")<Left><Left>
nmap gd :YcmCompleter GoToDefinition<CR>
nmap gjs :JsDoc<CR>
xmap gjs :JsDoc<CR>
nmap C :set paste!<CR>
"----------------------------------------"
" Auto-execution
"----------------------------------------"
autocmd BufWritePre *.pl,*.t,*.pm,*.c,*.cpp,*.js,*.ts,*.java,*.php,*.sql FixWhitespace
autocmd BufReadPre *.ts call TabEq2()
autocmd BufNewFile *.pl :call NewPerlScript()
autocmd BufReadPre /opt/otrs/*.pm,/opt/otrs/*.pl,/opt/otrs/*.t call SetupOtrsHotkeys()
autocmd BufReadPre *.pm,*.pl,*.t :call SetupPerlSettings()
autocmd BufReadPre *.php call SetupPhpHotkeys()
autocmd BufNewFile,BufRead *.tt setf tt2
autocmd BufReadPre /opt/otrs/* call TabEq4()
autocmd BufReadPre *.log.?* se syntax=log
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | wincmd p | ene | exe 'NERDTree' argv()[0] | endif
autocmd BufWritePost * GitGutter
autocmd BufReadPost * GitGutter
autocmd BufReadPost *.xml call TabEq4()
autocmd BufReadPost *.js call TabEq4()

autocmd BufReadPre */billparser/*.py let g:syntastic_python_checkers = ['python']
"----------------------------------------"
" Variables for plugin's settings
"----------------------------------------"
let g:ycm_autoclose_preview_window_after_completion = 1
let g:perl_sub_signatures = 1

let g:otrs_short_monikers = {'c:': 'Custom/', 'k:': 'Kernel/', 's:':'System/', 'm:':'Modules/', 't:': 'Ticket/' }
let g:gitgutter_async = 0

"----------------------------------------
" UltiSnips
"----------------------------------------
let g:UltiSnipsExpandTrigger=";;"
let g:UltiSnipsJumpForwardTrigger=";p"
let g:UltiSnipsJumpBackwardTrigger=";."
"----------------------------------------
" Syntastic
"----------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = { 'passive_filetypes': ['rust']  }

let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_python_exec = 'python3'

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 1
let g:syntastic_quiet_messages           = { "type": "style"  }

let g:syntastic_perl_lib_path       = [ '/opt/otrs/', '/opt/otrs/Custom/', '/opt/otrs/Kernel/cpan-lib/' ]
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers       = ['perltidy']
"----------------------------------------
" CSV
"----------------------------------------
let g:csv_delim = ','
"----------------------------------------
" Emmet
"----------------------------------------
let g:user_emmet_leader_key=','
"----------------------------------------
" Setup colors
"----------------------------------------
hi Search ctermbg=LightYellow
hi Search ctermfg=Red
hi Pmenu ctermfg=15 ctermbg=0
colorscheme simple-dark
"fix bg color in kitty
let &t_ut=''
