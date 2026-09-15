if [[ -f ~/.bashrc ]] ; then
	. ~/.bashrc
fi

if [[ "$(tty)" == "/dev/tty1" ]]; then
    export XDG_CURRENT_DESKTOP=wlroots
    dbus-run-session -- dwl
fi
