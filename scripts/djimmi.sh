#!/bin/bash
# Fine-tuned 360-rotation script for Cuphead (Overlapped keypresses)

DELAY=0.07
HOLD=0.04

while true; do
    # Press W
    ydotool key 17:1
    sleep $HOLD
    # Press D, release W
    ydotool key 32:1 17:0
    sleep $DELAY
    # Press S, release D
    ydotool key 31:1 32:0
    sleep $DELAY
    # Press A, release S
    ydotool key 30:1 31:0
    sleep $DELAY
    # Release A for next loop
    ydotool key 30:0
done
