export NODENV_ROOT="/home/{{ app.name }}/.nodenv"
export PATH="$NODENV_ROOT/bin:$PATH"

eval "$($NODENV_ROOT/bin/nodenv init -)"

alias pnpm='corepack pnpm'
alias npm='corepack npm'
alias yarn='corepack yarn'
