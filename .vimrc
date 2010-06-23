" Подсветка синтаксиса
syntax on

" Включить автоотступ
set autoindent

" Включаем 'умную' автоматическую расстановку отступов
set smartindent

" Использовать <Backspace>, вместо <x>
set backspace=indent,eol,start

" Отключить режим совместимости с Vi
set nocompatible

" Включить режим Paste
set paste

" Размер табуляции
set tabstop=4

" Включает отображение номеров строк
set number 

" Code Folding
if has ('folding')
  set foldenable
  set foldmethod=marker
  set foldmarker={{{,}}}
  set foldcolumn=0
endif

"включаем поддержку 256 цветов
set t_Co=256

" Цветовая схема
"colorscheme dante
"colorscheme desert
colorscheme neverland
"colorscheme wombat
"colorscheme xterm16
"colorscheme zenburn

" Указать цвет комментариев
highlight Comment ctermfg=darkgrey

" Указать фон консоли
set background=dark
"set background=light

" История команд - 50
set history=50

" Включаем мышь
set mouse=a
set mousemodel=popup

" Показывать линию курсора
set cursorline

" Всегда показывать положение курсора
set ruler

"Маркер строки
:au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" Автоопределение файлов
filetype plugin on
filetype indent on

" Формат строки состояния
set statusline=%<%f%h%m%r%=format=%{&fileformat}\ file=%{&fileencoding}\ enc=%{&encoding}\ %b\ 0x%B\ %l,%c%V\ %P

" Всегда отображать статусную строку для каждого окна
set laststatus=2

" Показывать текущую команду
set showcmd

" Показывать режим работы
set showmode

" Поиск в реалтайме
set incsearch

" Отключаем создание бэкапов
set nobackup

" Отключаем создание swap файлов
set noswapfile

" Кодировка текста по умолчанию
set termencoding=utf-8

" Список кодировок файлов для автоопределения
set fileencodings=utf-8,cp1251,koi8-r,cp866

" Просмотр нетекстовых файлов в Vim
au BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" - |fmt -csw78
au BufReadPost *.doc silent %!antiword "%"
au BufReadPost *.odt silent %!odt2txt "%"

" Стрелки для комментариев 
map - $a --><Esc>
map = $a <--<Esc> 

" Быстрое сохранение на <F2> во всех режимах
imap <F2> <Esc>:w<CR>
map <F2> <Esc>:w<CR>

" Выход без сохранения на <F10> во всех режимах
imap <F10> <Esc>:q!<CR>
map <F10> <Esc>:q!<CR>

" Вставка из буфера мыши
map <S-Insert> <Middlemouse>

map <F4>  <esc>:call SWITCHFOLD()<cr>
function SWITCHFOLD()
    if &foldmethod=="marker"
        set foldmethod=syntax
        return
    endif
    if &foldmethod=="syntax"
        set foldmethod=indent
        return
    endif
    if &foldmethod=="indent"
        set foldmethod=manual
        return
    endif
    if &foldmethod=="manual"
        set foldmethod=marker
        return
    endif
endfunction

" Полезности для Mutt
" F1 through F3 re-wraps paragraphs
augroup MUTT
au BufRead ~/.mutt/temp/mutt* set spell " <-- vim 7 required
au BufRead ~/.mutt/temp/mutt* nmap  <F1>  gqap
au BufRead ~/.mutt/temp/mutt* nmap  <F2>  gqqj
au BufRead ~/.mutt/temp/mutt* nmap  <F3>  kgqj
au BufRead ~/.mutt/temp/mutt* map!  <F1>  <ESC>gqapi
au BufRead ~/.mutt/temp/mutt* map!  <F2>  <ESC>gqqji
au BufRead ~/.mutt/temp/mutt* map!  <F3>  <ESC>kgqji
augroup END

