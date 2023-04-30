#!/bin/bash

# Prompt the user to enter the source email address
read -p "Enter the source email address: " SOURCE_EMAIL

# Extract the domain and dest_domain from the source email address
SOURCE_DOMAIN=$(echo $SOURCE_EMAIL | cut -d "@" -f 2)

# Prompt the user to enter the destination email address
read -p "Enter the destination email address: " DESTINATION_EMAIL

# Extract the domain and dest_domain from the destination email address
DEST_DOMAIN=$(echo $DESTINATION_EMAIL | cut -d "@" -f 2)

# Print the variables for troubleshooting
echo "SOURCE_EMAIL: $SOURCE_EMAIL"
#echo "SOURCE_DOMAIN: $SOURCE_DOMAIN"
echo "DESTINATION_EMAIL: $DESTINATION_EMAIL"
#echo "DEST_DOMAIN: $DEST_DOMAIN"

# Connect to the vmail database
mysql  vmail << EOF
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding, active)
VALUES ('$SOURCE_EMAIL', '$DESTINATION_EMAIL', '$SOURCE_DOMAIN', '$DEST_DOMAIN', 1, 1);
EOF

# Print completion message
echo "Email forwarding from $SOURCE_EMAIL to $DESTINATION_EMAIL has been added."
