# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
#if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
#    debian_chroot=$(cat /etc/debian_chroot)
#fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color|*-256color) color_prompt=yes;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#    # We have color support; assume it's compliant with Ecma-48
#    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#    # a case would tend to support setf rather than setaf.)
#    color_prompt=yes
#    else
#    color_prompt=
#    fi
#fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#source /vagrant/etc/shellrc

###################################################################################################
# Customize/colorize the command prompt.

BLACK="[30m"
RED="[31m"
GREEN="[32m"
BROWN="[33m"
BLUE="[34m"
PURPLE="[35m"
CYAN="[36m"
LIGHT_GRAY="[37m"
DARK_GRAY="[1;30m"
LIGHT_RED="[1;31m"
LIGHT_GREEN="[1;32m"
YELLOW="[1;33m"
LIGHT_BLUE="[1;34m"
LIGHT_PURPLE="[1;35m"
LIGHT_CYAN="[1;36m"
WHITE="[1;37m"
NO_COLOR="[0m"

esc() {
    echo "\e${1}"
}

bash_esc() {
    echo "\[$(esc "${1}")\]"
}

PS1="$(bash_esc "${BLUE}"){ \W } $(bash_esc "${GREEN}")\$(git rev-parse --abbrev-ref HEAD 2> /dev/null || echo '\u@\h') $(bash_esc "${RED}")\$»$(bash_esc "${NO_COLOR}") "

PROMPT_COMMAND="RETURN_CODE=\${?} ; if [ \${RETURN_CODE} -ne 0 ] ; then echo -en \"$(esc "${RED}")[\${RETURN_CODE}]$(esc "${NO_COLOR}")\" ; else echo -n \"\" ; fi"

unset BLACK RED GREEN BROWN BLUE PURPLE CYAN LIGHT_GRAY DARK_GRAY LIGHT_RED LIGHT_GREEN YELLOW LIGHT_BLUE LIGHT_PURPLE LIGHT_CYAN WHITE NO_COLOR

unset -f esc bash_esc

###################################################################################################
# ssh-agent
#
# https://help.github.com/en/github/authenticating-to-github/working-with-ssh-key-passphrases

env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

###################################################################################################
# Run optional startup scripts.

if [ -d ~/.profile.d ] ; then
    for SCRIPT in ~/.profile.d/* ; do
        source ${SCRIPT}
    done
fi
