#!/bin/bash


# Check if the script is run as root user
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi


# Check if the input file is provided in argument (contains the usernames and groups)
if [ -z "$1" ]; then
  echo "Usage: sudo $0 <filename>"
  exit 1
fi

INPUT_FILE=$1
LOG_FILE="/var/log/user_management.log"

# Create a secure directory to save secret files
mkdir -p /var/secure
chmod 700 /var/secure

# Create secure passwords file
PASSWORD_FILE="/var/secure/user_passwords.txt"
echo "USERNAME	|	PASSWORD" > "$PASSWORD_FILE"
echo "---------------------------------------------" >> "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"



# Read input file line by line
while IFS=';' read -r username groups; do

   # Remove leading/trailing whitespaces
     username=$(echo "$username" | xargs)
     groups=$(echo "$groups" | xargs)

   # Skip empty lines
     if [ -z "$username" ]; then
       continue
     fi


  # Create the user with a personal group
    if id "$username" &>/dev/null; then
      echo "----------------------------------------------------------------" | tee -a "$LOG_FILE"
      echo "User $username already exists" | tee -a "$LOG_FILE"
    else
      useradd -m -U "$username"
      echo "----------------------------------------------------------------" | tee -a "$LOG_FILE"
      echo "User $username created with a personal group" | tee -a "$LOG_FILE"
    fi


  # Create additional groups and assign the user to them
  if [ -n "$groups" ]; then
    IFS=',' read -ra groupName <<< "$groups"
    for group in "${groupName[@]}"; do
      group=$(echo "$group" | xargs)  # Remove leading/trailing whitespaces
      if ! getent group "$group" &>/dev/null; then
        groupadd "$group"
        echo "group: $group created successfully"
      fi
      usermod -aG "$group" "$username"
      echo "user: $username added to group: $group"
    done
  fi


    # Generate, set and store password securely
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "$username	|	$password" >> "$PASSWORD_FILE"



    # Set permissions and ownership for the home directory
    chown -R "$username":"$username" "/home/$username"
    chmod 700 "/home/$username"

    echo "-----------------------------------------------------------------------------------"
    echo "  "

    # Log recent actions
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Created user with username: $username and groups: $groups" >> "$LOG_FILE"
    echo "-------------------------------------------------------------------" >> "$LOG_FILE"
done < "$INPUT_FILE"




