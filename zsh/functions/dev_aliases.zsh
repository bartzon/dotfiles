local pwd="${PWD/#$HOME/~}"
pwd_list=(${(s:/:)pwd})

alias dt="dev test"
alias dr="dev style"
alias ds="./bin/srb typecheck"

alias da="clear; ds && dr && dt"

case $pwd_list[-1] in
  "shopify")
    alias dt="dev test --include-branch-commits"
    alias dr="dev style --include-branch-commits"
    ;;
  "shipify")
    alias dt="dev test --include-branch-commits"
    alias dr="dev style"
    alias ds="./bin/style typecheck"
    ;;
  "atlas")
    alias dt="dev test"
    alias dr="dev style"
    ;;
  *)
    unalias dt
    unalias dr
    unalias ds
    unalias da
esac
