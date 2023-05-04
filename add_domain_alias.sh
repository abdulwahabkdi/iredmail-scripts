#!/bin/bash

# Author: 	Abdul Wahab
# Website: 	Linuxwebhostingsupport.in
# Print purpose and note
printf "Purpose: Add an alias domain in iRedMail. \n\n"
printf "Note: Let's say you have a mail domain example.com hosted on your iRedMail server, if you add domain name domain.ltd as an alias domain of example.com, all emails sent to username@domain.ltd will be delivered to user username@example.com's mailbox. So here domain.ltd is the alias domain and example.com is the traget domain \n\n"

# Prompt the user to enter the alias domain name
read -p "Enter the alias domain name: " ALIAS_DOMAIN

# Prompt the user to enter the target domain name
read -p "Enter the target domain name: " TARGET_DOMAIN

# Connect to the vmail database and check if the target domain exists in the domain table
RESULT=`mysql vmail -N -B -e "SELECT COUNT(*) FROM domain WHERE domain='$TARGET_DOMAIN'"`
if [ $RESULT -ne 1 ]
then
  echo "Error: The target domain $TARGET_DOMAIN does not exist in the domain table. You need to add the target domain first"
  exit 1
fi

# Insert the alias domain record
mysql vmail <<EOF
INSERT INTO alias_domain (alias_domain, target_domain)
VALUES ('$ALIAS_DOMAIN', '$TARGET_DOMAIN');
EOF

# Print completion message
echo "Alias domain $ALIAS_DOMAIN has been added for $TARGET_DOMAIN."
