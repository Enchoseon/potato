#!/usr/bin/env bash
# Runs one time when Potato is started
on_start() {
    return
}
# Runs every time a timer completes. $TYPE is a string representing which timer just finished (either "Work" or "Break")
on_timer_end() {
    local TYPE=$1
    return
}
# Runs every time a timer completes a minutes. $TYPE is a string representing the current timer type (either "Work" or "Break")
on_timer_count() {
    local TYPE=$1
    return
}
# Runs every time a timer begins. $TYPE is a string representing which timer just finished (either "Work" or "Break")
on_timer_start() {
    local TYPE=$1
    return
}
# Runs when Potato exits
on_end() {
    return
}
