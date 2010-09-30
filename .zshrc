#!/bin/zsh
#
# Author: enko
# Last updated: 12/06/2010
#
# #### Options {{{
#
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

export PAGER="less"
export EDITOR="vim"
export BROWSER="firefox"
export PATH="${PATH}:${HOME}/.bin"
export PATH="/usr/local/lib/cw:$PATH" # need to install cw (http://cwrapper.sourceforge.net/)

# Dircolors
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS
# если установлен grc, то им можно раскрасить ещё несколько программ:
if [ -f /usr/bin/grc ]; then
  alias ping="grc --colour=auto ping"
  alias cat="grc --colour=auto cat"
  alias traceroute="grc --colour=auto traceroute"
  alias make="grc --colour=auto make"
  alias diff="grc --colour=auto diff"
  alias cvs="grc --colour=auto cvs"
  alias netstat="grc --colour=auto netstat"
fi

# less
export LESS="-MWi -x4 --shift 5"
export LESSHISTFILE="-" # no less history file
if [ "$UID" != 0 ]; then
    export LESSCHARSET="utf-8"
    if [ -z "$LESSOPEN" ]; then
        if [ "$__distribution" = "Debian" ]; then
            [ -x "`which lesspipe`" ] && eval "$(lesspipe)"
        else
            [ -x "`which lesspipe.sh`" ] && export LESSOPEN="|lesspipe.sh %s"
        fi
    fi
    
# Цветные маны через less
    export LESS_TERMCAP_mb=$'\E[01;31m'
    export LESS_TERMCAP_md=$'\E[01;31m'
    export LESS_TERMCAP_me=$'\E[0m'
    export LESS_TERMCAP_se=$'\E[0m'
    export LESS_TERMCAP_so=$'\E[01;44;33m'
    export LESS_TERMCAP_ue=$'\E[0m'
    export LESS_TERMCAP_us=$'\E[01;32m'
fi

# Window title
case $TERM in
    *xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
        precmd () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" }
        preexec () { print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" }
    ;;
    screen)
        precmd () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a"
        }
        preexec () {
            print -Pn "\e]83;title \"$1\"\a"
            print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a"
        }
    ;;
esac

# }}}

##### Keybindings {{{
bindkey -v
typeset -g -A key
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for gnome-terminal
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# }}}

##### Aliases {{{
#
alias ls='ls -F --color=auto'
alias lsd='ls -ld *(/)' # only show directories
alias lad='ls -ld .*(/)' # only show dot-directories
alias lsa='ls -a .*(.)' # only show dot-files
alias lsbig='ls -lSh *(.) | head' # display the biggest files
alias lssmall='ls -Sl *(.) | tail' # display the smallest files
alias lsnew='ls -rtl *(.) | tail' # display the newest files
alias lsold='ls -rtl *(.) | head' # display the oldest files
alias ll='ls -ahl --color | more; echo "\e[1;32m --[\e[1;34m Dirs:\e[1;36m `ls -al | egrep \"^drw\" | wc -l` \e[1;32m|\e[1;35m Files: \e[1;31m`ls -al | egrep -v \"^drw\" | grep -v total | wc -l` \e[1;32m]--"'
alias lls="ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'" # с цифровым видом прав
alias mv='nocorrect mv -i' # переименование-перемещение c пogтвepжgeнueм без коррекции
alias cp='nocorrect cp -iR' # рекурсивное копирование с подтверждением без коррекции
alias rm='nocorrect rm -i' # удаление с подтверждением без коррекции
alias rmf='nocorrect rm -f' # принудительное удаление без коррекции
alias rmrf='nocorrect rm -fR' # принудительное рекурсивное удаление без коррекции
alias mkdir='nocorrect mkdir' # создание каталогов без коррекции
alias reciso="growisofs -dvd-compat -Z /dev/dvd=" # запись образа
alias catiso="cat /dev/cdrom > image.iso" # снять образ диска
alias blankcd="growisofs -Z /dev/cdrom=/dev/zero" # или dvd+rw-format -f /dev/dvd # очистить dvd
alias rec="growisofs -Z /dev/dvd -R -J" # запись каталога на диск
alias eject='sudo eject /dev/sr0'
alias mountiso='sudo mount -o loop -t iso9660' # монтирование iso. mountiso [что] [куда]
alias mountnrg='mount -t udf,iso9660 -o loop,ro,offset=307200' # монтирование nrg. mountnrg [что] [куда]
alias wget=wget -c –passive-ftp –no-check-certificate
alias ka='killall'
alias ip='wget http://checkip.dyndns.org/ -O - -o /dev/null | cut -d: -f 2 | cut -d\< -f 1'
alias upfonts='sudo fc-cache -vf'
alias capture='ffmpeg -f x11grab -s sxga -r 24 -i :0.0 ~/capture.mpg'
alias xe='cat /var/log/Xorg.0.log |grep EE'
alias xw='cat /var/log/Xorg.0.log |grep WW'
alias gettime='sudo /usr/sbin/ntpdate ru.pool.ntp.org'
alias grep='grep --color=auto'
alias df='df -Th'
alias mplayerlist='find /mnt/data/Music -type f -name "*.mp3" -print > list.m3u'
alias nc='ncmpcpp'
alias setbright='sudo setpci -s 00:02.0 F4.B=99'
alias Xdefaults="xrdb -load ~/.Xdefaults"
alias rsync='rsync --progress'
alias sv='sudo vim'
alias vx='vim ~/.xmonad/xmonad.hs'
alias nano='nano -W -m'
alias R='exec zsh'
alias ping='ping -c 5'
# Package manager
# aptitude:
alias ,="aptitude"
alias ,,="apt-get"
alias ,,,="dpkg"
alias ,l="dpkg -l"
alias ,ll="dpkg -L"
alias ,o="dpkg -S"
alias ,s="aptitude search"
alias show="aptitude show"
alias ,u="sudo aptitude update"
alias ,uu="sudo aptitude update && sudo aptitude safe-upgrade"
alias ,i="sudo aptitude install"
alias ,ii="sudo dpkg -i"
alias ,r="sudo aptitude remove"
alias ,p="sudo aptitude purge"
alias ,rl="dpkg -l | grep '^rc'"
alias ,rr="sudo dpkg -l | sudo awk '/^rc/{print $2}' | sudo xargs dpkg -P"
alias ,pl="sudo dpkg --get-selections >> ~/my_packages.txt"
# portage:
#alias ,s="eix"
#alias ,u="sudo layman -S && sudo eix-sync -W"
#alias ,uu="sudo emerge -avuDN world"
#alias ,i="sudo emerge -av"
#alias ,r="sudo emerge -avC"
#alias ,cl="sudo emerge --depclean"
#alias ,rev="sudo revdep-rebuild"

# }}}

##### Compilation Style {{{
#
zmodload zsh/complist
autoload -Uz compinit
compinit
zstyle ':completion:*' menu yes select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps xua'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'
setopt AUTO_CD
setopt CORRECT_ALL
setopt histfindnodups
# }}}

##### Prompt {{{
#
autoload -U colors && colors
PS1="%{$fg[red]%}%n%{$reset_color%}@%{$fg[green]%}%m %{$fg[yellow]%}%~ %{$reset_color%}%% "

SPROMPT='zsh: Заменить '\''%R'\'' на '\''%r'\'' ? [Yes/No/Abort/Edit] '






# }}}

##### Function {{{
#
extract_archive () {
    local old_dirs current_dirs lower
    lower=${(L)1}
    old_dirs=( *(N/) )
    if [[ $lower == *.tar.gz || $lower == *.tgz ]]; then
        tar zxfv $1
    elif [[ $lower == *.gz ]]; then
        gunzip $1
    elif [[ $lower == *.tar.bz2 || $lower == *.tbz ]]; then
        bunzip2 -c $1 | tar xfv -
    elif [[ $lower == *.bz2 ]]; then
        bunzip2 $1
    elif [[ $lower == *.zip ]]; then
        unzip $1
    elif [[ $lower == *.rar ]]; then
        unrar e $1
    elif [[ $lower == *.tar ]]; then
        tar xfv $1
    elif [[ $lower == *.lha ]]; then
        lha e $1
    else
        print "Unknown archive type: $1"
        return 1
    fi
    # Change in to the newly created directory, and
    # list the directory contents, if there is one.
    current_dirs=( *(N/) )
    for i in {1..${#current_dirs}}; do
        if [[ $current_dirs[$i] != $old_dirs[$i] ]]; then
            cd $current_dirs[$i]
            ls
            break
        fi
    done
}

alias ex=extract_archive
compdef '_files -g "*.gz *.tgz *.bz2 *.tbz *.zip *.rar *.tar *.lha"' extract_archive

# Creates an archive from given directory
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

# генератор паролей
function mkpass()
{
perl <<EOPERL
my @a = ("a".."z","A".."Z","0".."9",(split //, q{#@,.<>$%&()*^}));
for (1..10) {
print join "", map { \$a[rand @a] } (1..rand(3)+7);
print qq{\n}
}
EOPERL
}

# 20% превьюшка картинки
thumb() {
  for pic in "$@"; do
    case "$pic" in
      *.jpg) thumb="$(echo "$pic" | sed s/.jpg/-thumb.jpg/g)" ;;
      *.jpeg) thumb="$(echo "$pic" | sed s/.jpeg/-thumb.jpeg/g)" ;;
      *.png) thumb="$(echo "$pic" | sed s/.png/-thumb.png/g)" ;;
      *) echo "usage: thumbit [file{.jpg,.jpeg,.png}]" && return 1 ;;
    esac
    cp "$pic" "$thumb"
    mogrify -resize 20% "$thumb"
  done
}

# mp3 в utf (cd /music/dir && mp32utf)
mp32utf() { find -iname '*.mp3' -print0 | xargs -0 mid3iconv -eCP1251 --remove-v1 }

# Forismatic
#curl -s -d "lang=ru&method=getQuote&key=457653&format=text" http://api.forismatic.com/api/1.0/
# }}}

#
man2pdf() {
    if [[ -z $1 ]]; then
echo "USAGE: man2pdf [[manpage]]"
    else
if [[ `find /usr/share/man -name $1\* | wc -l` -gt 0 ]]; then
out=/tmp/$1.pdf
        if [[ ! -e $out ]]; then
man -t $1 | ps2pdf - > $out
        fi
if [[ -e $out ]]; then
            /usr/bin/apvlv $out
        fi
else
echo "ERROR: manpage \"$1\" not found."
    fi
fi
}

#
ompload() {
     curl -F file1=@"$1" http://omploader.org/upload|awk '/Info:|File:|Thumbnail:|BBCode:/{gsub(/<[^<]*?\/?>/,"");$1=$1;sub(/^/,"\033[0; 34m");sub(/:/,"\033[0m:");print}'
 }
 
#
lemerge () { cat /var/log/emerge.log | awk -F: '{print strftime("%c", $1),$2}' | less }
###


upinfo ()
{
echo -ne "\t ";uptime | awk /'up/ {print $3,$4,$5,$6,$7,$8,$9,$10}'
}


# fast directory change
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

