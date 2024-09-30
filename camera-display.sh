#!/bin/bash

# Configuration Variables
RTSP_URL="rtsp://user:password@0.0.0.0:554/Streaming/Channels/101"
OVERLAY_IMAGE="overlay.png"
OVERLAY_TEXT="Recording in Progress"
OVERLAY_FONTSIZE="48"
OVERLAY_FONTCOLOR="white"
OVERLAY_TEXTPOS="x=W-550:y=20"
CEC_ENABLE=false
CEC_ADDRESS="0.0.0.0" # Get by running "echo 'scan' | cec-client -s -d 1"

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Extract IP address from RTSP_URL
CAMERA_IP=$(echo "$RTSP_URL" | sed -E 's#rtsp://[^@]+@([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*#\1#')

# Make OVERLAY_IMAGE a full path
OVERLAY_IMAGE="$SCRIPT_DIR/$OVERLAY_IMAGE"

# Variables
LOG_FILE="/tmp/camera-display.log"
FFPLAY_PID=""
PING_TIMEOUT=1
PING_COUNT=1
WATCHDOG_INTERVAL=5

# Function to write logs
log_event() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" >> "$LOG_FILE"
}

# Function to check if the camera is reachable
check_camera() {
    ping -c $PING_COUNT -W $PING_TIMEOUT $CAMERA_IP > /dev/null 2>&1
    return $?
}

# Function to start ffplay with overlay
start_ffplay() {
    log_event "Starting ffplay..."
    echo "Starting ffplay..."
    ffplay -fs -i "$RTSP_URL" \
        -vf "movie=$OVERLAY_IMAGE [overlay]; \
        [in][overlay] overlay=0:0, \
        drawtext=text='$OVERLAY_TEXT':'$OVERLAY_TEXTPOS':fontsize='$OVERLAY_FONTSIZE':fontcolor='$OVERLAY_FONTCOLOR':alpha='if(gte(mod(t\,1)\,0.5)\,1\,0)'" \
        -an &
    FFPLAY_PID=$!
    log_event "ffplay started with PID $FFPLAY_PID."
}

# Function to stop ffplay
stop_ffplay() {
    if [ ! -z "$FFPLAY_PID" ]; then
        log_event "Stopping ffplay (PID: $FFPLAY_PID)..."
        echo "Stopping ffplay (PID: $FFPLAY_PID)..."
        kill $FFPLAY_PID 2>/dev/null
        wait $FFPLAY_PID 2>/dev/null
        FFPLAY_PID=""
        log_event "ffplay stopped."
    fi

    # Kill any remaining ffplay processes
    pkill -f ffplay
    log_event "Any remaining ffplay instances killed."
}

# Function to restart ffplay
restart_ffplay() {
    log_event "Restarting ffplay..."
    echo "Restarting ffplay..."
    stop_ffplay
    start_ffplay
}

# Cleanup function
cleanup() {
    log_event "Cleaning up before exit..."
    echo "Cleaning up..."
    stop_ffplay
    exit 0
}

# Set up trap to catch termination signals
trap cleanup SIGINT SIGTERM

# Initial camera check and ffplay start if online
if check_camera; then
    log_event "Camera is online. Starting ffplay..."
    echo "Camera is online. Starting ffplay..."
    start_ffplay
else
    log_event "Camera is offline. Waiting for it to come online..."
    echo "Camera is offline. Waiting for it to come online..."
fi

# Check if CEC_ENABLE is true, and run CEC command if so
if [ "$CEC_ENABLE" = true ]; then
    log_event "CEC is enabled. Turning on the display via CEC."
    echo "CEC is enabled. Turning on the display via CEC."
    echo "on $CEC_ADDRESS" | cec-client -s -d 1
else
    log_event "CEC is disabled. Skipping CEC command."
    echo "CEC is disabled. Skipping CEC command."
fi

# Main loop to monitor camera and ffplay
while true; do
    if check_camera; then
        if [ -z "$FFPLAY_PID" ] || ! ps -p $FFPLAY_PID > /dev/null; then
            log_event "Camera is online, but ffplay is not running. Restarting ffplay..."
            echo "Camera is online, but ffplay is not running. Restarting..."
            restart_ffplay
        fi
    else
        log_event "Camera is offline. Stopping ffplay and waiting..."
        echo "Camera is offline. Stopping ffplay and waiting..."
        stop_ffplay
    fi

    # Sleep for the watchdog interval before the next check
    sleep $WATCHDOG_INTERVAL
done
