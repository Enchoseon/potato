#!usr/bin/python3
# Source: https://www.reddit.com/r/kde/comments/t7wj5c/comment/hzkprnf/

# Set process name to 'workModeScript.py'
def set_procname(Newname):
	newname = bytes(Newname, "utf-8")
	from ctypes import cdll, byref, create_string_buffer
	libc = cdll.LoadLibrary("libc.so.6")    #Loading a 3rd party library C
	buff = create_string_buffer(len(newname)+1) #Note: One larger than the name (man prctl says that)
	buff.value = newname                 #Null terminated string as it should be
	libc.prctl(15, byref(buff), 0, 0, 0) #Refer to "#define" of "/usr/include/linux/prctl.h" for the misterious value 16 & arg[3..5] are zero as the man page says.
set_procname("doNotDisturb.py")

# Import stuff
from pydbus import SessionBus
import signal
import subprocess

# Enable Do Not Disturb (stops when this script it killed)
bus = SessionBus()
remote_object = bus.get("org.freedesktop.Notifications", "/org/freedesktop/Notifications")

remote_object.Inhibit("", "", {})

signal.pause()
