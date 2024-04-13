#!/bin/bash

# Function to launch nvim and set padding in kitty to 0
nv() {
    # Check if the terminal is Kitty
    if [[ "$TERM" == "xterm-kitty" ]]; then
        # Set the padding of kitty to 0
        kitty @ set-spacing padding=0
        kitty @ set-background-opacity 1.0
        # Launch nvim with any passed arguments
        nvim "$@"
        # Reset the padding of kitty to default
        kitty @ set-spacing padding=default
        kitty @ set-background-opacity 0.7
    else
        # Launch nvim normally if not using Kitty
        nvim "$@"
    fi
}

# Call the nv function with all passed arguments
nv "$@"
