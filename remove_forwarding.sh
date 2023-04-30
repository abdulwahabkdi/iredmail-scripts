#!/bin/bash

# Prompt user for source and destination email addresses
read -p "Enter source email: " source_email
read -p "Enter destination email: " dest_email

# Remove forwarding from vmail database
mysql  vmail <<EOF
DELETE FROM forwardings
WHERE address='$source_email' AND forwarding='$dest_email';
EOF

# Print completion message
echo "Email forwarding from $source_email to $dest_email has been removed."
