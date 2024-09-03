# for midway3 .zshrc

bindkey -e
bindkey '^[[1;3C' forward-word  # this is alt-left
bindkey '^[[1;3D' backward-word # this is alt-right

#export useful path for bin
export PATH="$HOME/.tmuxifier/bin:/scratch/midway3/chaodai/miniconda3/envs/ez/bin:$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

# need for tmuxifier
eval "$(tmuxifier init -)"

# need this for QTLtools
#export LD_LIBRARY_PATH=/scratch/midway3/chaodai/miniconda3/envs/sos/lib:$LD_LIBRARY_PATH

# prevent lots of compdump files in $HOME
#export ZSH_COMPDUMP=$ZSH/cache/.zcompdump.$(hostname -s).$(zsh --version | awk '{print $2}')
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump

export TMPDIR=/scratch/midway3/chaodai/TMP

# prevent zsh from sharing command history between tmux panels
setopt nosharehistory

# Editor
export EDITOR=nvim

# set timezone
export TZ="America/Chicago"

## silence the bell ?
export BASH_SILENCE_DEPRECATION_WARNING=1

# load tmux 3.2a
module load tmux/3.2a
module load parallel

# api keys
source ~/.api_keys

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/scratch/midway3/chaodai/miniconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
  eval "$__conda_setup"
else
  if [ -f "/scratch/midway3/chaodai/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/scratch/midway3/chaodai/miniconda3/etc/profile.d/conda.sh"
  else
    export PATH="/scratch/midway3/chaodai/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup

if [ -f "/scratch/midway3/chaodai/miniconda3/etc/profile.d/mamba.sh" ]; then
  . "/scratch/midway3/chaodai/miniconda3/etc/profile.d/mamba.sh"
fi

# zsh-autosuggestions & syntaxhighlighting
# source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# key bindings for autocomplet - cycle through complete
bindkey '^I' menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# zoxide init
eval "$(zoxide init zsh)"

# fzf init
eval "$(fzf --zsh)"

# starship
eval "$(starship init zsh)"

## aliases
alias yo="sinteractive --account pi-jstaley  --job-name CPU4M33G -c 4 --mem 33GB --time 36:00:00"
alias yup="sinteractive --account pi-jstaley --job-name RsoJup -c 4 --mem 40GB --time 36:00:00"
alias sc="scontrol show job"
alias sq="squeue -u chaodai"
alias smk="snakemake"
alias clr="/usr/bin/clear"
alias l="lsd -lah" # alias l="ls -lah --color=auto"
alias ls="lsd"     # alias ls="ls --color=auto"
alias tl="tmux list-sessions"
alias ta="tmux attach-session -t"
alias ts="tmux new-session -s"
alias envsos="conda deactivate && conda activate sos"
