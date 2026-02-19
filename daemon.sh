#!/system/bin/sh
#
# Daemon: Temperature-Aware Charging Control
#

# Path to battery temperature and charge limit
TEMP_PATH="/sys/class/power_supply/battery/temp"
LIMIT_PATH="/sys/class/power_supply/battery/constant_charge_current_max"

while true; do
    if [ -r "$TEMP_PATH" ] && [ -w "$LIMIT_PATH" ]; then
        temp_raw=$(cat "$TEMP_PATH")
        temp_c=$((temp_raw / 10))   # convert to °C

        if [ "$temp_c" -ge 45 ]; then
            echo $((3000 * 1000)) > "$LIMIT_PATH" 2>/dev/null
            echo "Battery ${temp_c}°C → limit set to ~33W"
        elif [ "$temp_c" -ge 40 ]; then
            echo $((4500 * 1000)) > "$LIMIT_PATH" 2>/dev/null
            echo "Battery ${temp_c}°C → limit set to ~45W"
        else
            echo $((6000 * 1000)) > "$LIMIT_PATH" 2>/dev/null
            echo "Battery ${temp_c}°C → limit set to ~67W"
        fi
    fi

    sleep 30   # check every 30 seconds
done
