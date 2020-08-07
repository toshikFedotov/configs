set number
set autoindent
set smartindent
set smarttab
set ignorecase
set incsearch
set expandtab
set hls!
set directory=$HOME/.vim/swapfiles//
set nowrap
set foldmethod=indent
set cursorline

set autochdir

set shiftwidth =4
set softtabstop=4
set tabstop    =4

map <F2> :tabnew<CR>
map <F4> :tabn<CR>
map <F3> :tabp<CR>
map GY "+y

imap ;om $Kernel::OM->Get('Kernel::System::')<Left><Left>
imap ;err $Kernel::OM->Get('Kernel::System::Log')->Log(<CR>Priority => 'error',<CR>Message  => '',<CR>);<Up><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right><Right>
imap ;dmp use Data::Dumper; $Data::Dumper::Sortkeys = 1;<CR>print STDERR Dumper ;<Left>

" kill spaces
autocmd BufWritePre *.pl,*.t,*.pm,*.c,*.cpp,*.js,*.ts,*.java,*.php,*.sql %s/\s\+$//e
autocmd BufReadPre *.ts,*.js call TabEq2()
autocmd BufNewFile *.pl :call NewPerlScript()

map M! :call TabEq2()<CR>
map M@ :call TabEq4()<CR>

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

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

call plug#begin('~/.vim/plugged')

Plug 'gryf/wombat256grf'
Plug 'endel/vim-github-colorscheme'
Plug 'junegunn/vim-easy-align'
Plug 'ycm-core/YouCompleteMe'
Plug 'tpope/vim-eunuch'

call plug#end()

colorscheme github

function! NewPerlScript()

    call setline( line('$'), '#!/usr/bin/env perl' )
    call append( line('$'), ['', 'use strict;'] )
    call append( line('$'), [ 'use warnings;','','' ] )

    call cursor( line('$'), 0 )

    call feedkeys('i')
endfunction
