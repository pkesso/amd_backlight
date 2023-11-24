#!/bin/bash

if [ ! "$(which redshift)" ]
    then
        echo 'redshift must be installed'
        exit 1
fi

BRIGHTNESS_MIN=0.5
BRIGHTNESS_MAX=1
BRIGHTNESS_STEP=0.05
COLORTEMP_MIN=4500
COLORTEMP_MAX=6500
COLORTEMP_STEP=200
STATUS_FILE="$HOME/.backlight_status"

if [ ! -f "$STATUS_FILE" ]
    then
        echo "brightness $BRIGHTNESS_MAX" > "$STATUS_FILE"
        echo "colortemp $COLORTEMP_MAX" >> "$STATUS_FILE"
fi

BRIGHTNESS_CURRENT=$(grep brightness "$STATUS_FILE" | cut -f2 -d' ')
COLORTEMP_CURRENT=$(grep colortemp "$STATUS_FILE" | cut -f2 -d' ')


usage () {
    echo 'Usage: backlight_redshift.sh inc|dec'
    exit 1
}

increase () {
    local BRIGHTNESS=$(echo "scale=2; $BRIGHTNESS_CURRENT + $BRIGHTNESS_STEP" | bc)
    if [ $(echo "$BRIGHTNESS > $BRIGHTNESS_MAX" | bc -l) -eq 1 ] 
        then
            BRIGHTNESS=$BRIGHTNESS_MAX
    fi
    local COLORTEMP=$(echo "$COLORTEMP_CURRENT + $COLORTEMP_STEP" | bc)

    if [ $(echo "$COLORTEMP > $COLORTEMP_MAX" | bc -l) -eq 1 ] 
        then
            COLORTEMP=$COLORTEMP_MAX
    fi

    echo "$BRIGHTNESS $COLORTEMP"
}

decrease () {
    local BRIGHTNESS=$(echo "scale=2; $BRIGHTNESS_CURRENT - $BRIGHTNESS_STEP" | bc)
    if [ $(echo "$BRIGHTNESS < $BRIGHTNESS_MIN" | bc -l) -eq 1 ] 
        then
            BRIGHTNESS=$BRIGHTNESS_MIN
    fi

    local COLORTEMP=$(echo "$COLORTEMP_CURRENT - $COLORTEMP_STEP" | bc)
    if [ $(echo "$COLORTEMP < $COLORTEMP_MIN" | bc -l) -eq 1 ] 
        then
            COLORTEMP=$COLORTEMP_MIN
    fi

    echo "$BRIGHTNESS $COLORTEMP"
}

apply () {
    #read BRIGHTNESS COLORTEMP < <($1)
    BRIGHTNESS=$(echo $1 | cut -f 1 -d ' ')
    COLORTEMP=$(echo $1 | cut -f 2 -d ' ')

    echo "BRIGHTNESS $BRIGHTNESS"
    echo "COLORTEMP $COLORTEMP"
    echo "brightness $BRIGHTNESS" > "$STATUS_FILE"
    echo "colortemp $COLORTEMP" >> "$STATUS_FILE"
    redshift -P -O ${COLORTEMP}K -b $BRIGHTNESS >/dev/null
}



if [ -z "$1" ]
    then
        usage
    else
        SIGN="$1"
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
