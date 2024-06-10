# for midway2 .zshrc

# for kitty terminal 
# bindkey -e
# bindkey '^[[1;3C' forward-word # this is alt-left
# bindkey '^[[1;3D' backward-word # this is alt-right
#
# kitty
# bindkey "\e[1;3C" forward-word # ⌥→
# bindkey "\e[1;3D" backward-word # ⌥←

# iterm
# bindkey "\e\e[D" backward-word # ⌥←
# bindkey "\e\e[C" forward-word # ⌥→


# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/scratch/midway2/chaodai/miniconda3/envs/ez/bin:/scratch/midway2/chaodai/miniconda3/bin:/scratch/midway2/chaodai/miniconda3/condabin:/home/chaodai/bin:/home/chaodai/.local/bin:$PATH"

export TZ="America/Chicago"
export SINGULARITYENV_CACHEDIR="/scratch/midway2/chaodai/.singularity"

export BASH_SILENCE_DEPRECATION_WARNING=1

export HOST=$(hostname -s)
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump.$HOST.$(zsh --version | awk '{print $1"-"$2}')

export TMPDIR=/scratch/midway2/chaodai/TMP

module load gsl/2.5 parallel
module unload gcc && module load gcc/12.2.0
module unload tmux && module load tmux/3.1c


export EDITOR='nvim'

# prevent zsh from sharing command history between tmux panels
setopt nosharehistory

# autocd
setopt autocd


# api keys
source ~/.api_keys

# alias
alias htop="/scratch/midway2/chaodai/miniconda3/bin/htop"
alias envsos="conda activate sos"
alias sc="scontrol show job"
alias sq="squeue -u chaodai"
alias l="ls -lah --color=auto"
alias ls="ls --color=auto"
alias clr="clear"
alias smk="snakemake"
alias tl="tmux list-sessions"
alias ta="tmux attach-session -t"
alias ts="tmux new-session -s"


# zsh augosuggestions, syntax highlighting, autocompletion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# key bindings for autocomplet - cycle through complete
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/scratch/midway2/chaodai/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/scratch/midway2/chaodai/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/scratch/midway2/chaodai/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/scratch/midway2/chaodai/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/scratch/midway2/chaodai/miniconda3/etc/profile.d/mamba.sh" ]; then                                                        
    . "/scratch/midway2/chaodai/miniconda3/etc/profile.d/mamba.sh"
fi  

# <<< conda initialize <<<


# zoxide
eval "$(zoxide init zsh)"


# fzf init
eval "$(fzf --zsh)"





# starship
eval "$(starship init zsh)"
