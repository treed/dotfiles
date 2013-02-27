isrunning() {
    pidof $1 > /dev/null
}

try() {
    if isrunning $(basename $1); then
        echo "$1 already running."
        return 0
    fi

    test x"`which $1 2>/dev/null`" != x""
    if test $? -eq 0; then
        $* &
        sleep 0.3
        if ! isrunning $1; then
            echo "$1 isn't running. failed?"
            return 1
        fi
    else
        echo "failed to find $1" >&2
        return 1
    fi
    return 0
}

try() {
    if isrunning $(basename $1); then
        echo "$1 already running."
        return 0
    fi

    test x"`which $1 2>/dev/null`" != x""
    if test $? -eq 0; then
        sudo $* &
        sleep 0.3
        if ! isrunning $1; then
            echo "$1 isn't running. failed?"
            return 1
        fi
    else
        echo "failed to find $1" >&2
        return 1
    fi
    return 0
}

try xcompmgr -a
try gnome-settings-daemon
export `gnome-keyring-daemon`
try gnome-screensaver
try gnome-panel
try nm-applet --sm-disable
try bluetooth-applet
try gnome-power-manager
try dropbox start
try gtk-redshift -l 37.4:-122.0 -t 6500:4000
try keynav
sudo rm -f /tmp/*evrouter*
try_sudo evrouter -r /dev/input/by-id/usb-Microsoft_Natural®_Ergonomic_Keyboard_4000-if01-event-kbd
exec xmonad
