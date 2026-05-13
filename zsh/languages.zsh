# node
function load_nvm() {
    unset -f nvm node npm npx
    
    [ -s "/usr/share/nvm/init-nvm.sh" ] && source "/usr/share/nvm/init-nvm.sh"
}
for cmd in nvm node npm npx yarn; do
  eval "function $cmd() { load_nvm; $cmd \"\$@\"; }"
done

# opam
eval $(opam env)

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

