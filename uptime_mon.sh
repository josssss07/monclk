#!/bin/bash

BLUE="\033[1;34m"   # Bright blue
RESET="\033[0m"     # Reset to default color

while true; do
    clear

    # --- Get uptime info ---
    uptime_raw=$(awk '{print $1}' /proc/uptime)
    seconds_int=$(echo "$uptime_raw" | cut -d. -f1)
    milliseconds=$(echo "$uptime_raw" | cut -d. -f2)
    milliseconds=${milliseconds:0:3}

    days=$((seconds_int / 86400))
    hours=$(( (seconds_int % 86400) / 3600 ))
    minutes=$(( (seconds_int % 3600) / 60 ))
    seconds=$((seconds_int % 60))

    printf -v formatted "%02d:%02d:%02d:%02d:%03d" "$days" "$hours" "$minutes" "$seconds" "$milliseconds"

    # --- Get terminal size ---
    rows=$(tput lines)
    cols=$(tput cols)

    # --- Center uptime text ---
    text_length=${#formatted}
    row=$((rows / 2 - 2))
    col=$(((cols - text_length) / 2))
    tput cup $row $col
    echo -e "${BLUE}${formatted}${RESET}"

    # --- Get full logged-in user info ---
    users=$(who)
    [ -z "$users" ] && users="(no users logged in)"

    # --- Display each line centered ---
    user_row=$((rows / 2))
    while IFS= read -r line; do
        line_length=${#line}
        user_col=$(((cols - line_length) / 2))
        tput cup $user_row $user_col
        echo -e "${BLUE}${line}${RESET}"
        user_row=$((user_row + 1))
    done <<< "$users"

    sleep 0.1
done
