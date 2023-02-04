# Potato Redux

A pomodoro timer for the shell with new features and quality-of-life changes.

<div align="left">
	<img src="https://img.shields.io/github/last-commit/Enchoseon/potato-redux?color=2A0944&labelColor=525E75&style=flat" alt="Last Commit">
	<img src="https://img.shields.io/github/languages/code-size/Enchoseon/potato-redux?color=3FA796&labelColor=525E75&style=flat" alt="Code Size">
	<!--<img src="https://img.shields.io/aur/version/potato-redux?color=FEC260&labelColor=525E75&style=flat" alt="AUR Version">-->
	<img src="https://img.shields.io/github/license/Enchoseon/potato-redux?color=A10035&labelColor=525E75&style=flat" alt="License">
</div>

# Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Optional Features](#optional-features)
- [Bugs](#bugs)
- [To Do](#to-do)
- [Credit](#credits)

# Installation

`makepkg -si`

# Usage

```
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
```

# Examples

```
# Use the 52/17 Rule (https://wikipedia.org/wiki/52/17_rule)
potato -w 52 -b 17

# Run potato with Do Not Disturb, Toast Notifications, and Brown Noise
potato -dtn

# ???
potato -w 69 -b 420
```

# Optional Features

*(You must install each feature's respective optional dependencies to use them!)*

## Brown Noise

> Dependency: `sox`

Play Brown noise while Potato runs.

## Do Not Disturb

> Dependency: `python`, `dbus-python`

Turn on Do Not Disturb while Potato runs. Compatible with f.do DEs (Gnome, Plasma, XFCE).

## Toast Notifications

> Dependency: `libnotify`

Send toast notifications at two (2) times:
1. When the Work timer finishes
2. When the Break timer finishes

# Bugs

1. If using Do Not Disturb with Discord running in the background, Discord toast notifications will be successfully blocked. However, the Discord client will still play a notification sound.
2. If using Do Not Disturb, Potato will temporarily disable Do Not Disturb to send its toast notifications. This can result in a wall of notifications that were queued up while in Do Not Disturb briefly appearing alongside Potato's toast.

# To Do

- AUR package
    - (once I stop making rapid changes)
- Custom sounds
- Run user bash files at key points (e.g. timer ending)
    - example use-case would be updating the hosts file to block YouTube.com while in work mode or changing the system color scheme depending on the current mode.

# Credits

- Notification sound (notification.wav, originally
[zapsplat_mobile_phone_notification_003_16522.mp3](https://wayback.archive.org/https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-14566/zapsplat_mobile_phone_notification_003_16522.mp3) reencoded as WAV with
ffmpeg)
obtained from [zapsplat.com](https://www.zapsplat.com/) under Creative Commons
CC0.
    - Reencoded With: `ffmpeg -i zapsplat_mobile_phone_notification_003_16522.mp3 -ss 0.02 -ar 24000 -filter:a "areverse,silenceremove=1:0:-50dB,areverse,volume=9.0dB" notificationNorm.wav`
        - `-ss 0.02`: trim first 0.02 seconds of file
        - `-ar 24000`: set sample rate to 24000Hz
        - filter `a "areverse,silenceremove=1:0:-50dB,areverse`: trim silence at end of file
        - filter `volume=9.0dB`: increase volume by 9dB
- [Original Potato script created by Bladtman242](https://github.com/Bladtman242/potato)
