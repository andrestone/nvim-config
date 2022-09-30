set termguicolors
" Pythons and Perls
let g:python_host_prog = '/home/andre/.pyenv/versions/py2nvim/bin/python2' 
let g:python3_host_prog = '/Users/andre/.pyenv/versions/py3nvim/bin/python3' 
let g:loaded_perl_provider = 0


" Plugins
call plug#begin('~/.vim/plugged')

" Completion and LSP features
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-emoji',
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'ray-x/lsp_signature.nvim'
Plug 'windwp/nvim-ts-autotag'

" Formatting & Linting
Plug 'sbdchd/neoformat'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Snippets and shortcuts
Plug 'windwp/nvim-autopairs'
Plug 'rafamadriz/friendly-snippets'
Plug 'tpope/vim-commentary'
Plug 'github/copilot.vim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Navigation
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'APZelos/blamer.nvim'
Plug 'sindrets/diffview.nvim'

" Visuals
Plug 'gruvbox-community/gruvbox'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'SmiteshP/nvim-navic'

Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-markdown'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'dracula/vim', { 'as': 'dracula' }

" Xcode replacement finally?
Plug 'xbase-lab/xbase', { 'do': 'make install' }

" Jupyter notebooks
Plug 'untitled-ai/jupyter_ascending.vim'

call plug#end()

nmap <leader><leader>x <Plug>JupyterExecute
nmap <leader><leader>X <Plug>JupyterExecuteAll

if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

" Load lua configs
lua require('andrestone')

" Set nohlsearch
set nohlsearch

" Copy / Paste
vnoremap <C-c> "+y
nmap <C-v> "+p

" Mouse
set mouse=nv

" Color
colo gruvbox
let g:gruvbox_contrast_dark = 'hard'
set background=dark
hi Normal guifg=#ded8c8 guibg=#1c1b1b
hi GruvboxPurple guifg=#987699
hi ColorColumn guibg=#212121

" Relative number
set number relativenumber nuw=1

" Ignorecase / smartcase
set ignorecase smartcase

" Autocompletion (shell)
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

" Split window opens below and to the right (not the opposite)
set splitbelow splitright

" Airline to use powerline fonts 
let g:airline_powerline_fonts = 1

" Leader key
let mapleader = " "

" Spell check
nmap <leader>o :setlocal spell!<CR>

" NerdTREE
map <silent><C-n> :NERDTreeToggle<CR>
map <silent><leader><C-n> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1

" UndoTREE
nnoremap <leader>u :UndotreeToggle<CR>

function! WindowLeft()
    if (&buftype != "nofile")
      execute "normal! :set wfw!\<CR>"
      execute "normal! \<C-w>h"
      if (&buftype != "nofile")
        execute "normal! :vertical resize 126\<CR>:set wfw\<CR>\<C-w>=0"
      endif
    else
      execute "normal! :set wfw\<CR>"
    endif
endfunction


" This is my old window management (inside vim). I actually sometimes use it
" still.
function! WindowRight()
    if (&buftype != "nofile")
      execute "normal! :set wfw!\<CR>"
      execute "normal! \<C-w>l"
      if (&buftype != "nofile")
        execute "normal! :vertical resize 126\<CR>:set wfw\<CR>\<C-w>=0"
      endif
    else
      execute "normal! :set wfw\<CR>"
      execute "normal! \<C-w>l"
      if (&buftype != "nofile")
        execute "normal! :NERDTreeToggle\<CR>"
      endif
    endif
endfunction

" Window Navigation
tnoremap <silent><C-j> <C-w>N:resize 16<CR>a
tnoremap <silent><C-k> <C-w>N:resize 3<CR>a<C-w>k
tnoremap <silent><C-h> <C-w>N:resize 3<CR>a<C-w>k<C-w>h
tnoremap <silent><C-l> <C-w>N:resize 3<CR>a<C-w>k<C-w>l
nnoremap <C-h> :call WindowLeft()<CR>
nnoremap <C-l> :call WindowRight()<CR>
nnoremap <silent><C-j> <C-W>j
nnoremap <silent><C-k> <C-W>k
nnoremap <leader><C-o> <C-w>x
nnoremap <leader><C-l> gt
nnoremap <leader><C-h> gT
nnoremap ≥ <C-W>>
nnoremap ≤ <C-W><lt>
" nnoremap <M-,> <C-W>-
" nnoremap <M-.> <C-w>+

" git blamer
nmap <leader>gb :BlamerToggle<CR>
let g:blamer_template = '<author>, <committer-time> • <summary>'

" commenting
inoremap /**<CR> /**<CR> *<CR>*/<Esc>kA 
nmap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('CommentaryLine')
xmap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('Commentary')
omap <expr> <C-_> v:lua.context_commentstring.update_commentstring_and_run('Commentary')
" xmap <C-_> <Plug>Commentary
" nmap <C-_> <Plug>Commentary
" omap <C-_> <Plug>Commentary
" nmap <C-_> <Plug>CommentaryLine

" wrapping text with
vnoremap <leader>{ di{}<ESC>hp
vnoremap <leader>` di``<ESC>hp
vnoremap <leader>[ di[]<ESC>hp
vnoremap <leader>( di()<ESC>hp
vnoremap <leader>" di""<ESC>hp
vnoremap <leader>' di''<ESC>hp
vnoremap <leader>~ di~~<ESC>hp
vnoremap <leader>/* di/*<CR>*/<ESC>kp

" e-regex searches
:nnoremap / /\v
:cnoremap s/ s/\v

" no errorbells
set noerrorbells

" backup swap undo
set backupdir=~/.vim-dirs/backup//
set directory=~/.vim-dirs/swap//
set undodir=~/.vim-dirs/undo//

" no wrap / colorcolumn
set nowrap
set colorcolumn=120
nnoremap <leader>in :IndentGuidesToggle<CR>

" Reading Podfiles as Ruby files
autocmd BufNewFile,BufRead Podfile set filetype=ruby
autocmd BufNewFile,BufRead *.podspec set filetype=ruby

" Close quickfix after selecting item
" autocmd FileType qf nnoremap <buffer> <CR> <CR>:cclose<CR>

" Automatically restore to last read line
autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

" fixing tab
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" Disable auto-commenting new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" hide buffers instead of closing them
set hidden

" Debugging syntax highlighting
nnoremap <leader>f1 :echo synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>
nnoremap <leader>f2 :echo ("hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">")<cr>
nnoremap <leader>f3 :echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')<cr>
nnoremap <leader>f4 :exec 'syn list '.synIDattr(synID(line('.'), col('.'), 0), 'name')<cr>

" matchit
packadd! matchit

" copilot
imap <silent><script><expr> <C-J> copilot#Accept("\<C-N>")
let g:copilot_no_tab_map = v:true

" alternative auto change dir (autochdir)
" set autochdir
nnoremap <leader>cd :cd %:h<CR>:pwd<CR>

" markdown syntax highlighting
au BufNewFile,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ts=typescript', 'typescript', 'js=javascript', 'javascript']

" Jump forward or backward
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Load helps
packloadall
silent! helptags ALL
filetype plugin indent on
