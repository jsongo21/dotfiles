setopt ignoreeof

# Created by `pipx` on 2022-11-16 03:29:27
export PATH="$PATH:/Users/jason/.local/bin"

export GPG_TTY=$(tty)

if [ -z "${WAYLAND_DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec Hyprland >/dev/null
fi
