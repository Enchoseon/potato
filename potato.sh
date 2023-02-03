#!/bin/bash

# ========================
# Argument Var Declaration
# ========================

WORKTIMER=25
BREAKTIMER=5
GRACETIMER=5
DND=false
TOAST=false
PROMPTUSER=false
MUTE=false
NOISE=false

# =========
# Functions
# =========

# Print help to console
show_help() {
	cat <<-END
		usage: potato [-w <integer>] [-b <integer>] [-g <integer>] [-d] [-t] [-n] [-m] [-p] [-h]
		 	(timers)
		 	-w <integer> [default: 25]:
		 		work interval timer in minutes. This is how long a work interval is.
		 	-b <integer> [default 5]:
		 		break interval timer in minutes. This is how long a break interval is.
		 	-g <integer> [default 5]:
		 		grace timer in seconds This is how long notifications are shown for.

		 	(optional features)
		 	-d:
		 		enable do not disturb while Potato runs
		 	-t:
		 		enable desktop toasts
		 	-n:
		 		play brown noise

		 	(parity)
		 	-m:
		 		don't play a notification sound when a timer ends
		 	-p:
		 		prompt for user input when a timer ends (won't continue until user input in received)

		 	(help)
		 	-h:
		 		print this help message and exit
	END
}

# Play notification sound
play_notification() {
	aplay -q "/usr/lib/potato-redux/notification.wav" &
}

# Toggle Do Not Disturb
toggle_dnd() {
	! $DND && return
	enableDnd=$1
	if $enableDnd; then
		python "/usr/lib/potato-redux/doNotDisturb.py" &
	else
		proc=$(pgrep doNotDisturb)
		if [[ $proc ]]; then
			kill $proc
		fi
	fi
}

# Send Toast Notification
send_toast() {
	! $TOAST && return
	message=$1
	toggle_dnd false
	notify-send -a "Potato" "$message"
	sleep $GRACETIMER
	toggle_dnd true
}

# Prompt/wait for user input
prompt_user() {
	read -d '' -t 0.001
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
		printf "\r%im remaining in %s interval " $i $NAME
		sleep 1m
	done
	printf "\r%im remaining in %s interval " 0 $NAME
	# "X" Interval Over
	! $MUTE && play_notification
	send_toast $COMPLETIONMESSAGE &
	printf "\n$COMPLETIONMESSAGE "
	sleep $GRACETIMER
	# Wait for user input before continuing
	$PROMPTUSER && prompt_user
	# Clear two lines with black magic (source: https://stackoverflow.com/a/16745408)
	printf "\r\n"
	UPLINE=$(tput cuu1)
	ERASELINE=$(tput el)
	echo "$UPLINE$ERASELINE$UPLINE$ERASELINE$UPLINE$ERASELINE"
}

# Print an error message and exit the script if an optional dependency isn't installed
check_opt_dependency() {
	COMMAND=$1
	DEPENDENCY=$2
	MESSAGE=$3
	if ! command -v "$1" &> /dev/null; then
		echo "$DEPENDENCY is not installed! $MESSAGE"
		exit
	fi
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

while getopts "w: b: g: dtnmph" opt; do
	case "$opt" in
		w)
			WORKTIMER=$OPTARG
			;;
		b)
			BREAKTIMER=$OPTARG
			;;
		g)
			GRACETIMER=$OPTARG
			;;
		d)
			DND=true
			;;
		t)
			TOAST=true
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

# =======================================
# Check Optional Dependencies (If Needed)
# =======================================

$DND && check_opt_dependency "python" "Python" "Remove the Do Not Disturb flag (-d) or install the missing dependency!"
$TOAST && check_opt_dependency "notify-send" "Libnotify" "Remove the Toast flag (-t) or install the missing dependency!"
$NOISE && check_opt_dependency "play" "Sox" "Remove the noise flag (-n) or install the missing dependency!"

# ====================
# Start Other Features
# ====================

# Start doNotDisturb.py
toggle_dnd true

# Start playing brown noise
$NOISE && play -n -q -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14 &

# ==============
# Pomodoro Timer
# ==============

printf "\n"
while true
do
	run_timer $WORKTIMER "Work"
	run_timer $BREAKTIMER "Break"
done
