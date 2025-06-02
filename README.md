# Development Environment Setup Script

This script (`setup.sh`) automates the installation of essential development tools on Debian/Ubuntu-based Linux distributions.

## Description

The script will perform the following actions:

1.  **Update System:** Updates package lists and upgrades existing packages.
2.  **Install Prerequisites:** Installs common prerequisite packages like `curl`, `gnupg`, `apt-transport-https`, etc.
3.  **Install Git:** Installs the Git version control system.
4.  **Install Python3-pip:** Installs pip for Python 3.
5.  **Install Node.js (LTS):** Installs the latest Long-Term Support (LTS) version of Node.js, which includes `npm` (Node Package Manager) and `npx` (Node Package Execute). It uses the NodeSource repository for this.
6.  **Install Docker:** Installs Docker Engine, Docker CLI, Containerd, Docker Buildx, and the Docker Compose plugin using Docker's official repository.
7.  **Install MongoDB:** Installs the latest stable version of MongoDB Community Edition (currently version 7.0) using MongoDB's official repository. It also attempts to start and enable the `mongod` service.
8.  **Install PostgreSQL:** Installs PostgreSQL and its `contrib` package. It also attempts to start and enable the `postgresql` service.

## Prerequisites

*   A Debian/Ubuntu-based Linux distribution (e.g., Ubuntu, Debian, Linux Mint).
*   `sudo` privileges for the user running the script.

## Setup Instructions

1.  **Clone the repository or download the script:**
    If this script is part of a Git repository, clone it. Otherwise, download `setup.sh` to your machine.

2.  **Navigate to the script's directory:**
    ```bash
    cd /path/to/your/script/directory
    # e.g., cd /home/tushski/Desktop/prj/my_setup/
    ```

3.  **Make the script executable:**
    ```bash
    chmod +x setup.sh
    ```

4.  **Run the script:**
    ```bash
    ./setup.sh
    ```
    You will be prompted for your `sudo` password during the execution as the script needs to install packages and configure system services.

5.  **Post-installation (Docker):**
    To run Docker commands without `sudo`, you'll need to add your user to the `docker` group:
    ```bash
    sudo usermod -aG docker $USER
    ```
    After running this command, you **must log out and log back in** for the group changes to take effect.

## Important Notes

*   The script uses `set -e`, which means it will exit immediately if any command fails.
*   Review the script's output for any errors or warnings during installation.
*   This script installs specific versions or uses methods (like NodeSource for Node.js) that provide up-to-date software. If you require different versions, you may need to modify the script.