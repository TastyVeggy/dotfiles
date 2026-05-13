export ZDOTDIR="$HOME/.config/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
export XAUTHORITY="$HOME/.cache/Xauthority"
export WGETRC="$HOME/.config/wget/wgetrc"
export GNUPGHOME="$HOME/.local/share/gnupg"
export SCREENDIR="$HOME/.local/state/screen"
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

[[ ":$PATH:" != *":$HOME/.config/bin:"* ]] && export PATH="$PATH:$HOME/.config/bin"
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$PATH:$HOME/.local/bin"

# Programming languages
# javascript
export NVM_DIR="$HOME/.local/share/nvm"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# opam
export OPAMROOT="$HOME/.local/share/opam"

# cuda
export CUDA_HOME=/opt/cuda
export CUDA_PATH=/opt/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
export CUDA_CACHE_PATH="$HOME/.cache/nvidia/ComputeCache"

# latex
export TEXMFCONFIG="$HOME/.cache/texlive/texmf-config"
export TEXMFVAR="$HOME/.cache/texlive/texmf-var"

# python
export PYTHONSTARTUP="$HOME/.config/python/pythonrc.py"

# Input language
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
