# SETUP Custom $PATH
PATH=~/bin:$PATH
# Setting PATH for Python 2.7(Custom Installed to Handle Old NPM deps)
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# GIT prompt and git completion
if [ -f /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash ]
then
    . /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
fi
if [ -f /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash ]
then
    . /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
fi

if [ -f ~/.git-prompt.sh ]
then
    . ~/.git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWCOLORHINTS=true

git_prompt() {
    __git_ps1 " [%s]"
}
export PROMPT_COMMAND='__git_ps1 "\h:\w" " \u\$ " " [%s]"'


#export PS1='\h:\w\[\033[1;33m\]$(__git_ps1 " [%s]")\[\033[0m\] \u\$ '

# Node/JS Niceties
if [ -x `which npm` ]
then
    . <(npm completion)
fi

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export BASH_SILENCE_DEPRECATION_WARNING=1

# Aliases
alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias gpg-agent-restart='gpgconf --reload gpg-agent'
alias sshconfig='vim ~/.ssh/config'

# GPG YubiKey
gpgconf --launch gpg-agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# Enable Completions
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
#_ssh()
#{
#    local cur prev opts
#    COMPREPLY=()
#    cur="${COMP_WORDS[COMP_CWORD]}"
#    prev="${COMP_WORDS[COMP_CWORD-1]}"
#    opts=$(grep '^Host' ~/.ssh/config  | grep -v '[?*]' | cut -d ' ' -f 2-)
#
#    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
#    return 0
#}
#complete -F _ssh ssh
#complete -F _ssh scp

# Work specific files
test -r ~/.work_profile && test -f ~/.work_profile && . ~/.work_profile
