#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Starting the setup process..."
echo "This script will install Docker, Git, Node.js (npm, npx), Python3-pip, MongoDB, and PostgreSQL."
echo "It is intended for Debian/Ubuntu-based Linux distributions."
echo "You may be prompted for your password for sudo commands."

# --- Update System ---
echo ""
echo "Updating package lists and upgrading existing packages..."
sudo apt update
sudo apt upgrade -y

# --- Install Prerequisites ---
echo ""
echo "Installing prerequisite packages..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg lsb-release

# --- Install Git ---
echo ""
echo "Installing Git..."
sudo apt install -y git
echo "Git installation complete. Version: $(git --version)"

# --- Install Python3-pip ---
echo ""
echo "Installing Python3-pip..."
sudo apt install -y python3-pip
echo "Python3-pip installation complete. Version: $(pip3 --version)"

# --- Install Node.js (npm, npx) ---
echo ""
echo "Installing Node.js (which includes npm and npx)..."
# Using NodeSource repository for Node.js 20.x (LTS)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
echo "Node.js, npm, and npx installation complete."
echo "Node version: $(node -v)"
echo "npm version: $(npm -v)"
if command -v npx &> /dev/null; then
    echo "npx version: $(npx --version)"
else
    echo "npx not found automatically. It should be available."
fi

# --- Install Docker ---
echo ""
echo "Installing Docker..."
# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

# Install Docker Engine, CLI, Containerd, Buildx, and Compose plugin
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
echo "Docker installation complete."
echo "Consider adding your user to the 'docker' group to run docker commands without sudo:"
echo "  sudo usermod -aG docker \$USER"
echo "You will need to log out and log back in for this change to take effect."

# --- Install MongoDB ---
echo ""
echo "Installing MongoDB (version 7.0)..."
# Import MongoDB public GPG key
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor

# Create list file for MongoDB
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt update
sudo apt install -y mongodb-org
echo "MongoDB installation complete."
echo "Starting and enabling MongoDB service (mongod)..."
sudo systemctl daemon-reload
sudo systemctl start mongod
sudo systemctl enable mongod
sudo systemctl status mongod --no-pager || echo "Warning: MongoDB service (mongod) might not be running. Check 'sudo systemctl status mongod'."

# --- Install PostgreSQL ---
echo ""
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib
echo "PostgreSQL installation complete."
echo "Starting and enabling PostgreSQL service..."
# The service is usually started and enabled automatically by the installer on Debian/Ubuntu.
# These commands ensure it is.
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql --no-pager || echo "Warning: PostgreSQL service might not be running. Check 'sudo systemctl status postgresql'."

# Install Java 21
echo ""
echo "Installing Java 21"
sudo apt install openjdk-21-jre-headless
sudo apt install maven

# --- Configure Git ---
echo ""
echo "Configuring Git..."
read -p "Enter your Git user name: " git_user_name
read -p "Enter your Git user email: " git_user_email

# Define the path to the local .gitconfig template
LOCAL_GITCONFIG_TEMPLATE="./.gitconfig" # Assumes .gitconfig is in the same directory as setup.sh
GLOBAL_GITCONFIG_PATH="$HOME/.gitconfig"

if [ -f "$LOCAL_GITCONFIG_TEMPLATE" ]; then
    echo "Found local .gitconfig template at $LOCAL_GITCONFIG_TEMPLATE"
    # Create a temporary copy to modify
    TEMP_GITCONFIG=$(mktemp)
    cp "$LOCAL_GITCONFIG_TEMPLATE" "$TEMP_GITCONFIG"

    # Replace placeholders
    sed -i "s|<name>|$git_user_name|g" "$TEMP_GITCONFIG"
    sed -i "s|<email>|$git_user_email|g" "$TEMP_GITCONFIG"

    # Copy the configured .gitconfig to the user's home directory
    cp "$TEMP_GITCONFIG" "$GLOBAL_GITCONFIG_PATH"
    echo "Git configuration has been set up at $GLOBAL_GITCONFIG_PATH"
    rm "$TEMP_GITCONFIG"
else
    echo "Warning: Local .gitconfig template not found at $LOCAL_GITCONFIG_TEMPLATE. Skipping Git user configuration."
fi

echo ""
echo "-----------------------------------------------------"
echo "All requested software installation attempts are complete."
echo "Please review the output above for any errors or warnings."
echo "For Docker, if you added your user to the 'docker' group, remember to log out and log back in."
echo "Global Git user name and email have been configured if the template was found."
echo "-----------------------------------------------------"