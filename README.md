# potato

A pomodoro timer for the shell. This fork sends toasts and enables Do Not Disturb.

This is just a highly opinionated tweak for my own personal use, it's not an "improved" version.

# Installation

`makepkg -si`

# Usage

```
usage: potato [-s] [-m] [-w m] [-b m] [-n] [-h]
  -s: simple output. Intended for use in scripts
      When enabled, potato outputs one line for each minute, and doesn't print the bell character
      (ascii 007)

  -m: mute -- don't play sounds when work/break is over
  -w m: let work periods last m minutes (default is 25)
  -b m: let break periods last m minutes (default is 5)
  -n: play noise
  -h: print this message
```

# New Features of This Fork

### Brown Noise

Run `potato -n true` to play some brown noise while potato runs.

### Do Not Disturb

While Potato runs, Do Not Disturb will be turned on

This should work for all f.do DEs (Gnome, Plasma, XFCE), though I've only actually used it on Plasma.

### Toasts

Toast notifications are sent at two (2) times:
1. When the Work timer finishes
2. When the Pause timer finishes

# Bugs

1. If you have Discord running in the background you won't get any toast notifications because of Do Not Disturb, but you'll still hear the notification sound even if it's minimized.
2. The script temporarily disables Do Not Disturb to send its toast notifications, which can result in notification spam.
3. Because of the bell character, the script technically already sends a toast notification. This can be fixed by running potato with simple mode, but it really should just be configurable.

## Credits
Notification sound (notification.wav, originally
zapsplat\_mobile\_phone\_notification\_003.mp3 decoded and saved as wav with
mpg123)
obtained from [zapsplat.com](https://www.zapsplat.com/) under Creative Commons
CC0.

