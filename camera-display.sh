#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SCRIPT_DIR/config.cfg

# Variables
OVERLAY_IMAGE="$SCRIPT_DIR/$OVERLAY_IMAGE"
WATCHDOG_INTERVAL=5  # Time in seconds to check if ffplay is running

# Function to launch ffplay with overlays
start_ffplay() {
    ffplay -fs -i "$RTSP_URL" \
    -vf "movie=$OVERLAY_IMAGE [overlay]; \
         [in][overlay] overlay=0:0, \
         drawtext=text='$OVERLAY_TEXT':x=W-550:y=20:fontsize=48:fontcolor=white:alpha='if(gte(mod(t\,1)\,0.5)\,1\,0)'" \
    -an &
    FFPLAY_PID=$!
}

# Start the first instance of ffplay
start_ffplay

# Watchdog loop
while true; do
    if ! ps -p $FFPLAY_PID > /dev/null; then
        echo "ffplay crashed, restarting..."
        start_ffplay
    fi
    sleep $WATCHDOG_INTERVAL
done
