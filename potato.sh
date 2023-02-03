#!/bin/bash

# ========================
# Argument Var Declaration
# ========================

WORKTIMER=25
BREAKTIMER=5
GRACETIMER=5
PROMPTUSER=false
MUTE=false
NOISE=false

# =========
# Functions
# =========

# Print help to console
show_help() {
	cat <<-END
		usage: potato [-w <integer>] [-b <integer>] [-g <integer>] [-n] [-m] [-p] [-h]
		    -w <integer> [default: 25]:
				work interval timer in minutes. This is how long a work interval is.
		    -b <integer> [default 5]:
				break interval timer in minutes. This is how long a break interval is.
		    -g <integer> [default 5]:
				grace timer in seconds This is how long notifications are shown for.

		    -n:
				play brown noise (requires SoX to be installed)
		    -m:
				don't play a notification sound when a timer ends
			-p:
				prompt for user input when a timer ends (won't continue until user input in received)

		    -h:
				print this help message and exit
	END
}

# Play notification sound
play_notification() {
	aplay -q "/usr/lib/potato/notification.wav" &
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
	notify-send -a "Potato" "$message"
	sleep $GRACETIMER
	toggle_dnd true
}

# Prompt/wait for user input
prompt_user() {
	echo "Press any key to continue..."
	read
}

# Run timer
run_timer() {
	TIMER=$1
	NAME=$2
 	COMPLETIONMESSAGE="$NAME Interval Over!"
	# "X" Interval Timer
	for ((i=$TIMER; i>0; i--))
	do
		printf "\r%im remaining in %s interval" $i $NAME
		sleep 1s
	done
	printf "\r%im remaining in %s interval" 0 $NAME
	# "X" Interval Over
	! $MUTE && play_notification
	send_toast $COMPLETIONMESSAGE &
	printf "\n$COMPLETIONMESSAGE"
	sleep $GRACETIMER
	# Wait for user input before continuing
	$PROMPTUSER && prompt_user
	# Clear two lines with black magic (source: https://stackoverflow.com/a/16745408)
	printf "\r\n"
	UPLINE=$(tput cuu1)
	ERASELINE=$(tput el)
	echo "$UPLINE$ERASELINE$UPLINE$ERASELINE$UPLINE$ERASELINE"
}

# Clean up doNotDisturb.py when exiting
stty -echoctl
cleanup() {
	toggle_dnd false
	exit
}
trap "cleanup" SIGINT

# =============
# Get Arguments
# =============

# Print help to console
show_help() {
	cat <<- EOF
		Usage: potato [-w <integer>] [-b <integer>] [-n] [-m] [-p] [-h]
		 	-w <integer> [default: 25]:
		 		work timer in n minutes
		 	-b <integer> [default 5]:
		 		break timer in n minutes

		 	-n:
		 		play brown noise (requires SoX to be installed)
		 	-m:
		 		don't play a notification sound when a timer ends
		 	-p:
		 		prompt for user input when a timer ends (won't continue until user input in received)

		 	-h:
		 		print this help message and exit
	EOF
	exit
}

while getopts "w: b: nmph" opt; do
	case "$opt" in
		w)
			WORKTIMER=$OPTARG
			;;
		b)
			BREAKTIMER=$OPTARG
			;;
		n)
			NOISE=true
			;;
		m)
			MUTE=true
			;;
		p)
			PROMPTUSER=true
			;;
		h|\?)
			show_help
			exit 1
			;;
	esac
done

# ====================
# Start Other Features
# ====================

# Start doNotDisturb.py
toggle_dnd true

# Start playing brown noise
if $NOISE; then
	if ! command -v "play" &> /dev/null
	then
		echo "SoX is not installed!"
		exit
	else
		play -n -q -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14 &
	fi
fi

# ==============
# Pomodoro Timer
# ==============

printf "\n"
while true
do
	run_timer $WORKTIMER "Work"
	run_timer $BREAKTIMER "Break"
done
