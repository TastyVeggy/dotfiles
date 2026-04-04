export NVM_DIR="$HOME/.local/share/nvm"
source /usr/share/nvm/init-nvm.sh
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"

# opam
export OPAMROOT="$HOME/.local/share/opam"
eval $(opam env)

# cuda
export CUDA_HOME=/opt/cuda
export CUDA_PATH=/opt/cuda
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH

# GO stuff
# export PATH="$PATH:/usr/local/go/bin"
# export GOPATH="$HOME/Projects/devtools/go"
# export GOENV_ROOT="$GOPATH/.goenv"
# export PATH="$GOENV_ROOT/bin:$PATH"
# 
# export PATH="$GOENV_ROOT/shims:$PATH"
# eval "$(goenv init -)"
# export PATH="$GOROOT/bin:$PATH"
# export PATH="$PATH:$GOPATH/bin"


# Ruby stuff
# eval "$(rbenv init -)"

