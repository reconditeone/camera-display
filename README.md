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
```

### `config.cfg`
This file contains the overlay text string, overlay image name, and RTSP URL for the camera stream in the following format:

```bash
RTSP_URL="rtsp://user:password@0.0.0.0:554{optional stream URL strings}"
OVERLAY_IMAGE="overlay.png"
OVERLAY_TEXT="Recording in Progress"
```

### `camera-display.sh`
The main script that streams the RTSP feed with an overlay image and flashing text. It uses the RTSP URL from the config.cfg file.

### `run.sh`
This is the one to start the activity with, it will automatically call the camera-display script. The watchdog script pings the camera to check if it's reachable. If the camera goes offline, the script waits for it to come back online and restarts the display script automatically. 

## Installation

1. Clone the repository and place the files in a folder (e.g., camera-display).

```bash
git clone https://github.com/reconditeone/camera-display.git
cd camera-display
```

2. Set up the 'config.cfg' file with the correct RTSP URL of your camera and modify the overlay text/image as needed.

3. Replace overlay.png with your own image file for the display overlay (optional if you wish to include logo).

4. Run the run.sh script which will infer the IP of the camera from the RTSP URL and make sure it responds to ping then launch camera-display.sh

## Dependencies

- **FFMPEG/FFPLAY:** You need to have 'ffmpeg' installed on your system. Install it using your package manager:

```bash
sudo apt-get install ffmpeg   # For Debian/Ubuntu
sudo yum install ffmpeg       # For Red Hat/CentOS
brew install ffmpeg           # For macOS
```

## Modifications

'ffplay' overlay pin locations are based on the example text. I didn't play around too much with how different overlay text strings would work on placement. See https://ffmpeg.org/ffmpeg-filters.html#overlay-1 for more information on correcting any issues that crop up when modifying.

## License

This project is licensed under the MIT License. Feel free to modify and adapt it for your own use.
