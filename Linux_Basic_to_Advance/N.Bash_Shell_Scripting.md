# Bash Shell Scripting Guide

## Table of Contents
1. [Introduction to Bash Scripting](#introduction-to-bash-scripting)
2. [Creating and Executing Scripts](#creating-and-executing-scripts)
3. [Variables and Data Types](#variables-and-data-types)
4. [Input and Output](#input-and-output)
5. [Conditional Statements](#conditional-statements)
6. [Looping Constructs](#looping-constructs)
7. [Functions](#functions)
8. [Arrays](#arrays)
9. [String Manipulation](#string-manipulation)
10. [File Operations](#file-operations)
11. [Exit Codes and Error Handling](#exit-codes-and-error-handling)
12. [Debugging Scripts](#debugging-scripts)
13. [Advanced Topics](#advanced-topics)
14. [Best Practices](#best-practices)

## Introduction to Bash Scripting

Bash (Bourne Again SHell) is the default shell on most Linux distributions and macOS. Shell scripting allows you to automate tasks and create powerful utilities.

### Why Use Bash Scripting?
- Automation of repetitive tasks
- System administration
- File manipulation
- Program execution
- Task scheduling

## Creating and Executing Scripts

### Creating Your First Script
```bash
#!/bin/bash
# This is a comment
echo "Hello, World!"
```

### Making Scripts Executable
```bash
# Create script file
nano hello.sh

# Make executable
chmod +x hello.sh

# Execute script
./hello.sh
```

### Different Ways to Execute Scripts
```bash
# Method 1: Direct execution (requires executable permission)
./script.sh

# Method 2: Using bash interpreter
bash script.sh

# Method 3: Source execution (runs in current shell)
source script.sh
. script.sh
```

## Variables and Data Types

### Variable Declaration and Usage
```bash
# Variable assignment (no spaces around =)
name="John Doe"
age=25

# Variable usage
echo $name
echo "Hello, $name!"
echo "You are ${age} years old."

# Command substitution
current_date=$(date)
file_count=$(ls -l | wc -l)
```

### Environment Variables
```bash
# Common environment variables
echo "User: $USER"
echo "Home: $HOME"
echo "Path: $PATH"
echo "Current directory: $PWD"

# Setting environment variables
export MY_VAR="some value"
```

### Special Variables
```bash
# Script arguments
echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "Number of arguments: $#"

# Process ID
echo "PID: $$"

# Exit status of last command
echo "Exit status: $?"
```

### Read-only Variables and Unsetting
```bash
# Read-only variable
readonly PI=3.14159
# PI=3.14  # This would cause an error

# Unset variable
unset name
```

## Input and Output

### Reading User Input
```bash
# Basic input
echo "Enter your name:"
read name
echo "Hello, $name!"

# Silent input (for passwords)
read -s -p "Enter password: " password
echo

# Multiple inputs
echo "Enter your full name:"
read first last
echo "First: $first, Last: $last"

# Timeout for input
read -t 10 -p "Enter within 10 seconds: " input
```

### Output Formatting
```bash
# Basic echo
echo "This is a message"

# Escape sequences
echo -e "Line 1\nLine 2"
echo -e "Tab\tseparated"

# printf for formatted output
printf "Name: %s, Age: %d\n" "Alice" 30
printf "Pi: %.2f\n" 3.14159
```

### Here Documents
```bash
# Multiline input
cat << EOF
This is a multiline
message that will be
displayed as output.
EOF

# Command with here document
cat > config.txt << EOL
server {
    host: $HOSTNAME
    port: 8080
}
EOL
```

## Conditional Statements

### If-Else Statements
```bash
# Basic if statement
if [ condition ]; then
    # commands
fi

# If-else
if [ condition ]; then
    # commands
else
    # other commands
fi

# If-elif-else
if [ condition1 ]; then
    # commands
elif [ condition2 ]; then
    # other commands
else
    # default commands
fi
```

### Test Conditions
```bash
# File tests
if [ -f "file.txt" ]; then
    echo "File exists"
fi

if [ -d "directory" ]; then
    echo "Directory exists"
fi

# String comparisons
if [ "$str1" = "$str2" ]; then
    echo "Strings are equal"
fi

if [ -z "$string" ]; then
    echo "String is empty"
fi

# Numeric comparisons
if [ $num1 -eq $num2 ]; then
    echo "Numbers are equal"
fi

if [ $num1 -gt $num2 ]; then
    echo "num1 is greater than num2"
fi

# Logical operators
if [ condition1 ] && [ condition2 ]; then
    echo "Both conditions are true"
fi

if [ condition1 ] || [ condition2 ]; then
    echo "At least one condition is true"
fi
```

### Case Statements
```bash
# Case statement example
case $option in
    "start")
        echo "Starting service..."
        ;;
    "stop")
        echo "Stopping service..."
        ;;
    "restart")
        echo "Restarting service..."
        ;;
    *)
        echo "Invalid option: $option"
        ;;
esac

# Pattern matching
case $filename in
    *.txt)
        echo "Text file"
        ;;
    *.jpg|*.png)
        echo "Image file"
        ;;
    *)
        echo "Other file type"
        ;;
esac
```

## Looping Constructs

### For Loops
```bash
# Basic for loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# Range for loop
for i in {1..5}; do
    echo "Number: $i"
done

# Step in range
for i in {1..10..2}; do
    echo "Odd number: $i"
done

# C-style for loop
for ((i=0; i<5; i++)); do
    echo "Counter: $i"
done

# Looping through files
for file in *.txt; do
    echo "Processing: $file"
done

# Looping through command output
for user in $(cat users.txt); do
    echo "User: $user"
done
```

### While Loops
```bash
# Basic while loop
counter=1
while [ $counter -le 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done

# Reading file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < file.txt

# Infinite loop with break
while true; do
    read -p "Enter command (quit to exit): " cmd
    if [ "$cmd" = "quit" ]; then
        break
    fi
    echo "Executing: $cmd"
done
```

### Until Loops
```bash
# Until loop (runs until condition becomes true)
counter=1
until [ $counter -gt 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done
```

### Loop Control
```bash
# Break statement
for i in {1..10}; do
    if [ $i -eq 6 ]; then
        break
    fi
    echo "Number: $i"
done

# Continue statement
for i in {1..5}; do
    if [ $i -eq 3 ]; then
        continue
    fi
    echo "Number: $i"
done

# Nested loops with labels
outer=1
while [ $outer -le 3 ]; do
    inner=1
    while [ $inner -le 3 ]; do
        if [ $inner -eq 2 ]; then
            break 2  # Break out of 2 levels
        fi
        echo "Outer: $outer, Inner: $inner"
        ((inner++))
    done
    ((outer++))
done
```

## Functions

### Function Definition and Usage
```bash
# Basic function
greet() {
    echo "Hello, $1!"
}

# Function call
greet "Alice"
greet "Bob"

# Function with return value
add() {
    local result=$(($1 + $2))
    return $result
}

add 5 3
echo "Sum: $?"

# Function with output
multiply() {
    echo $(($1 * $2))
}

result=$(multiply 4 5)
echo "Product: $result"
```

### Function Parameters and Scope
```bash
# Function with parameters
create_user() {
    local username=$1
    local shell=${2:-/bin/bash}  # Default value
    echo "Creating user $username with shell $shell"
}

create_user "alice"
create_user "bob" "/bin/zsh"

# Variable scope
global_var="I'm global"

test_scope() {
    local local_var="I'm local"
    echo "Inside function: $global_var, $local_var"
}

test_scope
echo "Outside function: $global_var"
# echo "Outside function: $local_var"  # This would not work
```

### Recursive Functions
```bash
# Factorial function
factorial() {
    local n=$1
    if [ $n -le 1 ]; then
        echo 1
    else
        local prev=$(factorial $((n-1)))
        echo $((n * prev))
    fi
}

result=$(factorial 5)
echo "5! = $result"
```

## Arrays

### Array Operations
```bash
# Declaring arrays
fruits=("Apple" "Banana" "Cherry")
numbers=(1 2 3 4 5)

# Accessing elements
echo "First fruit: ${fruits[0]}"
echo "All fruits: ${fruits[@]}"

# Array length
echo "Number of fruits: ${#fruits[@]}"

# Adding elements
fruits+=("Date" "Elderberry")

# Removing elements
unset fruits[1]
echo "After removal: ${fruits[@]}"

# Iterating through array
for fruit in "${fruits[@]}"; do
    echo "Fruit: $fruit"
done

# Associative arrays (Bash 4+)
declare -A user
user["name"]="Alice"
user["age"]=30
user["city"]="Wonderland"

echo "User: ${user["name"]}, Age: ${user["age"]}"
```

### Array Manipulation
```bash
# Array slicing
numbers=(1 2 3 4 5 6 7 8 9 10)
echo "Slice: ${numbers[@]:2:4}"  # Elements from index 2, length 4

# Copying arrays
copy=("${numbers[@]}")

# Finding array index
for i in "${!fruits[@]}"; do
    echo "Index $i: ${fruits[$i]}"
done

# Sorting array
sorted=($(printf "%s\n" "${fruits[@]}" | sort))
echo "Sorted: ${sorted[@]}"
```

## String Manipulation

### String Operations
```bash
# String length
str="Hello World"
echo "Length: ${#str}"

# Substring extraction
echo "Substring: ${str:6:5}"  # From index 6, length 5

# String replacement
echo "Replace: ${str/World/There}"

# Global replacement
echo "Global replace: ${str//l/_}"

# Case conversion
echo "Upper: ${str^^}"
echo "Lower: ${str,,}"

# Remove prefix/suffix
filename="document.txt"
echo "Without extension: ${filename%.txt}"
path="/home/user/file.txt"
echo "Basename: ${path##*/}"
```

### String Splitting and Joining
```bash
# Splitting string into array
IFS=',' read -ra parts <<< "apple,banana,cherry"
for part in "${parts[@]}"; do
    echo "Part: $part"
done

# Joining array elements
fruits=("Apple" "Banana" "Cherry")
joined=$(IFS=,; echo "${fruits[*]}")
echo "Joined: $joined"

# String trimming
text="   Hello World   "
echo "Trimmed: '${text// /}'"
```

## File Operations

### File Testing and Operations
```bash
# File existence check
if [ -f "file.txt" ]; then
    echo "File exists"
fi

# Directory check
if [ -d "directory" ]; then
    echo "Directory exists"
fi

# File readable/writable/executable
if [ -r "file.txt" ]; then
    echo "File is readable"
fi

if [ -w "file.txt" ]; then
    echo "File is writable"
fi

if [ -x "script.sh" ]; then
    echo "File is executable"
fi

# File size
if [ -s "file.txt" ]; then
    echo "File is not empty"
fi
```

### File Reading and Writing
```bash
# Reading file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < "file.txt"

# Reading entire file
content=$(cat "file.txt")
echo "File content: $content"

# Writing to file
echo "Hello World" > output.txt
echo "Appended line" >> output.txt

# Here document for file creation
cat > config.conf << EOF
server {
    host: localhost
    port: 8080
}
EOF
```

### File Manipulation
```bash
# Copying files
cp source.txt destination.txt

# Moving files
mv oldname.txt newname.txt

# Removing files
rm file.txt

# Creating directories
mkdir -p parent/child

# Finding files
find . -name "*.txt" -type f

# File statistics
echo "Size: $(stat -c%s file.txt) bytes"
echo "Modification time: $(stat -c%y file.txt)"
```

## Exit Codes and Error Handling

### Exit Status
```bash
# Checking exit status
ls /nonexistent
if [ $? -ne 0 ]; then
    echo "Command failed"
fi

# Using && and ||
mkdir /invalid/path && echo "Success" || echo "Failed"

# Setting exit code
exit 0  # Success
exit 1  # Failure

# Custom exit codes
if [ ! -f "required.txt" ]; then
    echo "Required file missing" >&2
    exit 2
fi
```

### Error Handling
```bash
# Error handling with trap
cleanup() {
    echo "Cleaning up..."
    rm -f tempfile.txt
}

trap cleanup EXIT ERR INT TERM

# Set error handling options
set -e  # Exit on error
set -u  # Treat unset variables as error
set -o pipefail  # Pipeline commands fail if any command fails

# Temporary disable error handling
set +e
some_command_that_might_fail
set -e
```

### Logging and Debugging Output
```bash
# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> script.log
}

log "Starting script execution"

# Debug output
set -x  # Enable debug mode
# Commands will be printed before execution
set +x  # Disable debug mode
```

## Debugging Scripts

### Debugging Techniques
```bash
# Running script in debug mode
bash -x script.sh

# Debug specific parts
set -x
# Debug code here
set +x

# Verbose mode
bash -v script.sh

# Combining verbose and debug
bash -xv script.sh

# Debugging with trap
trap 'echo "Line: $LINENO, Variable: $var"' DEBUG
```

### Common Debugging Practices
```bash
# Check syntax without execution
bash -n script.sh

# Print commands as they're read
bash -v script.sh

# Using debugger
bashdb script.sh

# Logging variable values
debug() {
    echo "DEBUG: $1 = ${!1}" >&2
}

var="test"
debug var
```

## Advanced Topics

### Process Management
```bash
# Running commands in background
sleep 10 &

# Getting process ID
pid=$!

# Waiting for process
wait $pid

# Killing processes
kill $pid
kill -9 $pid  # Force kill

# Job control
jobs
fg %1
bg %1
```

### Signal Handling
```bash
# Trap signals
trap "echo 'Script interrupted'; exit 1" INT TERM
trap "echo 'Script exited'" EXIT

# Ignore signals
trap '' INT

# Custom signal handler
cleanup() {
    rm -f /tmp/tempfile.*
    exit 1
}

trap cleanup INT TERM
```

### Regular Expressions
```bash
# Using regex in bash
if [[ "hello" =~ ^h ]]; then
    echo "Starts with h"
fi

# Extracting matches
text="Date: 2023-01-15"
if [[ $text =~ ([0-9]{4}-[0-9]{2}-[0-9]{2}) ]]; then
    echo "Date found: ${BASH_REMATCH[1]}"
fi

# Regex replacement
text="Hello World"
new_text=${text//[aeiou]/_}
echo "After replacement: $new_text"
```

### Advanced I/O Redirection
```bash
# Redirecting output
command > file.txt  # Overwrite
command >> file.txt  # Append

# Redirecting errors
command 2> error.log
command 2>&1  # Stderr to stdout

# Here string
tr 'a-z' 'A-Z' <<< "hello world"

# Process substitution
diff <(ls dir1) <(ls dir2)

# Custom file descriptors
exec 3> custom.log
echo "Message" >&3
exec 3>&-
```

## Best Practices

### Code Organization
```bash
#!/bin/bash
#
# Script: system_backup.sh
# Author: Your Name
# Description: Backup system files
# Version: 1.0
#

# Configuration section
readonly BACKUP_DIR="/backup"
readonly LOG_FILE="/var/log/backup.log"

# Function definitions
backup_files() {
    # Function code
}

# Main execution
main() {
    backup_files
    # Other operations
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### Security Considerations
```bash
# Validate input
if [[ ! "$input" =~ ^[a-zA-Z0-9_]+$ ]]; then
    echo "Invalid input" >&2
    exit 1
fi

# Check privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# Safe file handling
readonly safe_dir="/safe/path"
if [[ "$(realpath "$input_file")" != "$safe_dir"/* ]]; then
    echo "Invalid file path" >&2
    exit 1
fi
```

### Performance Optimization
```bash
# Use builtins instead of external commands
# Instead of: lines=$(wc -l < file.txt)
lines=0
while IFS= read -r _; do
    ((lines++))
done < file.txt

# Avoid unnecessary subshells
# Instead of: result=$(echo "$var" | tr 'a-z' 'A-Z')
result=${var^^}

# Use arrays instead of strings for lists
files=()
while IFS= read -r -d '' file; do
    files+=("$file")
done < <(find . -name "*.txt" -print0)
```

### Portability Considerations
```bash
# Use shebang with env for portability
#!/usr/bin/env bash

# Avoid bashisms when portability is needed
# Use test instead of [[ ]] when possible
if test "$var" = "value"; then
    # code
fi

# Use printf instead of echo for consistency
printf "%s\n" "Hello World"

# Check bash version for features
if ((BASH_VERSINFO[0] < 4)); then
    echo "Bash 4+ required" >&2
    exit 1
fi
```

### Documentation and Comments
```bash
#!/bin/bash
#
# Script: deploy.sh
# Purpose: Deploy application to production
# Author: DevOps Team
# Version: 2.1
# Usage: ./deploy.sh [environment]
#

# Global constants
readonly DEPLOY_USER="deploy"
readonly APP_DIR="/var/www/app"

##
# Function: setup_environment
# Description: Configure environment variables
# Parameters:
#   $1 - Environment name (prod, staging, dev)
# Returns: 0 on success, 1 on error
##
setup_environment() {
    local env="$1"
    # Function implementation
}

# Main execution flow with error handling
main() {
    local environment="${1:-prod}"
    
    if ! setup_environment "$environment"; then
        log_error "Failed to setup environment"
        return 1
    fi
    
    # Continue with deployment
}
```

This comprehensive guide covers essential Bash scripting concepts with practical examples. Remember to always test your scripts thoroughly and follow best practices for secure and efficient scripting.
