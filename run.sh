#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source $SCRIPT_DIR/config.cfg

# Extract just the IP address from the RTSP_URL (removes rtsp://, user, password, port, and streaming path)
CAMERA_IP=$(echo "$RTSP_URL" | sed -E 's#rtsp://[^@]+@([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*#\1#')

# Path to your script that runs ffplay
FFPLAY_SCRIPT="$SCRIPT_DIR/camera-display.sh"
# Ping timeout (in seconds)
PING_TIMEOUT=1
# Ping count for each attempt
PING_COUNT=1

# Function to check if camera is reachable
check_camera() {
    ping -c $PING_COUNT -W $PING_TIMEOUT $CAMERA_IP > /dev/null 2>&1
    return $?
}

# Function to restart ffplay script
restart_ffplay() {
    echo "Restarting ffplay script..."
    pkill -f camera-display.sh
    pkill -f ffplay  # Kill any running ffplay instance
    $FFPLAY_SCRIPT &
}

# Initial check to see if the camera is online
check_camera
CAMERA_ONLINE=$?

if [ $CAMERA_ONLINE -eq 0 ]; then
    echo "Camera is online, starting ffplay..."
    restart_ffplay
else
    echo "Camera is offline, waiting..."
fi

# Main loop to monitor the camera and restart ffplay when needed
while true; do
    check_camera
    CAMERA_ONLINE=$?

    if [ $CAMERA_ONLINE -eq 0 ]; then
        # Camera is online, check if ffplay is running
        if ! pgrep -f ffplay > /dev/null; then
            echo "Camera is back online, restarting ffplay..."
            restart_ffplay
        fi
    else
        echo "Camera is offline, waiting for it to come back..."
    fi

    # Sleep for a few seconds before the next check
    sleep 5
done
