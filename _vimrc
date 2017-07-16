source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
"解决菜单和内容中文乱码问题
if has("multi_byte") 
    set encoding=utf-8 
    set termencoding=utf-8 
    set formatoptions+=mM 
    set fencs=utf-8,gbk 
    if v:lang =~? '^/(zh/)/|/(ja/)/|/(ko/)' 
        set ambiwidth=double 
    endif 
    if has("win32") 
        source $VIMRUNTIME/delmenu.vim 
        source $VIMRUNTIME/menu.vim 
        language messages zh_CN.utf-8 
    endif 
else 
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte" 
endif
"隐藏菜单栏和工具栏，用F2切换 
set guioptions-=m  
set guioptions-=T  
map <silent> <F2> :if &guioptions =~# 'T' <Bar>  
        \set guioptions-=T <Bar>  
        \set guioptions-=m <bar>  
    \else <Bar>  
        \set guioptions+=T <Bar>  
        \set guioptions+=m <Bar>  
    \endif<CR>  
"设置行号和语法高亮
syntax enable
syntax on
set nu
"修改主题为solarized
set t_Co=256
set background=dark "light和dark两个版本
colorscheme solarized
hi Normal  ctermfg=252 ctermbg=none
"禁止vim生成 un~
set noundofile
set nobackup
set noswapfile
" 只有支持autocommands时会执行这部分代码.
if has("autocmd")
	" 使用文件类型检查和基于文件的自动缩紧
	filetype plugin indent on
	" Makefiles 文件中tab使用长度8.
	autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab
endif
" 对于其它情况，使用4个空格宽度的TAB
set tabstop=4	   " TAB的宽度被设置为4个空格.
					" 但仍然是\t. 只是vim把它解释成4个空格宽度，用别的编辑器还是\t符号
					" Vim will interpret it to be having
					" a width of 4.
set autoindent
set smartindent
set shiftwidth=4	" 缩进使用4个空格的宽度.
set softtabstop=4   " 设置tab所占的列数，当输入tab时，设为4个空格的宽度.
set expandtab       " 扩展tab为空格.
filetype plugin indent on
filetype indent on
"设置文件浏览器快捷键为F3
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
" ************** 插件管理与设置 ************ "  
  
" vundle 环境设置 
set nocompatible              " be iMproved, required 
filetype off  
set rtp+=$VIM/vimfiles/bundle/Vundle.vim  
" vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间  
call vundle#begin('$VIM/vimfiles/bundle') 

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'  "状态栏，buffer美化
Plugin 'vim-airline/vim-airline-themes'
  
" 插件列表结束  
call vundle#end()  
filetype plugin indent on 

"显示光标的坐标
set ruler

"高亮整行
set cursorline

"自动缩进
set noautoindent
set cindent
set smartindent

"Tab键的宽度
set shiftwidth=4
set tabstop=4

    if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
 

  let g:airline_theme='solarized' 

  set laststatus=2  "永远显示状态栏
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
 
  
  " unicode symbols
  let g:airline_left_sep = '»'
  let g:airline_left_sep = '▶'
  let g:airline_right_sep = '«'
  let g:airline_right_sep = '◀'

"设置为双字宽显示，否则无法完整显示如:☆
set ambiwidth=double 
set encoding=utf-8
set laststatus=2
set bs=2
set guifont=Courier_New:h12:cANSI
set rop=type:directx
let symbols={'maxlinenr': "\u33d1", 'linenr':"\u2630" }
let &stl='%f %{g:symbols.linenr}%2l/%L%{g:symbols.maxlinenr}'
"用alt+数字来切换tabs
" 关于标签页的标题修改 "
" 使用了自定义函数  GuiTabLabel()
set showtabline=2 " always show tabs in gvim, but not vim
set guitablabel=%{GuiTabLabel()}"

"
" 修改标签页的标题
" set up tab labels with tab number, buffer name, number of windows
"
function! GuiTabLabel()"
  let label = ''
  let bufnrlist = tabpagebuflist(v:lnum)
  " Add '+' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '+'
      break
    endif
  endfor
  " Append the tab number
  let label .= v:lnum.': '
  " Append the buffer name
  let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
  if name == ''
    " give a name to no-name documents
    if &buftype=='quickfix'
      let name = '[Quickfix List]'
    else
      let name = '[No Name]'
    endif
  else
    " get only the file name
    let name = fnamemodify(name,":t")
  endif
  let label .= name
  " Append the number of windows in the tab page
  let wincount = tabpagewinnr(v:lnum, '$')
  return label . '  [' . wincount . ']'
endfunction"

" 让 gvim 支持 Alt+n 来切换标签页
function! BufPos_Initialize()
    for a in range(1,9)
        exe 'map <A-' . a . '> ' . a . 'gt'
    endfor
endfunction
autocmd VimEnter * call BufPos_Initialize()
"
" alt+左右键来移动标签
"
nn <silent> <M-left> :if tabpagenr() == 1\|exe "tabm ".tabpagenr("$")\|el\|exe "tabm ".(tabpagenr()-2)\|en<CR>
nn <silent> <M-right> :if tabpagenr() == tabpagenr("$")\|tabm 0\|el\|exe "tabm ".tabpagenr()\|en<CR>


