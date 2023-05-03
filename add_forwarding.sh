#!/bin/bash

# Author: 	Abdul Wahab
# Website: 	Linuxwebhostingsupport.in
# Purpose: 	Add an email forwarder in iRedMail.
# Function to validate email address
validate_email() {
    # Check if email address matches the correct format
    if [[ ! $1 =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "Invalid email address format. Please try again."
        exit 1
    fi
}

# Prompt the user to enter the source email address
read -p "Enter the source email address: " SOURCE_EMAIL

# Validate the source email address
validate_email "$SOURCE_EMAIL"

# Extract the domain and dest_domain from the source email address
SOURCE_DOMAIN=$(echo "$SOURCE_EMAIL" | cut -d "@" -f 2)

# Check if SOURCE_DOMAIN exists in the domain table
if ! mysql vmail -e "SELECT domain FROM domain WHERE domain='$SOURCE_DOMAIN'" | grep -q "$SOURCE_DOMAIN"; then
    echo "The domain '$SOURCE_DOMAIN' does not exist in the iRedmail database, please add the domain first to iRedmail before adding the forwarder."
    exit 1
fi

# Prompt the user to enter the destination email address
read -p "Enter the destination email address: " DESTINATION_EMAIL

# Validate the destination email address
validate_email "$DESTINATION_EMAIL"

# Extract the domain and dest_domain from the destination email address
DEST_DOMAIN=$(echo "$DESTINATION_EMAIL" | cut -d "@" -f 2)

# Print the variables for troubleshooting
echo "SOURCE_EMAIL: $SOURCE_EMAIL"
#echo "SOURCE_DOMAIN: $SOURCE_DOMAIN"
echo "DESTINATION_EMAIL: $DESTINATION_EMAIL"
#echo "DEST_DOMAIN: $DEST_DOMAIN"

# Connect to the vmail database
mysql vmail << EOF
INSERT INTO forwardings (address, forwarding, domain, dest_domain, is_forwarding, active)
SELECT '$SOURCE_EMAIL', '$DESTINATION_EMAIL', '$SOURCE_DOMAIN', '$DEST_DOMAIN', 1, 1 FROM domain WHERE domain='$SOURCE_DOMAIN';
EOF

# Check if the forwarding was added successfully
if [ $? -eq 0 ]; then
    # Print completion message
    echo "Email forwarding from $SOURCE_EMAIL to $DESTINATION_EMAIL has been added."
else
    # Print error message
    echo "Failed to add email forwarding from $SOURCE_EMAIL to $DESTINATION_EMAIL."
fi
