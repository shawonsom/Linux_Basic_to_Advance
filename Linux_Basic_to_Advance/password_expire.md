I'll help you set a password expiration policy for user `test13` so the password expires after 30 days.

## 1. Check Current Password Aging Settings

```bash
# Check current password aging for test13
chage -l test13

# Check system-wide password policy
grep -i password /etc/login.defs
```

## 2. Set Password Expiration for test13

```bash
# Set password to expire in 30 days
sudo chage -M 30 test13

# Set immediate expiration warning (optional)
sudo chage -W 7 test13  # Warn 7 days before expiration

# Set minimum password age (optional)
sudo chage -m 1 test13   # Minimum 1 day between changes

# Set account expiration (optional)
sudo chage -E $(date -d "+30 days" +%Y-%m-%d) test13
```

## 3. Verify the Settings

```bash
# Verify the new settings
chage -l test13
```

This will show something like:
```
Last password change                                    : Jan 01, 2024
Password expires                                        : Jan 31, 2024
Password inactive                                       : never
Account expires                                         : never
Minimum number of days between password change          : 1
Maximum number of days between password change          : 30
Number of days of warning before password expires       : 7
```

## 4. Alternative Method: Using passwd Command

```bash
# Set password expiration directly
sudo passwd -x 30 test13

# Set warning period
sudo passwd -w 7 test13
```

## 5. Set System-Wide Password Policy (Optional)

If you want to set this for all new users, edit `/etc/login.defs`:

```bash
sudo vi /etc/login.defs
```

Modify these lines:
```
PASS_MAX_DAYS   30
PASS_MIN_DAYS   1
PASS_WARN_AGE   7
```

## 6. For Samba User Password Expiry

If `test13` is also a Samba user, you might want to sync the policies:

```bash
# Check if test13 is a Samba user
pdbedit -L | grep test13

# Set Samba password policy (if needed)
sudo smbpasswd -x test13  # This doesn't set expiry, just checks if user exists
```

## 7. Force Password Change on Next Login

If you want to force immediate password change:

```bash
# Force password change on next login
sudo chage -d 0 test13

# Or using passwd command
sudo passwd -e test13
```

## 8. Create a Script for Multiple Users

If you need to set this for multiple users:

```bash
#!/bin/bash
# Script to set password expiration for multiple users
USERS="test13 user1 user2 user3"

for USER in $USERS; do
    if id "$USER" &>/dev/null; then
        sudo chage -M 30 "$USER"
        sudo chage -W 7 "$USER"
        sudo chage -m 1 "$USER"
        echo "Password expiration set for $USER"
    else
        echo "User $USER does not exist"
    fi
done
```

## 9. Check Password Quality Settings (Optional)

```bash
# Install password quality checking (if not installed)
sudo yum install libpwquality

# Edit password policy
sudo vi /etc/security/pwquality.conf
```

## 10. Verify Everything Works

```bash
# Test by trying to change password as test13
sudo su - test13
chage -l test13
exit
```

## 11. Monitor Password Expiry

```bash
# Check when passwords will expire
sudo chage -l test13

# Check all users' password expiry
sudo awk -F: '{print $1}' /etc/passwd | while read user; do
    expiry=$(chage -l "$user" 2>/dev/null | grep "Password expires" | cut -d: -f2)
    echo "$user: $expiry"
done
```

## Complete One-Line Setup:

```bash
# Set all password policies for test13 in one command
sudo chage -m 1 -M 30 -W 7 -I 7 test13
```

Where:
- `-m 1`: Minimum 1 day between password changes
- `-M 30`: Maximum 30 days password validity
- `-W 7`: Warn 7 days before expiration
- `-I 7`: Inactive 7 days after expiration (account lock)

The password for user `test13` will now expire after 30 days, and the user will receive warnings starting 7 days before expiration.

Would you like me to explain any of these options in more detail or help you set up email notifications for password expiration?
