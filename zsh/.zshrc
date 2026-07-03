export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="simple"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

alias wez="curl wttr.in/Lviv" 
alias fs="rxfetch"
alias ls="eza --icons"
alias ll="eza -l --icons"
alias l="eza -l --icons -a"
alias ani-cli="ani-cli --dub"
alias tree="ll -T"
rc() {
  gh repo create $1 --public --clone && gh repo view --web $1
}

cpr() {
  clang++ $1 -o main && ./main
}

qc() {
  qemu-system-x86_64 -enable-kvm -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd -drive if=pflash,format=raw,file=$2/OVMF_VARS.4m.fd -drive file=$1 -m 8G -cpu host -display gtk -vga virtio
}

qci() {
  qemu-system-x86_64 -enable-kvm -cdrom $1 -boot menu=on -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/x64/OVMF_CODE.4m.fd -drive if=pflash,format=raw,file=$3/OVMF_VARS.4m.fd -drive file=$2 -m 8G -cpu host -display gtk -vga virtio
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

source <(fzf --zsh)

eval "$(starship init zsh)"

eval "$(zoxide init --cmd cd zsh)"

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

rxfetch
