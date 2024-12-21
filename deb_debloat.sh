# deb_debloat.sh

#!/bin/bash

# Function to show a progress bar
show_progress_bar() {
    local completed=$1
    local total=$2
    local width=50
    local progress=$((completed * width / total))

    printf "\r["
    for ((i = 0; i < width; i++)); do
        if [ $i -lt $progress ]; then
            printf "="
        else
            printf " "
        fi
    done
    printf "] %d%%" $((completed * 100 / total))
}

# Function to check if the script is run with sudo privileges
check_sudo() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script requires root privileges. Please run it with sudo."
        exit 1
    fi
}

# Function to install sudo if not present
install_sudo() {
    if ! command -v sudo &>/dev/null; then
        echo "sudo is not installed. Installing sudo..."
        apt-get update &>/dev/null && apt-get install -y sudo &>/dev/null
        if [ $? -ne 0 ]; then
            echo "Error: Failed to install sudo. Exiting."
            exit 1
        fi
    fi
}

# Function to confirm user actions
confirm_action() {
    read -r -p "$1 (y/N): " response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check for sudo privileges
check_sudo

# Install sudo if not present
install_sudo

# Initialize variables
TOTAL_STEPS=6
CURRENT_STEP=0

# Step 1: Capture initial memory usage
echo "Capturing initial memory usage..."
initial_memory=$(free -m | awk '/^Mem:/ { print $3 }')
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS
sleep 1

# Step 2: Disable unnecessary services
echo "\nDisabling unnecessary services..."
SERVICES=("bluetooth.service" "cups.service" "avahi-daemon.service" "ModemManager.service")
for SERVICE in "${SERVICES[@]}"; do
    systemctl disable --now "$SERVICE" &>/dev/null
    echo "Disabled $SERVICE."
done
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS
sleep 1

# Step 3: Remove unnecessary packages
echo "\nRemoving unnecessary packages..."
PACKAGES=("bluetooth" "cups" "avahi-daemon" "modemmanager")
for PACKAGE in "${PACKAGES[@]}"; do
    apt purge -y "$PACKAGE" &>/dev/null
    echo "Removed $PACKAGE."
done
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS
sleep 1

# Step 4: Perform cleanup
echo "\nPerforming cleanup..."
apt autoremove -y &>/dev/null
apt autoclean -y &>/dev/null
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS
sleep 1

# Step 5: Optimize system settings
echo "\nOptimizing system settings..."
echo 'vm.swappiness=10' >> /etc/sysctl.conf
sysctl -p &>/dev/null
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS
sleep 1

# Step 6: Finalize and capture memory usage
echo "\nFinalizing..."
final_memory=$(free -m | awk '/^Mem:/ { print $3 }')
memory_diff=$((initial_memory - final_memory))
((CURRENT_STEP++))
show_progress_bar $CURRENT_STEP $TOTAL_STEPS

# Summary
echo "\n\nDebloat process completed."
echo "Initial memory usage: ${initial_memory} MB"
echo "Final memory usage: ${final_memory} MB"
echo "Memory usage reduced by: ${memory_diff} MB"
