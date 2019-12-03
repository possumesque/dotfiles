# If not running interactively, don't do anything.
[[ $- != *i* ]] && return

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

complete -cf sudo

shopt -s cdspell
shopt -s checkwinsize
shopt -s cmdhist
#shopt -s dotglob
shopt -s expand_aliases
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s nocaseglob

export HISTSIZE=10000
export HISTFILESIZE=${HISTSIZE}
export HISTCONTROL=ignoreboth

# prompt
#PS1='[\u@\h \W]\$ '
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

# adding bin directory in home to $PATH
export PATH=${PATH}:~/bin:~/.cargo/bin

export EDITOR='nvim'
export TERMINAL='~/bin/st/st'

# automatically ls on cd
cd_function () { \cd "${1:-/home/$USER}" && ls; }

# default pushd to ~
pd () {
    temp=$(pushd $@ 2>&1)
    if [[ $temp =~ "no other directory" ]]
    then
        pushd ~
    else
        pushd $@
    fi
}


ranger-cd () {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    ranger --choosedir="$tempfile" # "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        \cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

zathin() {
    TEMP=$(mktemp --suffix=".pdf") \
        && ln -sf /dev/stdout $TEMP \
        && cat - \
        | pandoc -f markdown -o $TEMP \
        | zathura -
    rm $TEMP
}

alias r=ranger-cd

# Starting tmux
# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
#[[ -z "$TMUX" ]] && exec tmux
