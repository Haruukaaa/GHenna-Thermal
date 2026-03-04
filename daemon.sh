#!/system/bin/sh
#
# Daemon: Temperature-Aware Charging Control (safer)
#

# Path to battery temperature and charge limit
TEMP_PATH="/sys/class/power_supply/battery/temp"
LIMIT_PATH="/sys/class/power_supply/battery/constant_charge_current_max"
SLEEP=30

exit_handler() {
    echo "daemon: exiting"
    exit 0
}
trap exit_handler INT TERM

while true; do
    if [ -r "$TEMP_PATH" ] && [ -w "$LIMIT_PATH" ]; then
        temp_raw=$(cat "$TEMP_PATH" 2>/dev/null || echo "")
        case "$temp_raw" in
            ''|*[!0-9]*)
                echo "daemon: unreadable or non-numeric temp: '$temp_raw'"
                sleep $SLEEP
                continue
                ;;
        esac

        temp_c=$((temp_raw / 10))  # convert tenths °C -> °C

        if [ "$temp_c" -ge 45 ]; then
            current_mA=3000
            note="~33W (approx)"
        elif [ "$temp_c" -ge 40 ]; then
            current_mA=4500
            note="~45W (approx)"
        else
            current_mA=6000
            note="~67W (approx)"
        fi

        current_uA=$((current_mA * 1000))
        if printf '%s' "$current_uA" > "$LIMIT_PATH" 2>/dev/null; then
            echo "Battery ${temp_c}°C → limit set to ${current_mA}mA (${note})"
        else
            echo "daemon: failed to write ${current_uA} to $LIMIT_PATH (permission?)"
        fi
    else
        echo "daemon: missing read/write permission for paths"
    fi

    sleep $SLEEP
done
