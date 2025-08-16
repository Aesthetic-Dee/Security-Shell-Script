#!/bin/bash

# Configuration
EMAIL="admin@example.com"
LOG_FILE="/var/log/port_scan.log"
THRESHOLD=5  # Number of failed SSH attempts before blocking
BLOCKED_IPS="/var/log/blocked_ips.log"

# Function to check if required tools are installed
check_requirements() {
    for cmd in netstat ss iptables mail; do
        if ! command -v $cmd &> /dev/null; then
            echo "Error: $cmd is not installed."
            exit 1
        fi
    done
}

# Function to scan TCP ports
scan_ports() {
    echo "Scanning TCP ports..." > $LOG_FILE
    echo "Date: $(date)" >> $LOG_FILE
    echo "------------------------" >> $LOG_FILE
    
    # Try ss first, fallback to netstat
    if command -v ss &> /dev/null; then
        ss -tuln | grep LISTEN >> $LOG_FILE
    else
        netstat -tuln | grep LISTEN >> $LOG_FILE
    fi
    
    # Email the results
    mail -s "TCP Port Scan Results - $(hostname)" $EMAIL < $LOG_FILE
}

# Function to parse auth.log and block suspicious IPs
block_ssh_attackers() {
    echo "Checking for failed SSH attempts..."
    
    # Create temporary file for processing
    TEMP_FILE=$(mktemp)
    
    # Look for failed SSH attempts in auth.log
    grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c > $TEMP_FILE
    
    # Process each IP
    while read -r count ip; do
        if [ $count -ge $THRESHOLD ]; then
            # Check if IP is already blocked
            if ! grep -Fx "$ip" $BLOCKED_IPS > /dev/null; then
                echo "Blocking IP: $ip (Attempts: $count)"
                # Add iptables rule to drop traffic from this IP
                iptables -A INPUT -s "$ip" -j DROP
                echo "$ip" >> $BLOCKED_IPS
                echo "Blocked IP $ip at $(date)" >> $LOG_FILE
            fi
        fi
    done < $TEMP_FILE
    
    # Clean up
    rm $TEMP_FILE
}

# Main execution
check_requirements
scan_ports
block_ssh_attackers

echo "Script completed. Results emailed to $EMAIL and logged to $LOG_FILE"