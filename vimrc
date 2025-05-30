" Enable Vim features
set nocompatible

" Use spacebar as the leader key
nnoremap <SPACE> <Nop>
let mapleader="\<Space>"

" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/dharmab/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" BEGIN VIM-PLUG CONFIG
call plug#begin('~/.vim/plugged')

" Base16 colorscheme
Plug 'chriskempson/base16-vim'

" Syntax checking
" Install developer tools for syntax checking: https://github.com/dense-analysis/ale/blob/master/supported-tools.md
" Install flake8 for Python PEP8
Plug 'dense-analysis/ale'

" YouCompleteMe completions
Plug 'ycm-core/YouCompleteMe', {'do': './install.py --clang-completer --go-completer'}

" GitHub Copilot
Plug 'github/copilot.vim'

" File tree
" Use :NERDTree to open the tree
Plug 'preservim/nerdtree'

" Fancy statusbar
" Powerline fonts recommended
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'

" Git integration
Plug 'tpope/vim-fugitive'

" CtrlP fuzzy search
" Use Ctrl+P to search a project for a file
Plug 'ctrlpvim/ctrlp.vim'

" Ansible syntax and indentation
Plug 'chase/vim-ansible-yaml'

" Go syntax and features
Plug 'fatih/vim-go'

" Generic log file syntax
Plug 'dzeban/vim-log-syntax'

" Automatically close parentheses, etc.
Plug 'Raimondi/delimitMate'

" General comment management
" <leader>c<space> to toggle comments
Plug 'preservim/nerdcommenter'

" Markdown Preview
" Use :MarkdownPreview while editing Markdown to open a live preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Highlight trailing whitespace
" Use :StripWhitespace to remove trailing shitespace
Plug 'ntpeters/vim-better-whitespace'

" Jump around Vimium-style
" Use Leader-Leader-Motion <target> to jump around
Plug 'easymotion/vim-easymotion'

" Automatically detect indentation settings
Plug 'tpope/vim-sleuth'

" Ripgrep code search
" Use :Rg '<search term>' to search a codebase
Plug 'dharmab/vim-ripgrep'

" Better JSON
Plug 'elzr/vim-json'
Plug 'rhysd/vim-fixjson'

" Jsonnet syntax highlighting and autoformatting
Plug 'google/vim-jsonnet'

" Terraform highlighting
Plug 'hashivim/vim-terraform'

call plug#end()
filetype plugin indent on
" END VUNDLE CONFIG

" Color scheme
" Requires https://github.com/chriskempson/base16-shell
if exists('$BASE16_THEME') && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif
syntax on

" Unicode, because this is the future
set encoding=utf-8

" Sane defaults for indentation
set tabstop=4
autocmd Filetype go setlocal tabstop=4

" Show line numbers
set number

" Fix backspace on macOS
set backspace=indent,eol,start

" Highlight current line
set cursorline

" Highlight columns 80 and 120
set colorcolumn=80,120

" Allow mouse
set mouse=a

" Wrap searches
set wrapscan

" Smart search case sensitivity
" Searches are case insensitive unless an uppercase character appears
set ignorecase
set smartcase

" Show completions when using commands like :edit
set wildmenu

" Allow switching buffer even if current buffer contains unsaved changes
set hidden

" Disable scratch preview window
set completeopt-=preview

" Use Alt+hjkl to switch between windows
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-l> :wincmd l<CR>

" Use Ctrl+c to copy selection to clipboard
" Note that this is still Ctrl+c on macOS
vmap <C-c> "*y

" Disable some useless commands
cnoreabbrev X x
cnoreabbrev W w
map Q <Nop>

" Airline tweaks
let g:airline_theme = 'dark_minimal'
" Always show statusline
set laststatus=2
" Use Powerline fonts
let g:airline_powerline_fonts = 1
" Don't show file encoding
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1
" Enable ALE integration
let g:airline#extensions#ale#enabled = 1

" CtrlP tweaks
" Ignore certain directories and filetypes
set wildignore+=*/.git/*,*/.mypy_cache/*,*.pyc,*/vendor/*,,*/.terraform/*,*/.DS_Store
" Include hidden files
let g:ctrlp_show_hidden = 1
" Keybinds
let g:ctrlp_map = '<c-p>'  " Why is CtrlP not bound to Ctrl+p by default?
let g:ctrlp_cmd = 'CtrlP'

" Command to open browser for Markdown Preview
let g:previm_open_cmd = 'chromium'  " Consider xdg-open (Linux) or open (macOS)

" YouCompleteMe tweaks
let g:ycm_python_binary_path='python'
cnoreabbrev ycm YcmCompleter
map q :YcmCompleter GetDoc <CR>

" ALE tweaks
" Disable the deprecated and overly opinioned golint linter
let g:ale_linters = {'go': ['gometalinter', 'gofmt']}
" Don't check for long lines in Python files
let g:ale_python_flake8_options='--ignore=E501'
" Don't use mypy for Python syntax checks (already covered by flake8)
let g:ale_python_mypy_ignore_invalid_syntax=1
" Don't check for non-constant source in Shell files
let g:ale_sh_shellcheck_options='--exclude SC1090'
" Tweak appearance
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '--'
let g:ale_echo_msg_warning_str = 'Warning'
let g:ale_echo_msg_error_str = 'Error'
let g:ale_echo_msg_format = '%severity%: %s (%linter% %code%)'
" Disable the quickfix window (since we're using it for other stuff like
" ripgrep)
let g:ale_set_quickfix = 0

" Python tweaks
" Don't autoindent in Python when typing a colon
autocmd FileType python setlocal indentkeys-=<:>
autocmd FileType python setlocal indentkeys-=:

" Go tweaks
let g:go_metalinter_command = "gopls"
let g:go_metalinter_autosave = 1
" Disable vim-go completion (using YCM instead)
let g:go_code_completion_enabled = 1
" Disable hello world template in new files
let g:go_template_autocreate = 0

" JSON tweaks
" High contrast colors (dark theme assumed)
highlight jsonKeyword ctermfg=Blue
highlight jsonString ctermfg=Yellow
highlight jsonNumber ctermfg=Red
highlight jsonBoolean ctermfg=Red
highlight jsonNull ctermfg=Red

" Terraform tweaks
let g:terraform_fmt_on_save=1

" Remove annoying commands
augroup deleteAnnoyingCommands
    autocmd!
    autocmd VimEnter * delcommand Sexplore
    autocmd VimEnter * delcommand Sleuth
augroup END

" Allow limited project-specific vim configuration
set exrc
set secure
