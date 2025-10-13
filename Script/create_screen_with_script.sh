#!/bin/bash

# Simple version
#format: screen -dmS 'screen_name' bash -c 'location' && 'run_file'
screen -dmS Time bash -c 'cd /ismp/shared/test/running_screen/ && ./runsh.sh'
echo "Screen session 'Time' created."
echo "To attach: screen -r Time"
echo "To detach: Ctrl+A then D"
