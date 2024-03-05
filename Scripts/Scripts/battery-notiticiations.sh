#! /bin/bash

# run every 5 minutes
battery_notify() {
    while true; do
        # sleep for 5 minutes
        sleep 300
        # get battery status
        battery_status=$(acpi -b | grep -P -o '[0-9]+(?=%)')
        # check if battery is less than 10%
        if [ $battery_status -le 20 ]; then
            # send notification
            notify-send "Battery low: ${battery_status}%"
        fi
    done
}
