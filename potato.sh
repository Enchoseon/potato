#!/bin/bash
### ========================
### Argument Var Declaration
### ========================
# Timers
WORKTIMER=25
BREAKTIMER=5
GRACETIMER=5
# Optional Features
DND=false
TOAST=false
NOISE=false
KDECONNECT=false
# Parity
MUTE=false
PROMPTUSER=false
# Debugging
SPEEDUP=false
### =========
### Functions
### =========
# Print help to console
show_help() {
	cat <<-END
		usage: potato [-w <integer>] [-b <integer>] [-g <integer>] [-d] [-t] [-n] [-k] [-m] [-p] [-s] [-h]
		 	(timers)
		 	-w <integer> [default: 25]:
		 		work interval timer in minutes. This is how long a work interval is.
		 	-b <integer> [default 5]:
		 		break interval timer in minutes. This is how long a break interval is.
		 	-g <integer> [default 5]:
		 		grace timer in seconds This is how long notifications are shown for.

		 	(extra features)
		 	-d:
		 		enable do not disturb while Potato runs
		 	-t:
		 		send desktop toast whenever a timer finishes
		 	-n:
		 		play brown noise
		 	-k:
		 		send KDE Connect notification whenever a tiemr finishes

		 	(parity)
		 	-m:
		 		don't play a notification sound when a timer ends
		 	-p:
		 		prompt for user input when a timer ends (won't continue until user input is received)

		 	(debugging)
		 	-s:
		 		speed up the timer (timer counts down in seconds instead of minutes)

		 	(help)
		 	-h:
		 		print this help message and exit
	END
	exit 1
}
# Toggle Do Not Disturb
toggle_dnd() {
	! $DND && return
	local ENABLE=$1
	if $ENABLE; then
		python "/usr/lib/potato-redux/doNotDisturb.py" &
	else
		proc=$(pgrep doNotDisturb)
		if [[ $proc ]]; then
			kill $proc
		fi
	fi
}
# Send Console, Audio, Toast, and KDE Connect Notification
send_notification() {
	local MESSAGE="$1 Interval Over!"
	printf "\n$MESSAGE " # Console Notification
	if ! $MUTE; then # Audio Notification
		aplay -q "/usr/lib/potato-redux/notification.wav" &
	fi
	if $TOAST; then # Toast Notification
		toggle_dnd false
		notify-send --transient --expire-time $(($GRACETIMER*900)) --app-name "Potato" "$MESSAGE" # (expire time is slightly less than GRACETIMER so that the toast can actually expire)
		sleep $GRACETIMER
		toggle_dnd true
	fi
	if $KDECONNECT; then # KDE Connect Notification
		kdeconnect-cli --refresh > /dev/null 2>&1
		local DEVICEID=$(kdeconnect-cli -l --id-only) # Grabs first device id in the list
		kdeconnect-cli --pair -d "$DEVICEID" > /dev/null 2>&1
		kdeconnect-cli -d "$DEVICEID" --ping-msg "$MESSAGE" > /dev/null 2>&1
	fi
}
# Prompt/wait for user input
prompt_user() {
	! $PROMPTUSER && return
	read -d '' -t 0.001 # Flush STDIN
	echo "Press any key to continue..."
	read
}
# Run timer
run_timer() {
	local TIMER=$1
	local NAME=$2
	for ((i=$TIMER; i>0; i--)); do # Interval Timer
		printf "\r%im remaining in %s interval " $i $NAME
		if $SPEEDUP; then
			sleep 1
		else
			sleep 1m
		fi
	done
	printf "\r%im remaining in %s interval " 0 $NAME # Interval Over
	send_notification $NAME &
	sleep $GRACETIMER
	prompt_user # Wait for user input before continuing
	printf "\r\n" # Clear console with black magic (source: https://stackoverflow.com/a/16745408)
	UPLINE=$(tput cuu1)
	ERASELINE=$(tput el)
	echo "$UPLINE$ERASELINE$UPLINE$ERASELINE$UPLINE$ERASELINE"
}
# Print an error and exit if missing depedency (used to fail invalid flags)
check_opt_dependency() {
	local COMMAND=$1
	local DEPENDENCY=$2
	local REMOVE=$3
	if ! command -v "$COMMAND" &> /dev/null; then
		echo "$DEPENDENCY is not installed! Remove $REMOVE or install the missing dependency!"
		exit
	fi
}
stty -echo # Hide user input
cleanup() { # Clean up doNotDisturb.py and stty when exiting
	stty echo
 	toggle_dnd false
 	exit
}
trap "cleanup" SIGINT
### ==========================
### Get and Validate Arguments
### ==========================
while getopts "w: b: g: dtnk mpsh" opt; do
	case "$opt" in
		w)
			WORKTIMER=$OPTARG;;
		b)
			BREAKTIMER=$OPTARG;;
		g)
			GRACETIMER=$OPTARG;;
		d)
			DND=true;;
		t)
			TOAST=true;;
		n)
			NOISE=true;;
		k)
			KDECONNECT=true;;
		m)
			MUTE=true;;
		p)
			PROMPTUSER=true;;
		s)
			SPEEDUP=true;;
		h|\?)
			show_help;;
	esac
done
$DND && check_opt_dependency "python" "Python" "Do Not Disturb flag (-d)"
$TOAST && check_opt_dependency "notify-send" "Libnotify" "Toast flag (-t)"
$NOISE && check_opt_dependency "play" "Sox" "Noise flag (-n)"
$KDECONNECT && check_opt_dependency "kdeconnect-cli" "Kdeconnect" "KDE Connect flag (-k)"
### ================
### Start Everything
### ================
toggle_dnd true # Start doNotDisturb.py
$NOISE && play -n -q -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14 & # Start playing brown noise
printf "\n"
while true; do # Start Pomodoro timer
	run_timer $WORKTIMER "Work"
	run_timer $BREAKTIMER "Break"
done
