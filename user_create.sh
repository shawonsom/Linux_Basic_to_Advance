#!/bin/bash

# Log file name
log_file="user_log.txt"

# Group to create
group_name="new_group"

# Array of users and passwords
users=("test1" "user2")
passwords=("test@1234" "user4567")
 
# Check if the number of users and passwords match
if [ ${#users[@]} -ne ${#passwords[@]} ]; then
  echo "Error: Number of users and passwords do not match."
  exit 1
fi

# Create the group
sudo groupadd "$group_name"

if [ $? -ne 0 ]; then
    echo "Error creating group $group_name"
    exit 1
fi

# Add the group to sudoers (using wheel or sudo depending on your system)
# Check for sudo group.
if grep -q "^sudo:" /etc/group; then
    sudo usermod -aG sudo "$group_name"
    SUDO_GROUP="sudo"
elif grep -q "^wheel:" /etc/group; then
    sudo usermod -aG wheel "$group_name"
    SUDO_GROUP="wheel"
else
    echo "Error: Neither sudo nor wheel group found. Please check your system's sudo group."
    sudo groupdel "$group_name"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "Error adding group $group_name to the $SUDO_GROUP group."
    sudo groupdel "$group_name"
    exit 1
fi

echo "Group $group_name created and added to $SUDO_GROUP."

# Loop through the users and passwords
for i in "${!users[@]}"; do
  username="${users[$i]}"
  password="${passwords[$i]}"

  # Create the user
  sudo useradd -m "$username"

  if [ $? -ne 0 ]; then
    echo "Error creating user $username"
    continue #skip to next user if this one fails.
  fi

  # Set the password (non-interactively)
  echo "$username:$password" | sudo chpasswd

  if [ $? -ne 0 ]; then
        echo "Error setting password for user $username"
        sudo userdel "$username" #remove the user if the password cannot be set.
        continue #skip to next user if this one fails.
  fi

  # Add the user to the sudoers group (or wheel group on some systems)
  sudo usermod -aG "$SUDO_GROUP" "$username"

  if [ $? -ne 0 ]; then
        echo "Error adding user $username to the $SUDO_GROUP group."
        sudo userdel "$username" #remove the user if the sudo group cannot be added.
        continue #skip to next user if this one fails.
  fi

    #Add user to teamoperation group.
    sudo usermod -aG "$group_name" "$username"

    if [ $? -ne 0 ]; then
        echo "Error adding user $username to $group_name group."
        sudo userdel "$username"
        continue
    fi

  echo "User $username created and added to $SUDO_GROUP and $group_name."

  # Log the user and password
  echo "$username:$password" >> "$log_file"
  echo date >> "$log_file"
done

echo "User and group creation process completed. User/passwords are logged in $log_file"
