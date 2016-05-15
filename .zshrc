# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/mvock/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


#### Custom stuff

export DISPLAY=:0

###############################################
################### Antigen ###################
###############################################

# Load Antigen
source ~/.zsh/antigen/antigen.zsh

# Load various lib files
# antigen bundle robbyrussell/oh-my-zsh lib/
antigen use oh-my-zsh

#
# Antigen Bundles
#

antigen bundles <<EOBUNDLES
 debian
 git
 git-extras
 git-flow-avh
 gitignore
 gradle
 emallson/gulp-zsh-completion
 node
 npm
 rake-fast
 sprunge
 web-search
 
 zsh-users/zsh-syntax-highlighting
EOBUNDLES

# For SSH, starting ssh-agent is annoying
# antigen bundle ssh-agent

# OS specific plugins
if [[ $CURRENT_OS == 'OS X' ]]; then
    antigen bundle brew
    antigen bundle brew-cask
    antigen bundle gem
    antigen bundle osx
elif [[ $CURRENT_OS == 'Linux' ]]; then
    # None so far...

    if [[ $DISTRO == 'CentOS' ]]; then
        antigen bundle centos
    fi
elif [[ $CURRENT_OS == 'Cygwin' ]]; then
    antigen bundle cygwin
fi

#antigen bundle ~/projekte/version-tools/extract-changelog --no-local-clone

#
# Antigen Theme
#

antigen theme bureau

antigen apply

######################################################
############ End of Antigen Configuration ############
######################################################

# My own aliases

alias rm='rm -I'

# Add current working directory to homedirs
HOMEDIRS=~/.zsh/homedirs.zsh
function add-to-homedirs () {
    cmd="hash -d "$1"="'"'`pwd`'"'
    echo $cmd >> $HOMEDIRS
    eval $cmd
}

. $HOMEDIRS

# Add last command line to aliases
ALIASES=~/.zsh/aliases.zsh
function alias-last () {
    lastline=$(fc -l -1)
    lastcmd=${lastline##*  }
    cmd="alias $1=\"$lastcmd\""
    echo $cmd >> $ALIASES
    eval $cmd
}

. $ALIASES
