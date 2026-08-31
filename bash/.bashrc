source ~/.git-prompt.sh

export PF_COL1=3
export PF_COL3=5

export PS1='\[\e[33;1m\]\u@\h \[\e[34m\]\w$(__git_ps1 " \[\e[35m\](\[\e[32m\]%s\[\e[35m\])") \[\e[34m\]\$ \[\e[00m\]'


qc() {
  qemu-system-x86_64 -enable-kvm -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/OvmfX64/OVMF_CODE.fd -drive if=pflash,format=raw,file=$2/OVMF_VARS.fd -drive file=$1 -m 8G -cpu host -smp 6 -display gtk -vga virti -netdev user,id=net0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0
}

qci() {
  qemu-system-x86_64 -enable-kvm -cdrom $1 -boot menu=on -drive if=pflash,format=raw,readonly=on,file=/usr/share/edk2/OvmfX64/OVMF_CODE.fd -drive if=pflash,format=raw,file=$3/OVMF_VARS.fd -drive file=$2 -m 8G -cpu host -smp 6 -display gtk -vga virtio -netdev user,id=net0,hostfwd=tcp::2222-:22 -device virtio-net-pci,netdev=net0
}

wifi() {
  doas rc-service wpa_supplicant $1
}

bluetooth() {
  doas rc-service bluetooth $1
}

function y() {
	local tmp cwd; tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd" || builtin true
	command rm -f -- "$tmp"
}

eval "$(fzf --bash)"

pfetch
