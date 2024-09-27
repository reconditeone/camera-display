# Camera Display Script

This is a quick and dirty script designed to display an RTSP stream from a security camera with an overlay image and flashing text. The script is intended to be used on a monitor at the entrance of a store, letting patrons know that they are being monitored. 

## Features

- **RTSP Stream Display**: Streams video from an RTSP source, such as a security camera.
- **Overlay Image**: An image (e.g., store logo, warning graphic) is overlaid on the video stream.
- **Flashing Text**: Displays a flashing message (e.g., "You are being monitored") to alert patrons.
- **Network Watchdog**: A monitoring script periodically pings the camera to check if it's online. If the camera stops responding, it will automatically relaunch the display script when the camera comes back online.

## Use Case

This script is ideal for stores or businesses that want to show a live security feed at the entrance with a notification to patrons about surveillance. It ensures that the camera stream is always running and will recover from network or camera downtime.

## How It Works

1. **RTSP Stream**: The script uses `ffplay` to stream the camera feed from the RTSP URL. This URL is stored in a shared configuration file for easy access by all scripts.
   
2. **Overlay & Text**: An image is placed over the stream, and a flashing text warning is shown to alert patrons that they are being monitored.

3. **Watchdog**: A separate script runs in the background, pinging the camera. If the camera goes offline, the watchdog waits until it comes back online and automatically restarts the display script to ensure the stream is always up and running.

## File Structure

```bash
camera-display/
│
├── config.cfg                 # Configuration file storing RTSP URL
├── camera-display.sh          # Main script that runs the RTSP stream with overlay and text
├── run.sh                     # Watchdog script that monitors the camera and restarts the display script
└── overlay.png                # Image file for overlay (replace with your own)

### `camera-config.cfg`
This file contains the RTSP URL for the camera stream in the following format:

```bash
RTSP_URL="rtsp://user:password@192.168.1.100:554/Streaming/Channels/1"
