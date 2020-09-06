call plug#begin('~/.local/share/nvim/plugged')
Plug 'zhaocai/goldenview.vim' " autoresize panes
Plug 'othree/yajs.vim' " js syntax highlight
Plug 'mxw/vim-jsx' " jsx syntax
Plug 'mhartington/oceanic-next' "theme
" Plug 'dense-analysis/ale' "lint engine
Plug 'arthurxavierx/vim-caser' "switch case (kebab, camel, etc)
Plug 'epilande/vim-es2015-snippets'
Plug 'epilande/vim-react-snippets'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
" Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ctrlpvim/ctrlp.vim' " TODO: remap and remove
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' } " code navigation -- map this!
Plug 'tomtom/tcomment_vim'
Plug 'othree/es.next.syntax.vim'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'wakatime/vim-wakatime'
Plug 'luochen1990/rainbow'
" Plug 'mattn/emmet-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-obsession'
Plug 'svermeulen/vim-easyclip'
Plug 'tpope/vim-repeat' " HERE
Plug 'vim-scripts/grep.vim'
Plug 'mhinz/vim-grepper'
Plug 'tomarrell/vim-npr'
Plug 'chrisbra/unicode.vim'
Plug 'blueyed/vim-diminactive'
Plug 'tpope/vim-dispatch'
Plug 'radenling/vim-dispatch-neovim'
Plug 'tpope/vim-unimpaired'
Plug 'janko/vim-test'
Plug 'craigdallimore/vim-jest-cli', { 'for': 'javascript' }
Plug 'dhruvasagar/vim-prosession'
Plug 'chaoren/vim-wordmotion'
Plug 'elentok/plaintasks.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'junegunn/vim-emoji'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/limelight.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'jacquesbh/vim-showmarks'
Plug 'mox-mox/vim-localsearch'
Plug 'jrudess/vim-foldtext'
Plug 'metakirby5/codi.vim'
Plug 'mcchrish/nnn.vim'
Plug 'bogado/file-line'
call plug#end()

" General configuration -------------------------------------------------------
" set shell=zsh\ -i
set nocompatible
filetype plugin indent on
set nu rnu
set ruler
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<
" set spell
" set spelllang=en_us
set hlsearch
set incsearch
set autoindent
set smartindent
set showcmd
set backupdir=$TEMP//
set directory=$TEMP//
set nobackup
set nowritebackup
set guifont=Fira\ Code:h13
" set macligatures
set linespace=5
set encoding=UTF-8
set ic

" Fugitive (Diff for resolve conflicts) ---------------------------------------
set diffopt+=vertical

" airline
set laststatus=2

" Use 256 colors
set t_Co=256

let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#localsearch#enabled=1
let g:airline_theme='jellybeans'

let g:airline_section_x=' %{ObsessionStatus(">","||")}'
let g:airline_section_y=''
let g:airline_inactive_collapse=1
let g:airline_skip_empty_sections = 1

let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

"FZF Configuration -----------------------------------------------------------
nnoremap <F2> :FZF<CR>
nnoremap ,e :call fzf#vim#gitfiles('', fzf#vim#with_preview('right'))<CR>

" CtrlP Configuration
" ---------------------------------------------------------
"
" to search in the current open buffers
nnoremap ,b :CtrlPBuffer<CR>
" to search listing all tags
nnoremap ,t :CtrlPBufTag<CR>
" to search through the current file's lines
nnoremap ,l :CtrlPLine<CR>
" to search listing all Most-Recently-Used file.
nnoremap ,r :CtrlPMRUFiles<CR>

" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction

" CtrlP with default text
nnoremap ,wg :call CtrlPWithSearchText(expand('<cword>'),'BufTag')<CR>
nnoremap ,wf :call CtrlPWithSearchText(expand('<cword>'),'Line')<CR>
nnoremap ,d ,wg
nnoremap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nnoremap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>

" Don't change working directory
let g:ctrlp_working_path_mode = 0

" Ignore this files/dirs
let g:ctrlp_custom_ignore = {
                   \ 'dir': '\v[\/](\.git|\.hg|\.svn|node_modules|.history)$',
                   \ 'file': '\.pyc$\|\.pyo$',
                   \ }

" Update the search once the user ends typing.
let g:ctrlp_lazy_update = 2
" The Silver Searcher

" theme
syntax enable
if (has("termguicolors"))
  set termguicolors
 endif


let g:UltiSnipsExpandTrigger="<C-l>"

" colors
let g:rainbow_active = 1
let g:diminactive_use_syntax = 1
let g:diminactive_enable_focus = 1
let g:diminactive_use_colorcolumn = 0
colorscheme OceanicNext

" sessions
let g:prosession_on_startup=1
let g:prosession_default_session=1

" mappings
nmap <silent> <leader>cp :PlugInstall<cr>
nnoremap <silent> <leader>cv :vsplit ~/.vimrc<cr>
nnoremap <silent> <leader>zz :tabe ~/.zshrc <bar> :lcd ~/.zsh<cr>
" Source my .vimrc file (This reloads the configuration)
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>tt :tabe ~/.tmux.conf<cr>

" windows
nnoremap <Right> <C-w>l
nnoremap <Left> <C-w>h
nnoremap <Up> <C-w>k
nnoremap <Down> <C-w>j
nnoremap <silent><C-Up> :resize +5<cr>
nnoremap <silent> <C-Down> :resize -5<cr>
nnoremap <silent> <C-Left> :vertical resize -20<cr>
nnoremap <silent> <C-Right> :vertical resize +20<cr>
" code
" log expression under cursor
nmap <Leader>cl yiwoconsole.log('<c-r>":', <c-r>");<Esc>^
"
" grep the word under cursor
let grepper ={}
let grepper.tools = ['rg', 'git', 'grep']
nnoremap <leader>* :Grepper -tool git -open -switch -cword -noprompt<cr>

" set grepprg=rg\ -i\ -H\ --no-heading\ --vimgrep
" set grepformat=$f:$l:%c:%m

" youcompleteme
let g:ycm_filetype_blacklist = {}

" ultisnips
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetsDir="~/.vim/snips/"
let g:UltiSnipsSnippetDirectories=['UltiSnips', 'snips']
let g:UltiSnipsEditSplit = 'vertical'
map <F5> :UltiSnipsEdit<CR>

" make YCM compatible with UltiSnips (using supertab)
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
" let g:UltiSnipsExpandTrigger = "<tab>"
" let g:UltiSnipsJumpForwardTrigger = "<tab>"
" let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

function! SetupCommandAlias(input, output)
  exec 'cabbrev <expr> '.a:input
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:input.'")'
        \ .'? ("'.a:output.'") : ("'.a:input.'"))'
endfunction

" abbreviations
ab cosnt const
ab teh the
ab gclog [*] changelog update
ab gcmrg 'master' merged into ''

" macros
" append date
let @d = ':s/$/\=strftime(''%b %d, %Y'')_�kb/'

" command abbreviations
call SetupCommandAlias("grep", "GrepperRg")
call SetupCommandAlias("??", "GrepperRg")
call SetupCommandAlias("G", "Git")
call SetupCommandAlias("npm", "Dispatch npm run")
call SetupCommandAlias("yarn", "Dispatch yarn")
call SetupCommandAlias("W", "w")
call SetupCommandAlias("Q", "q")
call SetupCommandAlias("blame", "Gblame")
call SetupCommandAlias("revert", "Git checkout %")
call SetupCommandAlias("gcm", "Git checkout  master")
if !exists(":VTerm")
  command VTerm :silent :vsplit | :terminal
  command STerm :silent :split | :terminal
  command TTerm :silent :tabe | :terminal

  call SetupCommandAlias("term", "terminal")
  call SetupCommandAlias("vterm", "VTerm")
  call SetupCommandAlias("tterm", "TTerm")
  call SetupCommandAlias("sterm", "STerm")
endif

let test#strategy = "dispatch"
let g:dispatch_compilers = { 'jest': 'jest-cli' }

" terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-v><Esc> <Esc>
  tnoremap <C-c> <C-\><C-n>i<C-c>
  highlight! link TermCursor Cursor
  highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
  if executable('nvr')
    let $VISUAL="nvr -cc vsplit --remote-wait + 'set bufhidden=wipe'"
  endif
endif

set undodir=$HOME/.local/share/nvim/undo
set undofile

augroup vimrc
  autocmd!
  autocmd BufWritePre /tmp/* setlocal noundofile
augroup END

" auto-close preview window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

au! BufRead,BufNewFile *.json set filetype=json
au! BufRead,BufNewFile *.md set filetype=markdown

" gitgutter + emoji
let g:gitgutter_sign_added = emoji#for('heavy_plus_sign')
let g:gitgutter_sign_modified = emoji#for('heavy_division_sign')
let g:gitgutter_sign_removed_first_line = emoji#for('heavy_minus_sign')
let g:gitgutter_sign_removed = emoji#for('heavy_minus_sign')
let g:gitgutter_sign_modified_removed = emoji#for('heavy_dollar_sign')

call SetupCommandAlias("emoji", "%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g")

let g:vim_markdown_folding_disabled = 1
set conceallevel=2
let g:vim_markdown_conceal = 0

function! CopyMatches(reg)
  let hits = []
  %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  let reg = empty(a:reg) ? '+' : a:reg
  execute 'let @'.reg.' = join(hits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

" coc.nvim
let g:coc_global_extensions = ['coc-tsserver', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-eslint', 'coc-snippets', 'coc-tslint', 'coc-stylelint', 'coc-cssmodules', 'coc-marketplace']
set signcolumn=yes

" TextEdit might fail if hidden is not set.
set hidden
set cmdheight=2
set updatetime=300

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-x> to trigger completion.
inoremap <silent><expr> <c-x> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[w` and `]w` to navigate diagnostics
nmap <silent> [w <Plug>(coc-diagnostic-prev)
nmap <silent> ]w <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" localsearch
nmap <leader>/ <Plug>localsearch_toggle

" easyclip
let g:EasyClipAlwaysMoveCursorToEndOfPaste=1
" yank/paste with system clipboard by default
set clipboard=unnamed
" yank history @ ~/.easyclip
let g:EasyClipShareYanks=1
let g:EasyClipShareYanksFile='.easyclip'
let g:EasyClipShareYanksDirectory='$HOME'
" `d` now deletes text completely, `x` -- cuts
let g:EasyClipUseCutDefaults = 0
nmap x <Plug>MoveMotionPlug
xmap x <Plug>MoveMotionXPlug
nmap xx <Plug>MoveMotionLinePlug
" `s` for substitution
let g:EasyClipUseSubstituteDefaults=1
let g:EasyClipUsePasteToggleDefaults = 0
nmap <c-f> <plug>EasyClipSwapPasteForward
nmap <c-d> <plug>EasyClipSwapPasteBackwards

"folding
set nofoldenable
set fdm=syntax
set foldnestmax=10
nnoremap + zo
nnoremap - zc

"easymotion
nmap f <Plug>(easymotion-overwin-f)

" file commands
map gF :vertical wincmd f<CR>

" local settings
silent! so .vimlocal
