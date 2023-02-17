# Potato Redux

A pomodoro timer for the shell with new features and quality-of-life changes.

<div align="left">
	<img src="https://img.shields.io/github/last-commit/Enchoseon/potato-redux?color=2A0944&labelColor=525E75&style=flat" alt="Last Commit">
	<img src="https://img.shields.io/github/languages/code-size/Enchoseon/potato-redux?color=3FA796&labelColor=525E75&style=flat" alt="Code Size">
	<!--<img src="https://img.shields.io/aur/version/potato-redux?color=FEC260&labelColor=525E75&style=flat" alt="AUR Version">-->
	<img src="https://img.shields.io/github/license/Enchoseon/potato-redux?color=A10035&labelColor=525E75&style=flat" alt="License">
</div>

## Table of Contents

- [Quick Start](#quick-start)
- [Usage](#usage)
- [Extra Features](#extra-features)
- [Notes](#notes)
- [Credits](#credits)

## Quick Start

### Installation

**Arch**: `makepkg -si`

**Manual Installation**:
1. Copy `potato.sh` to `/usr/bin/potato` *(rename `potato.sh` to `potato`)*
2. Copy `notification.wav` to `/usr/lib/potato-redux/notification.wav`
3. Copy `doNotDisturb.py` to `/usr/lib/potato-redux/doNotDisturb.py`

### Example Commands

**[52/17 Rule](https://wikipedia.org/wiki/52/17_rule)**: `potato -w52 -b17 -l0`
- *Note the use of `-l0` to disable the Long Break interval!*

**Maintainer's Personal Pick**: `potato -dtnkf`
- *Do Not Disturb, Toast Notifications, Brown Noise, KDE Connect, and Final Stats*

**???**: `potato -w 69 -b 420`

## Usage

```
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
```

## Extra Features

### Brown Noise

> Optional Dependency: `sox`

Play Brown noise while Potato runs.

### Do Not Disturb

> Optional Dependency: `python`, `dbus-python`

Turn on Do Not Disturb while Potato runs. Compatible with f.do DEs (Gnome, Plasma, XFCE).

### Toast Notifications

> Optional Dependency: `libnotify`

Send desktop toast notifications at two (2) times:
1. When the Work timer finishes
2. When the Break timer finishes

### KDE Connect Notifications

> Optional Dependency: `kdeconnect`

Send KDE Connect notifications at two (2) times:
1. When the Work timer finishes
2. When the Break timer finishes

*Note: Make sure you've opened the appropriate ports and your smartphone is a recognized device!*

## Notes

### Bugs

1. If using Do Not Disturb with Discord running in the background, Discord toast notifications will be suppressed but the Discord client will still play its own notification sound.
2. If using Do Not Disturb, Potato will temporarily disable Do Not Disturb when sending its toast notifications. This can the notifications that were queued up while in DND briefly appearing alongside Potato's toast in a wall of notification spam.

### To Do

- AUR package (once I stop making rapid changes)
- Run user bash files at key points (e.g. timer ending)
    - example use-cases:
        - updating the hosts file to block YouTube.com while in work mode
        - changing the system color scheme depending on the current mode
        - custom notification sounds for each timer
- Pause/unpause/change timer while running

## Credits

- Notification.wav, originally [zapsplat_mobile_phone_notification_003_16522.mp3](https://wayback.archive.org/https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-14566/zapsplat_mobile_phone_notification_003_16522.mp3) (reencoded as WAV with
`ffmpeg -i zapsplat_mobile_phone_notification_003_16522.mp3 -ss 0.02 -ar 24000 -filter:a "areverse,silenceremove=1:0:-50dB,areverse,volume=9.0dB" notificationNorm.wav`) obtained from [zapsplat.com](https://www.zapsplat.com/) under CC0.
- [Original Potato script created by Bladtman242](https://github.com/Bladtman242/potato)
