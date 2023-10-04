#!/bin/bash
while true; do
    # Run your command
    pulseaudio --check
    
    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo "Pulse server is ready"
        break
    else
        echo "Waiting for pulse server. Retrying in 1 second..."
        sleep 1
    fi
done