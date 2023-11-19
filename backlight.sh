#!/bin/bash
# xrandr --output eDP --brightness $(xrandr --display :0.0 --screen 0 --verbose | awk '/Brightness/ { print $2 - 0.10; exit }')

CURRENT=$(xrandr --display :0.0 --screen 0 --verbose | awk '/Brightness/ {print $2}')
MIN=0.3
MAX=1


function usage {
    echo 'Usage: backlight.sh inc|dec [step]'
    exit 1
}

function increase {
    NEXT_STEP=$(echo "scale=2; $CURRENT + $STEP" | bc)
    if [ $(echo "$NEXT_STEP > $MAX" | bc -l) -eq 1 ] 
        then
            NEXT_STEP=$MAX
    fi
    xrandr --output eDP --brightness "$NEXT_STEP"
}

function decrease {
    NEXT_STEP=$(echo "scale=2; $CURRENT - $STEP" | bc)
    if [ $(echo "$NEXT_STEP < $MIN" | bc -l) -eq 1 ] 
        then
            NEXT_STEP=$MIN
    fi
    xrandr --output eDP --brightness "$NEXT_STEP"
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
        increase
        ;;
    dec)
        decrease
        ;;
    *)
        usage
        ;;
esac
