##Shell Scripting for Security
###Overview
This project contains a Bash script designed for security monitoring on Linux systems. The script performs two main functions:

Scans for listening TCP ports using ss or netstat and emails the results.
Parses /var/log/auth.log for failed SSH login attempts and blocks suspicious IPs using iptables.

###Features

Port Scanning: Identifies open TCP ports and logs results.
SSH Security: Detects failed SSH login attempts and automatically blocks IPs exceeding a threshold (default: 5 attempts).
Email Notifications: Sends port scan results to a specified email address.
Logging: Maintains logs of port scans and blocked IPs for auditing.

###Prerequisites

Linux system with Bash
Installed tools: ss or netstat, iptables, mail
Configured mail system (e.g., Postfix) for email notifications
Root privileges for running the script

###Installation

Clone the repository:git clone https://github.com/aesthetic-dee/.git


Navigate to the project directory:cd security-shell-script


Make the script executable:chmod +x security_scan.sh



###Usage

Edit the security_scan.sh script to set your email address:EMAIL="your-email@example.com"


Run the script as root:sudo ./security_scan.sh


(Optional) Schedule the script using cron for regular execution:crontab -e
# Add: 0 * * * * /path/to/security_scan.sh



###Configuration

EMAIL: Set the recipient email for port scan results.
THRESHOLD: Number of failed SSH attempts before blocking an IP (default: 5).
LOG_FILE: Path for storing port scan logs (/var/log/port_scan.log).
BLOCKED_IPS: Path for storing blocked IPs (/var/log/blocked_ips.log).

###Files

security_scan.sh: Main script for port scanning and SSH security.
README.md: This file.

###Notes

Ensure your system has a working mail setup for email notifications.
iptables rules may need adjustment based on your system's firewall configuration.
Logs are stored in /var/log/; ensure write permissions for these files.
The script checks for both ss and netstat, using ss preferentially.

###Contributing

Fork the repository.
Create a new branch (git checkout -b feature-branch).
Make your changes and commit (git commit -m "Add feature").
Push to the branch (git push origin feature-branch).
Open a Pull Request.

License
This project is licensed under the MIT License - see the LICENSE file for details.
Disclaimer
Use this script responsibly. Ensure compliance with your organization's security policies and applicable laws. The script modifies iptables rules, which may affect network connectivity if misconfigured.
