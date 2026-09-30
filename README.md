# MotionEye Camera Setup for Raspberry Pi

An automated, fail-safe shell script to quickly install and configure motionEye on a Raspberry Pi using the modern `libcamera` stack. This script handles system updates, dependencies, camera diagnostics, and systemd service configurations automatically.

## Features

* **Privilege Enforcement:** Automatically verifies root access before execution to prevent partial installs.
* **Fail-Safe Execution:** Aborts immediately if critical installation steps fail, protecting your system from corrupted states.
* **Unattended Updates:** Forces non-interactive package upgrades so the script doesn't hang on user prompts.
* **Graceful Diagnostics:** Tests camera hardware and continues installation even if the camera is temporarily disconnected or unresponsive.
* **Environment Fix:** Bypasses PEP 668 restrictions on newer Raspberry Pi OS versions (Bullseye/Bookworm).
* **libcamerify Integration:** Configures the `motioneye` systemd service to interface properly with modern Pi camera modules.

## Prerequisites

* Raspberry Pi running Raspberry Pi OS (Bullseye or Bookworm).
* Connected and enabled Raspberry Pi Camera Module.
* Active internet connection.

## Installation & Usage

**1. Download the script**

Download the `run.sh` script to your Raspberry Pi, or create it directly using a terminal editor:
```bash
nano run.sh
```
*(Paste the script contents into the file, save, and exit).*

**2. Make the script executable**
```bash
chmod +x run.sh
```

**3. Run the setup (Root Required)**
```bash
sudo ./run.sh
```

## What to Expect During Installation

* **Camera Test:** A preview window will appear for a maximum of 5 seconds to verify hardware functionality (requires a connected display).
* **Reboot:** The script pauses at the end. Press `[Enter]` to safely reboot the Pi and apply all `systemd` changes.

## Accessing motionEye

After the system reboots, open a web browser on any device on the same local network and navigate to:
```text
http://<your-raspberry-pi-ip>:8765
```

> **Note:** The default motionEye login is username `admin` with a blank password.
