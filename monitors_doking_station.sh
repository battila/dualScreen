#!/bin/bash

renice +19 $$ >/dev/null

while [ 1 ]; do
	if [ -e /sys/class/drm/card0-DP-3/status ]; then
		echo 'Docking station setup'
		sleep 2
		echo -e '\tsetup mirror'
		/usr/bin/xrandr --output eDP1 --mode 1920x1080 --output DP1-1 --mode 1920x1080 --same-as eDP1
		fbsetbg ~/.fluxbox/backgrounds/singleHead.jpg
		if [ -e /sys/class/drm/card0-DP-4/status ]; then
			sleep 2
			echo -e '\tsetup second display'
			/usr/bin/xrandr --output DP1-2 --mode 1920x1080 --right-of DP1-1
			sleep 1
			fbsetbg ~/.fluxbox/backgrounds/dualHead.jpg
		fi

	else
		echo 'Single monitor setup'
		/usr/bin/xrandr --output DP1-1 --off --output DP1-2 --off --output eDP1 --mode 1920x1080 --pos 0x0 --primary
		sleep 1
		fbsetbg ~/.fluxbox/backgrounds/singleHead.jpg
    fi
    inotifywait -r /sys/class/drm/ 2>/dev/null
done

