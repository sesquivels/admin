#!/bin/bash

#==================================================================================
# TITLE: ULTIMATE LINUX DEPLOYMENT SCRIPT v4.0
# AUTHOR: Serguei Esquivel S APR 2026
# DESCRIPTION: Automated post-cloning setup for RHEL-based and Debian-based VMs.
# FEATURES: Interface auto-detection, LVM Expansion, Bulk User Creation, 
#           and RHEL Subscription management.
# USAGE: sudo ./setup.sh <IP_ADDRESS/MASK> (e.g., ./setup.sh 10.20.25.77/22)
#==================================================================================

# --- GLOBAL ARGUMENTS & STATIC NETWORK CONFIG ---
# IP_CIDR: Provided as the first argument (Required for Phase 1)
IP_CIDR=$1
# Default Gateway and DNS for the Cartago/Corporate segment
GW="10.20.24.2"
DNS="10.20.24.17 8.8.8.8"

# PRIVILEGE CHECK: Ensure the script runs with root/sudo permissions
if [[ $EUID -ne 0 ]]; then
   echo "CRITICAL ERROR: This script requires root privileges."
   exit 1
fi

#==================================================================================
# PHASE 1: NETWORK CONFIGURATION (MANDATORY)
# LOGIC:
# 1. Scans 'nmcli' for the first physical ethernet device (ignores virtual bridges).
# 2. Maps the hardware device to its NetworkManager Connection Name.
# 3. Applies static IPv4 settings and restarts the interface to flush DHCP leases.
#==================================================================================
function configure_network() {
    echo -e "\n--- Phase 1: Network Configuration ---"
    if [[ -z "$IP_CIDR" ]]; then
        echo "ERROR: Network Phase requires an IP argument. Example: ./setup.sh 10.20.x.x/22"
        exit 1
    fi

    # Filter out virbr, docker, and loopback to find the real NIC (e.g., ens192, eth0)
    TARGET_INT=$(nmcli -t -f DEVICE,TYPE device status | grep ":ethernet" | grep -vE "virbr|docker|vnet|lo" | head -n 1 | cut -d: -f1 | tr -d '\r')
    
    # Cross-reference Device Name with Connection Name (vital for cloned VMs)
    CON_NAME=$(nmcli -t -f NAME,DEVICE connection show --active | grep ":$TARGET_INT" | cut -d: -f1 | tr -d '\r')
    [[ -z "$CON_NAME" ]] && CON_NAME=$(nmcli -t -f NAME,DEVICE connection show | grep ":$TARGET_INT" | head -n 1 | cut -d: -f1 | tr -d '\r')
    CON_NAME=${CON_NAME:-$TARGET_INT}

    echo "Configuring Interface: $TARGET_INT using Connection: $CON_NAME"
    
    # Apply changes and toggle device to force immediate IP assignment
    nmcli connection modify "$CON_NAME" ipv4.addresses "$IP_CIDR" ipv4.gateway "$GW" ipv4.dns "$DNS" ipv4.method manual connection.autoconnect yes
    nmcli device disconnect "$TARGET_INT" && nmcli device connect "$TARGET_INT"
    echo "Network Phase Applied Successfully."
}

#==================================================================================
# PHASE 2: STORAGE EXPANSION (MANDATORY - RPM BASED)
# LOGIC:
# 1. Identifies the root LVM path dynamically (supports ol-root, rl-root, etc.).
# 2. Uses 'sfdisk' with --force to extend the partition table to disk limits.
# 3. Refreshes the Kernel using 'partx' and 'partprobe' (Crucial for OL7).
# 4. Executes 'pvresize' and 'lvextend' with the -r flag to grow XFS/EXT4 online.
#==================================================================================
function expand_storage() {
    echo -e "\n--- Phase 2: Storage Expansion ---"
    
    # Find Volume Group and Logical Volume names for the '/' mount
    ROOT_DEV=$(df / | tail -n1 | awk '{print $1}')
    VG_NAME=$(vgs --noheadings -o vg_name | awk '{print $1}' | tr -d '\r\n[:space:]')
    LV_NAME=$(lvs --noheadings -o lv_name "$ROOT_DEV" | awk '{print $1}' | tr -d '\r\n[:space:]')
    FULL_LV_PATH="/dev/mapper/${VG_NAME}-${LV_NAME}"

    # Identify the Physical Volume (e.g., /dev/sda2) and parent Disk (e.g., /dev/sda)
    REAL_PV=$(pvs --noheadings -o pv_name | awk '{print $1}' | head -n1 | tr -d '\r\n[:space:]')
    RAW_DISK=$(lsblk -no PKNAME "$REAL_PV" | head -n1 | tr -d '\r\n[:space:]')
    FINAL_DISK="/dev/$(echo $RAW_DISK | sed 's/[^a-zA-Z0-9]//g')"
    FINAL_PART=$(echo "$REAL_PV" | grep -o '[0-9]*$' | head -n1 | tr -d '\r\n[:space:]')

    echo "Expanding $FINAL_DISK partition $FINAL_PART to maximum capacity..."
    
    # --force is used to bypass partition 1 geometry alignment warnings in Oracle/RHEL
    echo ",+" | sfdisk -N "$FINAL_PART" --force --no-reread "$FINAL_DISK" 2>/dev/null
    
    # Force Kernel to re-read the partition table without a reboot
    sync && partx -u "$REAL_PV" 2>/dev/null && partprobe "$FINAL_DISK" 2>/dev/null
    
    # Expand LVM and Filesystem online (-r flag handles xfs_growfs/resize2fs)
    pvresize "$REAL_PV" && lvextend -r -l +100%FREE "$FULL_LV_PATH"
    echo "Storage Expansion Completed."
}

#==================================================================================
# PHASE 3: OPTIONAL USER CREATION
# LOGIC:
# - Admin: Creates a sudo-enabled user (wheel group) with a random 12-char password.
# - Training: Bulk creates 'studentX' accounts with unique 10-char passwords.
# - Credentials are cached in variables/arrays for the final summary display.
#==================================================================================
function create_users_logic() {
    # SINGLE ADMIN USER BLOCK
    echo -ne "\n[OPTIONAL] Create a sudo admin user? (y/n): "
    read -r ans
    if [[ "$ans" =~ ^([yY])$ ]]; then
        echo -ne "Enter Admin Username: "
        read -r NEW_USER
        PASS=$(date +%s | sha256sum | base64 | head -c 12)
        useradd -m -G wheel "$NEW_USER" && echo "$NEW_USER:$PASS" | chpasswd
        # Uncomments wheel group in sudoers to ensure admin rights
        sed -i 's/^# %wheel\tALL=(ALL)\tALL/%wheel\tALL=(ALL)\tALL/' /etc/sudoers
        ADMIN_INFO="ADMIN: $NEW_USER | PASS: $PASS"
    fi

    # BULK TRAINING USERS BLOCK
    echo -ne "[OPTIONAL] Is this VM for training purposes? (y/n): "
    read -r ans
    if [[ "$ans" =~ ^([yY])$ ]]; then
        echo -ne "How many student accounts are required?: "
        read -r COUNT
        declare -g -a STU_LIST
        for (( i=1; i<=COUNT; i++ )); do
            S_USER="student$i"
            # Random seed includes nanoseconds to ensure uniqueness in fast loops
            S_PASS=$(date +%s%N$i | sha256sum | base64 | head -c 10)
            useradd -m "$S_USER" && echo "$S_USER:$S_PASS" | chpasswd
            STU_LIST+=("$S_USER | $S_PASS")
        done
    fi
}

#==================================================================================
# PHASE 4: SYSTEM UPDATES & RHEL REGISTRATION
# LOGIC:
# 1. If Red Hat is detected, requests RH Subscription credentials.
# 2. Uses 'read -rs' for the password to ensure it is not echoed to the terminal.
# 3. Detects 'dnf' vs 'yum' and runs a full system update.
#==================================================================================
function os_update() {
    echo -e "\n--- Phase 4: OS Updates & Subscription (Optional) ---"
    echo -ne "Do you want to run system updates now? (y/n): "
    read -r update_ans
    if [[ "$update_ans" =~ ^([yY])$ ]]; then
        # Check /etc/os-release for "Red Hat" string
        if grep -qi "red hat" /etc/os-release; then
            echo "RED HAT detected. Subscription required for updates."
            echo -ne "Register system now? (y/n): "
            read -r reg_ans
            if [[ "$reg_ans" =~ ^([yY])$ ]]; then
                echo -ne "RH Username/Email: "
                read -r RH_USER
                echo -ne "RH Password: "
                read -rs RH_PASS # Secure input (Silent)
                echo -e "\nRegistering with Subscription Manager..."
                subscription-manager register --username "$RH_USER" --password "$RH_PASS" --auto-attach
            fi
        fi
        
        # Package Manager Selection
        PKG_MGR="yum"
        command -v dnf &>/dev/null && PKG_MGR="dnf"
        echo "Running $PKG_MGR update -y... Please wait."
        $PKG_MGR update -y
    fi
}

#==================================================================================
# MAIN MENU & EXECUTION FLOW
#==================================================================================
function mainmenu() {
   echo -ne "\n#==================================================\n#   LINUX DEPLOYMENT SCRIPT v4.0 (Global Edition)  \n#==================================================\n
Target Environment Selection:
1) RHEL / Rocky / Oracle Linux (Standard Lab Flow)
2) Debian / Ubuntu (Network + Users Only)
0) Exit\n
Selection: "
   read -r ans
   case $ans in
      1)
         clear
         configure_network
         expand_storage
         create_users_logic
         os_update
         print_summary
         ;;
      2)
         clear
         configure_network
         create_users_logic
         os_update
         print_summary
         ;;
      0) exit 0 ;;
      *) echo "Invalid option."; exit 1 ;;
   esac
}

#==================================================================================
# FINAL SUMMARY: Displays all generated credentials at the very end
#==================================================================================
function print_summary() {
    echo -e "\n\n=================================================="
    echo "          POST-DEPLOYMENT CREDENTIALS             "
    echo "=================================================="
    [[ -n "$ADMIN_INFO" ]] && echo -e "  $ADMIN_INFO"
    if [[ ${#STU_LIST[@]} -gt 0 ]]; then
        echo "--------------------------------------------------"
        printf "  %-15s | %-15s\n" "STUDENT USER" "PASSWORD"
        for s in "${STU_LIST[@]}"; do echo "  $s"; done
    fi
    echo "=================================================="
    echo -e "Deployment finished. Documentation: internal-wiki.local/docs/vm-setup\n"
}

# Script Start
mainmenu
