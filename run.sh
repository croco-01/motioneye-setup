#!/bin/bash

# 1. Exit on error (except where explicitly allowed)
set -e

# 2. Enforce root privileges
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root. Please run using: sudo ./run.sh"
   exit 1
fi

# 3. Prevent apt from hanging on interactive prompts
export DEBIAN_FRONTEND=noninteractive

echo "Starting system update..."
apt-get update && apt-get full-upgrade -y
apt-get install python3-pip rpicam-apps libcamera-tools libcamera-apps v4l-utils libcamera-v4l2 -y

echo -e "\n=== Checking Camera Devices ==="
# 4. Prevent script failure if a camera is disconnected using || true
v4l2-ctl --list-devices || echo "Warning: No v4l2 devices found."

echo -e "\n=== Checking Video Formats ==="
v4l2-ctl -d /dev/video0 --list-formats-ext || echo "Warning: /dev/video0 not accessible."

echo -e "\n=== Listing rpicam Cameras ==="
rpicam-hello --list-camera || true

echo -e "\n=== Launching Camera Preview ==="
echo "A preview window should appear for ~5 seconds. (Requires a connected display)."
# Added a 5-second timeout (-t 5000) so it doesn't hang indefinitely
rpicam-hello --qt-preview -t 5000 || echo "Warning: Camera preview failed or no display attached."
echo -e "===============================\n"

echo "Configuring Python environment and installing motionEye..."
rm -rf /usr/lib/python3*/EXTERNALLY-MANAGED
python3 -m pip install motioneye
motioneye_init

# 5. Verify the service file exists before attempting to modify it
SERVICE_FILE="/etc/systemd/system/motioneye.service"
if [[ -f "$SERVICE_FILE" ]]; then
    echo "Patching motionEye service for libcamera support..."
    sed -i 's|^ExecStart=/usr/local/bin/meyectl|ExecStart=/usr/bin/libcamerify /usr/local/bin/meyectl|' "$SERVICE_FILE"
else
    echo "Error: $SERVICE_FILE was not found. Installation may have failed."
    exit 1
fi

echo "Starting services..."
systemctl enable motioneye
systemctl daemon-reload
systemctl restart motioneye

echo -e "\nInstallation complete."
# 6. Read from standard input directly (safer for some terminal emulators)
read -r -p "Press [Enter] to reboot the system now, or press [Ctrl+C] to cancel..." 
reboot
