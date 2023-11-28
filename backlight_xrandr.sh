#!/bin/bash

if [ ! "$(which xrandr)" ]
    then
        echo 'xrandr must be installed'
        exit 1
fi

CURRENT=$(xrandr --display :0.0 --screen 0 --verbose | awk '/Brightness/ {print $2}')
MIN=0.3
MAX=1

usage () {
    echo 'Usage: backlight_xrandr.sh inc|dec [step]'
    exit 1
}

increase () {
    local BRIGHTNESS
    BRIGHTNESS=$(echo "scale=2; $CURRENT + $STEP" | bc)
    if [ "$(echo "$BRIGHTNESS > $MAX" | bc -l)" -eq 1 ] 
        then
            BRIGHTNESS=$MAX
    fi
    echo "$BRIGHTNESS"
}

decrease () {
    local BRIGHTNESS
    BRIGHTNESS=$(echo "scale=2; $CURRENT - $STEP" | bc)
    if [ "$(echo "$BRIGHTNESS < $MIN" | bc -l)" -eq 1 ] 
        then
            BRIGHTNESS=$MIN
    fi
    echo "$BRIGHTNESS"
}

apply () {
    BRIGHTNESS=$1
    xrandr --output eDP --brightness "$BRIGHTNESS"
}



if [ -z "$1" ]
    then
        usage
    else
        SIGN="$1"
fi

if [ -z "$2" ]
    then
        STEP=0.10
    else
        STEP="$2"
fi

case $SIGN in
    inc)
        apply "$(increase)"
        ;;
    dec)
        apply "$(decrease)"
        ;;
    *)
        usage
        ;;
esac
