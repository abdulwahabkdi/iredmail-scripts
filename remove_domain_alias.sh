#!/bin/bash

# Author: 	Abdul Wahab
# Website: 	Linuxwebhostingsupport.in
# Print purpose and note
printf "Purpose: Remove an alias domain in iRedMail. \n"

# Prompt the user to enter the alias domain name
read -p "Enter the alias domain name: " ALIAS_DOMAIN

# Prompt the user to enter the target domain name
read -p "Enter the target domain name: " TARGET_DOMAIN

# Check if the alias and target domains exist in the alias_domain table
RESULT=$(mysql -N -s vmail -e "SELECT COUNT(*) FROM alias_domain WHERE alias_domain='$ALIAS_DOMAIN' AND target_domain='$TARGET_DOMAIN';")

if [[ "$RESULT" -eq "0" ]]; then
    echo "Alias domain $ALIAS_DOMAIN for target domain $TARGET_DOMAIN does not exist in the alias_domain table."
    exit 1
fi

# Connect to the vmail database and delete the alias domain record
mysql vmail <<EOF
DELETE FROM alias_domain WHERE alias_domain='$ALIAS_DOMAIN' AND target_domain='$TARGET_DOMAIN';
EOF

# Print completion message
echo "Alias domain $ALIAS_DOMAIN for target domain $TARGET_DOMAIN has been removed."
