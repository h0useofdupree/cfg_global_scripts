#!/bin/bash

# Process name or partial name to monitor
PROCESS_NAME="ags"
# Log file to store resource usage
LOG_FILE="resource_monitor.log"
# Interval between checks (in seconds)
INTERVAL=10

# Log the header for the CSV file
echo "Timestamp,PID,RSS,CPU,MEM%,Elapsed_Time" > $LOG_FILE

# Print the header for the live output
echo "Live Updates:"
echo "Timestamp,PID,RSS,CPU,MEM%,Elapsed_Time"
echo "------------------------------------------"

while true; do
    # Get the process ID (PID) of the target process
    PID=$(pgrep -f $PROCESS_NAME)

    # Check if the process is running
    if [[ -n "$PID" ]]; then
        # Get memory (RSS), CPU usage, and elapsed time from ps
        PROCESS_STATS=$(ps -p $PID -o rss,%cpu,%mem,etime --no-headers | awk '{print $1","$2","$3","$4}')

        # Get the current timestamp
        TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

        # Log the data into the file
        LOG_ENTRY="$TIMESTAMP,$PID,$PROCESS_STATS"
        echo "$LOG_ENTRY" >> $LOG_FILE

        # Print the data for live monitoring
        echo "$LOG_ENTRY"
    else
        # Log and print if the process is not running
        LOG_ENTRY="$(date +"%Y-%m-%d %H:%M:%S"),$PROCESS_NAME not running"
        echo "$LOG_ENTRY" >> $LOG_FILE
        echo "$LOG_ENTRY"
    fi

    # Wait for the specified interval
    sleep $INTERVAL
done
