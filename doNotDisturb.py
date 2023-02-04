#!usr/bin/python3
# Source: https://www.reddit.com/r/kde/comments/t7wj5c/comment/hzkprnf/
newname = bytes("doNotDisturb.py", "utf-8") # Set process name to 'doNotDisturb.py' with libc.so.6 (so that it can be easily killed by the bash script)
from ctypes import cdll, byref, create_string_buffer
libc = cdll.LoadLibrary("libc.so.6")
buff = create_string_buffer(len(newname)+1) # Null terminated string (necessary for prctl)
buff.value = newname
libc.prctl(15, byref(buff), 0, 0, 0) # Refer to "#define" of "/usr/include/linux/prctl.h" for the mysterious value 16 and arg[3..5] being zero
from pydbus import SessionBus # Imports
import signal
import subprocess
bus = SessionBus() # Suppress notifications (ends when this script is killed)
remote_object = bus.get("org.freedesktop.Notifications", "/org/freedesktop/Notifications")
remote_object.Inhibit("", "", {})
signal.pause()
