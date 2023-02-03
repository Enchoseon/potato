#!/bin/bash

WORK=25
PAUSE=5
INTERACTIVE=true
MUTE=false
NOISE=false

# Print help to console
show_help() {
	cat <<-END
		usage: potato [-s] [-m] [-w m] [-b m] [-n] [-h]
		    -s: simple output. Intended for use in scripts
		        When enabled, potato outputs one line for each minute, and doesn't print the bell character
		        (ascii 007)

		    -m: mute -- don't play sounds when work/break is over
		    -w m: let work periods last m minutes (default is 25)
		    -b m: let break periods last m minutes (default is 5)
		    -n: play noise
		    -h: print this message
	END
}

# Play notification sound
play_notification() {
	aplay -q /usr/lib/potato/notification.wav&
}

# Toggle Do Not Disturb
toggle_dnd() {
	enableDnd=$1
	if $enableDnd; then
		python /usr/lib/potato/doNotDisturb.py &
	else
		proc=$(pgrep doNotDisturb)
		if [[ $proc ]]; then
			kill $proc
		fi
	fi
}

# Send Toast Notification
send_toast() {
	message=$1
	toggle_dnd false
	notify-send -a "Potato Mode" "$message"
	sleep 5
	toggle_dnd true
}

# Cleanup Do Not Disturb script when exiting
stty -echoctl
cleanup() {
	toggle_dnd false
	exit
}
trap "cleanup" SIGINT

# Enable Do Not Disturb
toggle_dnd true

# Get Arguments
while getopts :swn:b:m opt; do
	case "$opt" in
	s)
		INTERACTIVE=false
	;;
	m)
		MUTE=true
	;;
	w)
		WORK=$OPTARG
	;;
	b)
		PAUSE=$OPTARG
	;;
	n)
		NOISE=true
	;;
	h|\?)
		show_help
		exit 1
	;;
	esac
done

if $NOISE; then
	play -n -q -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14 &
fi

time_left="%im left of %s "

if $INTERACTIVE; then
	time_left="\r$time_left"
else
	time_left="$time_left\n"
fi

while true
do
	for ((i=$WORK; i>0; i--))
	do
		printf "$time_left" $i "work"
		sleep 1m
	done

	# Work Over
	! $MUTE && play_notification
	send_toast "Work over" &
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Work over"
		read
	fi

	for ((i=$PAUSE; i>0; i--))
	do
		printf "$time_left" $i "pause"
		sleep 1m
	done

	# Pause Over
	! $MUTE && play_notification
	send_toast "Pause over" &
	if $INTERACTIVE; then
		read -d '' -t 0.001
		echo -e "\a"
		echo "Pause over"
		read
	fi
done
