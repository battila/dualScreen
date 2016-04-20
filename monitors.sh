#!/bin/bash

renice +19 $$ >/dev/null

OLD_STATE="disconnected"

while [ 1 ]; do
    DUAL=$(cat /sys/class/drm/card0-DP-2/status)

    if [ "$OLD_STATE" != "$DUAL" ]; then
        if [ "$DUAL" == "connected" ]; then
		echo 'Dual monitor setup'
		/usr/bin/xrandr --output eDP1 --mode 1920x1080 \
		--output DP2 --mode 1920x1080 --left-of eDP1 
		sleep 1
		fbsetbg ~/.fluxbox/backgrounds/dualHead.jpg
	else
		echo 'Single monitor setup'
		/usr/bin/xrandr --output DP2 --off \
		--output eDP1 --mode 1920x1080 --pos 0x0 --primary
		sleep 1
		fbsetbg ~/.fluxbox/backgrounds/singleHead.jpg
        fi

        OLD_STATE="$DUAL"
    fi

    inotifywait -q -e close /sys/class/drm/card0-DP-2/status >/dev/null
done

