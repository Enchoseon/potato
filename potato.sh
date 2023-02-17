#!/usr/bin/env bash
set -o pipefail -o noclobber -o nounset
### ========================
### Argument Var Declaration
### ========================
# Timers
WORKTIMER=25
BREAKTIMER=5
LONGBREAKTIMER=30
LONGBREAKINTERVAL=3
GRACETIMER=5
# Optional Features
DND=false
TOAST=false
NOISE=false
KDECONNECT=false
# Parity & Misc
MUTE=false
PROMPTUSER=false
FINALSTATS=false
# Debugging
SPEEDUP=false
# Nonargument
CURRENTSET=1 # Keep track of the current Pomodoro to determine when to do long breaks. One Pomodoro == 1 work period + 1 break period.
### =========
### Functions
### =========
# Print help to console
show_help() {
	cat <<-END
		usage: potato [-w --work-timer <integer>] [-b --break-timer <integer>] [-l --long-break-timer <integer>] [-i --long-break-interval <integer>] [-g --grace-timer <integer>] [-d --do-not-disturb] [-t --toast] [-n --noise] [-k --kdeconnect] [-m --mute] [-p --prompt-user] [-f --final-stats] [-s --speedup] [-h --help]
		 	(timers)
		 	-w --work-timer <integer> [default: 25]:
		 		work interval timer in minutes
		 	-b --break-timer <integer> [default 5]:
		 		break interval timer in minutes
		 	-l --long-break-timer <integer> [default 30]:
		 		long break interval timer in minutes (set this to zero (0) to disable long breaks)
		 	-i --long-break-interval <integer> [default 3]:
		 		intervals of pomodoros (one work interval + one break interval) in-between each long break-pomodoro
		 	-g --grace-timer <integer> [default 5]:
		 		grace timer in seconds. This is how long (toast and cli) notifications are shown for

		 	(extra features)
		 	-d --do-not-disturb:
		 		enable do not disturb while Potato runs
		 	-t --toast:
		 		send desktop toast whenever a timer finishes
		 	-n --noise:
		 		play brown noise
		 	-k --kdeconnect:
		 		send KDE Connect notification whenever a timer finishes

		 	(parity & misc)
		 	-m --mute:
		 		don't play a notification sound when a timer ends
		 	-p --prompt-user:
		 		prompt for user input when a timer ends (won't continue until user input is received)
		 	-f --final-stats:
		 		print stats for the entire session to the console when exiting

		 	(debugging)
		 	-s --speedup:
		 		speed up the timer (timer counts down in seconds instead of minutes)

		 	(help)
		 	-h --help:
		 		print this help message and exit
	END
	cleanup
}
# Toggle Do Not Disturb
toggle_dnd() {
	! ${DND} && return
	local ENABLE=$1
	if ${ENABLE}; then
		python "/usr/lib/potato-redux/doNotDisturb.py" &
	else
		proc=$(pgrep doNotDisturb)
		if [[ ${proc} ]]; then
			kill ${proc}
		fi
	fi
}
# Send Console, Audio, Toast, and KDE Connect Notification
send_notification() {
	local MESSAGE="$1 Interval Over!"
	printf "\n${MESSAGE} " # Console Notification
	if ! ${MUTE}; then # Audio Notification
		aplay -q "/usr/lib/potato-redux/notification.wav" &
	fi
	if ${TOAST}; then # Toast Notification
		toggle_dnd false
		notify-send --transient --expire-time $(($GRACETIMER*900)) --app-name "Potato" "${MESSAGE}" # (expire time is slightly less than GRACETIMER so that the toast can actually expire)
		sleep ${GRACETIMER}
		toggle_dnd true
	fi
	if ${KDECONNECT}; then # KDE Connect Notification
		kdeconnect-cli --refresh > /dev/null 2>&1
		local DEVICEID=$(kdeconnect-cli -l --id-only) # Grabs first device id in the list
		kdeconnect-cli --pair -d "${DEVICEID}" > /dev/null 2>&1
		kdeconnect-cli -d "${DEVICEID}" --ping-msg "${MESSAGE}" > /dev/null 2>&1
	fi
}
# Clear console with black magic (source: https://stackoverflow.com/a/16745408)
delete_lines() {
	local LINES=$1
	printf "\r\n"
	for ((i=${LINES}; i>0; i--)); do
		printf "$(tput cuu1) $(tput el)"
	done
}
# Run timer
run_timer() {
	local TIMER=$1
	local NAME=$2
	if [ ${TIMER} -eq 0 ]; then # Don't proceed if the timer is disabled (set to zero)
		return
	fi
	for ((i=${TIMER}; i>0; i--)); do # Interval Timer
		printf "\r%im remaining in %s interval " "${i}" "${NAME}"
		if ${SPEEDUP}; then
			sleep 1s
		else
			sleep 1m
		fi
	done
	printf "\r%im remaining in %s interval " 0 "${NAME}" # Interval Over
	send_notification "${NAME}" &
	sleep ${GRACETIMER}
	if ${PROMPTUSER}; then # Wait for user input before continuing
		read -t 1 -n 10000 discard # Flush STDIN
		printf "\n\nPress any key to continue... "
		read
		delete_lines 3
	fi
	delete_lines 2
}
# Print an error and exit if missing depedency (used to fail invalid flags)
check_opt_dependency() {
	local COMMAND=$1
	local DEPENDENCY=$2
	local REMOVE=$3
	if ! command -v "${COMMAND}" &> /dev/null; then
		echo "${DEPENDENCY} is not installed! Remove ${REMOVE} or install the missing dependency!"
		cleanup
	fi
}
stty -echo # Hide user input
cleanup() { # Clean up doNotDisturb.py and stty when exiting
	if ${FINALSTATS}; then
		printf "\n\nCompleted Pomodoros: $((${CURRENTSET}-1)) "
	fi
	stty echo
 	toggle_dnd false
 	exit
}
trap "cleanup" SIGINT
### ==========================
### Get and Validate Arguments
### ==========================
# Source: https://stackoverflow.com/a/29754866
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
	echo "Fatal Error: Enhanced getopt (util-linux) was not found!"
	cleanup
fi
LONGOPTS="work-timer:,break-timer:,long-break-timer:,long-break-interval:,grace-timer:,do-not-disturb,toast,noise,kdeconnect,mute,prompt-user,final-stats,speedup,help"
OPTIONS="w:b:l:i:g:dtnkmpfsh"
! PARSED=$(getopt --options=${OPTIONS} --longoptions=${LONGOPTS} --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
	show_help
fi
eval set -- "$PARSED"
while true; do case "$1" in
	-w|--work-timer)
		WORKTIMER=$2
		shift 2;;
	-b|--break-timer)
		BREAKTIMER=$2
		shift 2;;
	-l|--long-break-timer)
		LONGBREAKTIMER=$2
		shift 2;;
	-i|--long-break-interval)
		LONGBREAKINTERVAL=$2
		shift 2;;
	-g|--grace-timer)
		GRACETIMER=$2
		shift 2;;
	-d|--do-not-disturb)
		DND=true
		shift;;
	-t|--toast)
		TOAST=true
		shift;;
	-n|--noise)
		NOISE=true
		shift;;
	-k|--kdeconnect)
		KDECONNECT=true
		shift;;
	-m|--mute)
		MUTE=true
		shift;;
	-p|--prompt-user)
		PROMPTUSER=true
		shift;;
	-f|--final-stats)
		FINALSTATS=true
		shift;;
	-s|--speedup)
		SPEEDUP=true
		shift;;
	--)
		shift
		break;;
	-h|--help|*|\?)
		show_help;;
esac; done
$DND && check_opt_dependency "python" "Python" "Do Not Disturb flag (-d)"
$TOAST && check_opt_dependency "notify-send" "Libnotify" "Toast flag (-t)"
$NOISE && check_opt_dependency "play" "Sox" "Noise flag (-n)"
$KDECONNECT && check_opt_dependency "kdeconnect-cli" "Kdeconnect" "KDE Connect flag (-k)"
### ================
### Start Everything
### ================
toggle_dnd true # Start doNotDisturb.py
${NOISE} && play -n -q -c1 synth whitenoise lowpass -1 120 lowpass -1 120 lowpass -1 120 gain +14 & # Start playing brown noise
printf "\n"
while true; do # Start Pomodoro timer
	run_timer ${WORKTIMER} "Work"
	if [ `expr ${CURRENTSET} % $(( ${LONGBREAKINTERVAL}+1 ))` -eq 0 ] && [ ${LONGBREAKTIMER} -ne 0 ]; then # Do a long break (special case for if LONGBREAKTIMER is zero: always do a short break)
		run_timer $LONGBREAKTIMER "Long Break"
	else # Do a short break
		run_timer $BREAKTIMER "Break"
	fi
	CURRENTSET=$(( CURRENTSET+1 ))
done
