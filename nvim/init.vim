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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & npm install'  }
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips'
Plug 'junegunn/vim-easy-align'    " align lines around = sign, etc
Plug 'scrooloose/nerdtree',       " filetree viewer thing
Plug 'tpope/vim-fugitive' " git integration
Plug 'tpope/vim-surround'         " cs([ changes ( to ' around current thing
Plug 'tpope/vim-abolish'          " change fooBar to foo_bar, case insensitive :s
Plug 'tpope/vim-sensible'         " default shit
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Yggdroot/indentLine'
" Plug 'jiangmiao/auto-pairs'
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

" Plug 'scrooloose/nerdcommenter'
" Plug 'alvan/vim-closetag'

call plug#end()
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Coc plugins
function! CocInstallAll()
    CocInstall
        \ coc-ultisnips
        \ coc-yank
        \ coc-git
        \ coc-highlight
        \ coc-eslint
        \ coc-prettier
        \ coc-tabnine
        \ coc-css
        \ coc-python
        \ coc-json
        \ coc-rls
endfunction



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
let $FZF_DEFAULT_OPTS='--layout=reverse'
" Using the custom window creation function
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
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
" file finder mapping
nmap <c-p> :<c-u>ProjectRootExe Files<CR>
" general code finder in all files mapping
nmap <c-g> :<c-u>ProjectRootExe Rg<CR>
" commands finder mapping
nmap <leader>c :Commands<CR>
" Files command with preview window
" let $FZF_DEFAULT_OPTS='--layout=reverse'
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('down:70%'), <bang>0)

" Ripgrep setting with preview window
command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --column --no-heading --fixed-strings --line-number --smart-case '.shellescape(<q-args>), 1,
      \   fzf#vim#with_preview({'options': '--delimiter : --nth 4.. -e'}, 'down:70%'),
      \   <bang>0)

autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>
autocmd! FileType fzf tunmap <buffer> <c-s>

let g:fzf_action = {
  \ 'ctrl-o': 'edit',
  \ 'ctrl-s': 'split',
  \ 'enter': 'vsplit' }

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

"" coc-vim {
" set cmdheight=2
set nobackup
set nowritebackup
set updatetime=300
set shortmess+=c
set signcolumn=yes

inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>":
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.')-1
    return !col || getline('.')[col - 1]=~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.

xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
""}

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
nnoremap j gj
nnoremap k gk
noremap <C-s> :wall<CR>
nmap <silent> <leader><leader> :noh<CR>
nnoremap <leader>l :ls<cr>:b<space>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Bindings to edit/reload vimrc
nmap <silent> <leader>C :e $MYVIMRC<CR>

nmap <leader>q :NERDTreeToggle<CR>
nmap <leader>f :FZF<CR>
nmap \ <leader>q
nmap <C-\> :NERDTreeFind<CR>
nmap <leader>g :Goyo<CR>
" nmap <Tab> :bnext<CR>
" nmap <S-Tab> :bprevious<CR>
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
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
""" Filetype specific stuff
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
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
