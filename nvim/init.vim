" TODO add rust support to codi with runner

" clear autocommands
autocmd!

" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Plugin Manager
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()


" Aesthetics - Main
Plug 'dracula/vim', { 'commit': '147f389f4275cec4ef43ebc25e2011c57b45cc00' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/vim-journal'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'nightsense/forgotten'
Plug 'zaki/zazen'

" Aethetics - Additional
Plug 'nightsense/nemo'
Plug 'yuttie/hydrangea-vim'
Plug 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
Plug 'rhysd/vim-color-spring-night'

Plug 'dkarter/bullets.vim'
Plug 'metakirby5/codi.vim'
Plug 'dense-analysis/ale'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'junegunn/vim-easy-align'    " align lines around = sign, etc
Plug 'scrooloose/nerdtree',       " filetree viewer thing
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-surround'         " cs([ changes ( to ' around current thing
Plug 'tpope/vim-abolish'          " change fooBar to foo_bar, case insensitive :s
Plug 'tpope/vim-sensible'         " default shit
Plug 'Yggdroot/indentLine'
Plug 'dbakker/vim-projectroot'

Plug 'godlygeek/tabular'          " another alignment thing
Plug 'vim-syntastic/syntastic'    " syntax checking
Plug 'Shougo/vimproc.vim',        " asynchronus execution
    \ { 'do' : 'make' }

Plug 'tpope/vim-repeat'           " makes . repeat work with plugin commands
Plug 'tpope/vim-commentary'       " gc comment binding
Plug 'hankchiutw/nerdtree-ranger.vim'
Plug 'tpope/vim-unimpaired'       " ]b, [b, etc mappings
Plug 'lervag/vimtex',             " latex plugin
    \ { 'for' : 'latex' }
Plug 'benmills/vimux'             " tmux integration
Plug 'salsifis/vim-transpose'     " swap rows/columns in text array
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rust-lang/rust.vim'
Plug 'alvan/vim-closetag'   " autoclose html tags

"" Text objects
Plug 'kana/vim-textobj-user' " library
Plug 'pianohacker/vim-textobj-variable-segment' " av/iv
Plug 'sgur/vim-textobj-parameter' " a,/i,
Plug 'Julian/vim-textobj-brace' " aj/ij
Plug 'deathlyfrantic/vim-textobj-blanklines' " a<Space>/i<Space>
Plug 'kana/vim-textobj-line' " al/il
Plug 'kana/vim-textobj-indent' " ai/ii/aI/iI
Plug 'glts/vim-textobj-comment' " ac/ic

call plug#end()
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Plugin Options
"" vim-easy-align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
vmap ga <Plug>(EasyAlign)

"" syntastic
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"" NERDTree
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '↠'
let g:NERDTreeDirArrowCollapsible = '↡'

"" Airline
let g:airline_powerline_fonts = 1
let g:airline_section_z = ' %{strftime("%-I:%M %p")}'
let g:airline_section_warning = ''

"" fzf
" Reverse the layout to make the FZF list top-down
" let $FZF_DEFAULT_OPTS='--layout=reverse --ansi --preview (highlight -O ansi -l {} 2>/dev/null || bat {} || tree -C {}) 2>/dev/null'
" let $FZF_DEFAULT_OPTS='--layout=reverse'
" Using the custom window creation function
" let g:fzf_layout = { 'window': 'call FloatingFZF()' }
let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'down': '~50%' }
" Function to create the custom floating window
function! FloatingFZF()
  " creates a scratch, unlisted, new, empty, unnamed buffer
  " to be used in the floating window
  let buf = nvim_create_buf(v:false, v:true)
  " 90% of the height
  let height = float2nr(&lines * 0.9)
  " 60% of the width
  let width = float2nr(&columns * 0.6)
  " horizontal position (centralized)
  let horizontal = float2nr((&columns - width) / 2)
  " vertical position (one line down of the top)
  let vertical = 1
  let opts = {
        \ 'relative': 'editor',
        \ 'row': vertical,
        \ 'col': horizontal,
        \ 'width': width,
        \ 'height': height,
        \ }
  " open the new window, floating, and enter to it
  call nvim_open_win(buf, v:true, opts)
endfunction


" Files command with preview window
" let $FZF_DEFAULT_OPTS='--layout=reverse'
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('up:70%'), <bang>0)
command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('up:70%'), <bang>0)

" Ripgrep setting with preview window
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --no-heading --fixed-strings --line-number --smart-case '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'up:70%'),
      \   <bang>0)


let g:fzf_action = {
  \ 'ctrl-q': 'aboveleft vsplit',
  \ 'ctrl-w': 'belowright split',
  \ 'ctrl-e': 'aboveleft split',
  \ 'ctrl-r': 'belowright vsplit',
  \ 'enter': 'edit' }
autocmd FileType fzf tnoremap <buffer> <C-s>h <C-q>
autocmd FileType fzf tnoremap <buffer> <C-s>j <C-w>
autocmd FileType fzf tnoremap <buffer> <C-s>k <C-e>
autocmd FileType fzf tnoremap <buffer> <C-s>l <C-r>

"" Codi
function! CodiScratchpad()
    let coditype=&filetype
    call FloatingFZF()
    execute 'Codi' coditype
endfunction

nmap <leader>s :call CodiScratchpad()<CR>

"" Deoplete
let g:deoplete#enable_at_startup = 1
" Disable documentation window
set completeopt-=preview

"" indentLine
let g:indentLine_char = '▏'
let g:indentLine_color_gui = '#363949'

"" ale
let g:ale_fixers = {
            \ 'javascript' : ['eslint']
            \ }
let g:ale_fix_on_save = 1

" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Coloring
syntax on
color dracula
highlight Pmenu guibg=NONE ctermbg=NONE
highlight Comment gui=bold
highlight Normal guibg=NONE ctermbg=NONE
highlight LineNr guibg=NONE ctermbg=NONE
highlight NonText guibg=none
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Misc options
set nocompatible
set background=dark
set showcmd    " Show (partial) command in status line.
set showmatch  " Show matching brackets.
set ignorecase " Do case insensitive matching
set smartcase  " Do smart case matching
set autowrite  " Automatically save before commands like :next and :make
set hidden     " Hide buffers when they are abandoned
" set mouse=a    " Enable mouse usage (all modes)
" set mousefocus " This only works in gvim
set wrap breakindent linebreak
set nu rnu
set expandtab tabstop=4 shiftwidth=4 softtabstop=4 shiftround " Tab stuff
set wildignore=*swp,*.pyc,*.class,*.hi,*.o " Ignore dumb files
set splitbelow splitright
set title
" set list listchars=trail:»,tab:»- " Visible whitespace
" set fillchars+=vert:\ 
set clipboard=unnamedplus
set secure
set nomodeline
set hidden
set undodir^=~/.config/nvim/tmp/
set backupdir^=~/.config/nvim/tmp/
set directory^=~/.config/nvim/tmp/
" set nobackup
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Bindings

let mapleader=","

noremap Q @q
" nnoremap j gj
" nnoremap k gk
nnoremap <C-s> :wall<CR>
nmap <silent> <leader><leader> :noh<CR>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Bindings to edit/reload vimrc
nmap <silent> <leader>C :e $MYVIMRC<CR>

nmap <silent> <C-S-o> \<C-i>
tnoremap <Esc> <C-\><C-n>
autocmd FileType fzf tnoremap <buffer> <esc> <c-c>
nmap <silent> <leader>r :below split<CR><Esc>:term<CR>A
nmap <silent> <leader>G :Goyo<CR>
nmap <silent> <leader>f :<c-u>ProjectRootExe GFiles<CR>
nmap <silent> <leader>g :<c-u>ProjectRootExe Rg<CR>
nmap <silent> <leader>b :<c-u>Buffers<CR>
nmap <silent> <leader>t :<c-u>Tags<CR>
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Custom Functions
" Trim Whitespaces
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

autocmd BufWritePre * call TrimWhitespace()

function! FormatJSON()
    :%!python -m json.tool<CR>
endfunction

function! PlugPaste()
   :normal ] jp0df/.iPlug 'A'0<CR>
endfunction
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Filetype specific stuff

"" Help
autocmd FileType help map <buffer> <ESC> :close<CR>

"" Terminal
autocmd TermOpen * setlocal nonumber norelativenumber

"" Haskell
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"" Make
autocmd FileType make setlocal noexpandtab

"" LaTeX
autocmd FileType tex setlocal sw=2 iskeyword+=: tw=80

"" HTML
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType xml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2 softtabstop=2

"" Config files
autocmd BufWritePost ~/*/qutebrowser/config.py silent !qutebrowser :config-source
autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %
autocmd BufWritePost ~/*/i3/config silent !i3-msg reload
autocmd BufReadPost ~/*/polybar/config silent setlocal ft=dosini
autocmd BufWritePost ~/*/polybar/config silent !polybar -r
autocmd BufWritePost $MYVIMRC silent :so $MYVIMRC
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" TODO
" ranger integration?
" tmux integration
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" jumps to previous position when opening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
