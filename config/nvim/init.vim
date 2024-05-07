call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'preservim/nerdtree'
Plug 'sindrets/diffview.nvim'
Plug 'projekt0n/github-nvim-theme'

call plug#end()

colorscheme github_dark

command! Rc :source $MYVIMRC | echo "Configuration reloaded!"
let mapleader = " "

nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>e :Explore<CR>
nnoremap <C-p> :Files<CR>

" Key mappings
nmap <leader>do <cmd>DiffviewOpen<CR>
nmap <leader>dc <cmd>DiffviewClose<CR>
nmap <leader>dr <cmd>DiffviewRefresh<CR>

" Customization (optional)
let g:diffview_filepanel_width = 40
let g:diffview_git_strategy = 'vertical'
let g:diffview_git_timelimit = 15
let g:diffview_signcolumn = 'number'
let g:diffview_diff_options = ['vertical']

