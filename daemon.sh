#!/system/bin/sh
#
# Daemon: Temperature-Aware Charging Control
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
    if [ ! -e "$TEMP_PATH" ]; then
        echo "daemon: temperature path missing: $TEMP_PATH"
        sleep $SLEEP
        continue
    fi

    if [ ! -e "$LIMIT_PATH" ]; then
        echo "daemon: limit path missing: $LIMIT_PATH"
        sleep $SLEEP
        continue
    fi

    if [ ! -r "$TEMP_PATH" ]; then
        echo "daemon: cannot read temperature path: $TEMP_PATH"
        sleep $SLEEP
        continue
    fi

    if [ ! -w "$LIMIT_PATH" ]; then
        echo "daemon: cannot write limit path: $LIMIT_PATH"
        sleep $SLEEP
        continue
    fi

    temp_raw=$(cat "$TEMP_PATH" 2>/dev/null || echo "")
    case "$temp_raw" in
        ''|*[!0-9]*)
            echo "daemon: unreadable or non-numeric temp: '$temp_raw'"
            sleep $SLEEP
            continue
            ;;
    esac

    temp_c=$((temp_raw / 10))  # convert tenths °C -> °C

    if [ "$temp_c" -ge 60 ]; then
        current_mA=0
        note="charging disabled"
    elif [ "$temp_c" -ge 50 ]; then
        current_mA=4000
        note="~18W (approx)"
    elif [ "$temp_c" -ge 45 ]; then
        current_mA=4500
        note="~45W (approx)"
    else
        current_mA=9000
        note="high-speed charging (cool condition)"
    fi

    current_uA=$((current_mA * 1000))
    if printf '%s' "$current_uA" > "$LIMIT_PATH" 2>/dev/null; then
        echo "Battery ${temp_c}°C → limit set to ${current_mA}mA (${note})"
    else
        echo "daemon: failed to write ${current_uA} to $LIMIT_PATH (permission?)"
    fi

    sleep $SLEEP
done
