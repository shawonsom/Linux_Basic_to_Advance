#!/bin/bash

# Directory to search for .txt.gz files
SEARCH_DIR="/var/www/html/sdp/logs"

# Find folders older than 3 days
find "$SEARCH_DIR" -type d -name "*" -mtime +3 -exec gzip -r {} \;
