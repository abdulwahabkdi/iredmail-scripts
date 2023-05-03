#!/bin/bash

# Author: 	Abdul Wahab
# Website: 	Linuxwebhostingsupport.in
# Purpose: Remove an existing email forwarder


# Prompt user for source and destination email addresses
read -p "Enter source email: " source_email
read -p "Enter destination email: " dest_email

# Check if forwarding exists in vmail database
result=$(mysql vmail -se "SELECT COUNT(*) FROM forwardings WHERE address='$source_email' AND forwarding='$dest_email';")

if [ "$result" -eq "0" ]; then
  echo "Error: Forwarding from $source_email to $dest_email does not exist."
else
  # Remove forwarding from vmail database
  mysql vmail <<EOF
  DELETE FROM forwardings WHERE address='$source_email' AND forwarding='$dest_email';
EOF

  # Print completion message
  echo "Email forwarding from $source_email to $dest_email has been removed."
fi
