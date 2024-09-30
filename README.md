# Camera Display Script

This is a quick and dirty script designed to display an RTSP stream from a security camera with an overlay image and flashing text. The script is intended to be used on a monitor at the entrance of a store, letting patrons know that they are being monitored. 

## Features

- **RTSP Stream Display**: Streams video from an RTSP source, such as a security camera.
- **Overlay Image**: An image (e.g., store logo, warning graphic) is overlaid on the video stream.
- **Flashing Text**: Displays a flashing message (e.g., "You are being monitored") to alert patrons.
- **Network Watchdog**: The script periodically pings the camera to check if it's online. If the camera stops responding, it will automatically relaunch the video when the camera comes back online.

## Use Case

This script is ideal for stores or businesses that want to show a live security feed at the entrance with a notification to patrons about surveillance. It ensures that the camera stream is always running and will recover from network or camera downtime.

## Installation

1. Clone the repository and place the files in a folder (e.g., camera-display).

```bash
git clone https://github.com/reconditeone/camera-display.git
cd camera-display
```

2. Modify the file with appropriate 'RTSP_URL' variable for your camera and modify the overlay text/image as needed.

3. Replace overlay.png with your own image file for the display overlay (optional if you wish to include logo).

4. Run the the script. Additionally schedule it 

## Dependencies

- **FFMPEG/FFPLAY:** You need to have 'ffmpeg' installed on your system. Install it using your package manager:

```bash
sudo apt-get install ffmpeg   # For Debian Based Distros
sudo yum/dnf install ffmpeg   # For Red Hat Based Distros
```

- **CEC-UTILS(Optional):** If you wish to have the script power on your display and your devices support CEC; You will need to have 'cec-utils' installed on your system. Install it using your package manager:

```bash
sudo apt-get install cec-utils   # For Debian Based Distros
sudo yum/dnf install cec-utils   # For Red Hat Based Distros
```

## Modifications

'ffplay' overlay pin locations are based on the example text. I didn't play around too much with how different overlay text strings would work on placement. See https://ffmpeg.org/ffmpeg-filters.html#overlay-1 for more information on correcting any issues that crop up when modifying.

## License

This project is licensed under the MIT License. Feel free to modify and adapt it for your own use.
