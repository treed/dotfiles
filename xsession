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

try_eval() {
    test x"`which $1 2>/dev/null`" != x""
    ret=$?
    if test $ret -eq 0; then
        eval `$*`
        if test $? -ne 0; then
            echo "$1 failed."
        fi
    else
        echo "failed to find $1" >&2
    fi
    return $ret
}

gnome-settings-daemon
export `gnome-keyring-daemon`
try gnome-screensaver
try trayer --SetDockType true --SetPartialStrut true --SetDockType true --edge top --widthtype percent --width 10 --align right --transparent true --tint 000000
try nm-applet --sm-disable
try bluetooth-applet
try update-notifier
try ginn
try dropbox start
try junglediskdesktop
exec xmonad
