" set Vim mode instead of pure Vi, it must be the first instruction
set nocompatible

" pathogen, bish
execute pathogen#infect("$HOME/.vim/plugins/{}", "$HOME/.vim/vimrc.d/{}")

" write settings
set confirm " confirm :q in case of unsaved changes
set fileencoding=utf-8 " encoding used when saving file
set nobackup " don't keep the backup~ file

" edit settings
set backspace=indent,eol,start " backspacing over everything in insert mode
set expandtab " fill tabs with spaces
set nojoinspaces " no extra space after '.' when joining lines
set shiftwidth=2 " set indentation depth to 8 columns
set softtabstop=2 " backspacing over 8 spaces like over tabs
set tabstop=2 " set tabulator length to 8 columns
set textwidth=80 " wrap lines automatically at 80th column

" search settings
set hlsearch " highlight search results
set ignorecase " do case insensitive search...
set incsearch " do incremental search
set smartcase " ...unless capital letters are used

" file type specific settings
filetype on " enable file type detection
filetype indent on " automatically indent code
filetype plugin indent on " same for plugins

" syntax highlighting
syntax on
set background=dark " dark background for console

" characters for displaying non-printable characters
set listchars=eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+

" set completion rules
set wildmode=longest:full,full
set wildmenu

" set modeline functionality
set modeline
set modelines=5

" tuning for gVim only
if has('gui_running')
        set background=light " light background for GUI
        set columns=84 lines=48 " GUI window geometry
        set guifont=Monospace\ 12 " font for GUI window
        set number " show line numbers
endif

" automatic commands
if has('autocmd')
        " file type specific automatic commands

        " tuning textwidth for Java code
        autocmd FileType java setlocal textwidth=132
        if has('gui_running')
                autocmd FileType java setlocal columns=136
        endif

        " don't replace Tabs with spaces when editing makefiles
        "
        autocmd Filetype makefile setlocal noexpandtab

        " disable automatic code indentation when editing TeX and XML files
        autocmd FileType tex,xml setlocal indentexpr=

        " clean-up commands that run automatically on write; use with caution

        " delete empty or whitespaces-only lines at the end of file
        autocmd BufWritePre * :%s/\(\s*\n\)\+\%$//ge

        " replace groups of empty or whitespaces-only lines with one empty line
        autocmd BufWritePre * :%s/\(\s*\n\)\{3,}/\r\r/ge

        " delete any trailing whitespaces
        autocmd BufWritePre * :%s/\s\+$//ge
endif

" general key mappings

" center view on the search result
noremap n nzz
noremap N Nzz

" press F9 to turn the search results highlight off
noremap <F9> :nohl<CR>
inoremap <F9> <Esc>:nohl<CR>a

" press F12 to toggle showing the non-printable charactes
noremap <F12> :set list!<CR>
inoremap <F12> <Esc>:set list!<CR>a

" set colorscheme when under wvim
if $WVIM
  colorscheme wvim
  AirlineTheme onedark
endif

" set statusline, airline and syntastic options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" manage the error window
nmap <silent> <Leader>le :Errors<CR>
nmap <silent> <Leader>lc :lclose<CR>

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" shellcheck arguments
let g:syntastic_sh_shellchecker_args = ''

" some utility commands
nmap <silent> <Leader>ze :edit $MYVIMRC<CR>
nmap <silent> <Leader>zs :source $MYVIMRC<CR>:edit <CR>
nmap <silent> <Leader>zt :tabedit $MYVIMRC<CR>

nmap c.<Space> :tabclose<Space>
nmap e.<Space> :tabedit<Space>
nmap n.<Space> :tabnew<Space>

nmap <silent> <Leader>te :tabedit<Return>
nmap <silent> <Leader>tn :tabnew<Return>

nmap <silent> <A-Up> :wincmd k<Return>
nmap <silent> <A-Down> :wincmd j<Return>
nmap <silent> <A-Left> :wincmd h<Return>
nmap <silent> <A-Right> :wincmd l<Return>

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: syntax=%s ",
        \ &syntax)
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)

  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction

nnoremap <silent> <Leader>ml :call AppendModeline()<Return>

Helptags
" vim: syntax=vim
" vim: set ts=2 sw=2 tw=80 et :
