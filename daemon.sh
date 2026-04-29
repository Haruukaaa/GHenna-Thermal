#!/system/bin/sh
#
# Daemon: Temperature-Aware Charging Control
#

# Path to battery temperature and charge limit
TEMP_PATH="/sys/class/power_supply/battery/temp"
LIMIT_PATH="/sys/class/power_supply/battery/constant_charge_current_max"
CAPACITY_PATH="/sys/class/power_supply/battery/charge_full_design"
SLEEP=30

# Get max charging capacity (fallback to standard values if unavailable)
get_max_capacity() {
    if [ -r "$CAPACITY_PATH" ]; then
        max_cap=$(cat "$CAPACITY_PATH" 2>/dev/null || echo "")
        if [ -n "$max_cap" ] && [ "$max_cap" -gt 0 ]; then
            echo "$max_cap"
            return 0
        fi
    fi
    echo "9000"  # fallback default
}

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

    # Get device max charging capacity
    max_capacity=$(get_max_capacity)

    # Scale charging based on device capacity and temperature
    if [ "$temp_c" -ge 65 ]; then
        current_mA=0
        note="charging disabled (critical)"
    elif [ "$temp_c" -ge 60 ]; then
        current_mA=$((max_capacity / 5))  # 20% of max capacity
        note="~20% (reduced - hot)"
    elif [ "$temp_c" -ge 50 ]; then
        current_mA=$((max_capacity / 2))  # 50% of max capacity
        note="~50% (moderate)"
    else
        current_mA=$max_capacity  # 100% of max capacity
        note="100% (high-speed - cool)"
    fi

    current_uA=$((current_mA * 1000))
    if printf '%s' "$current_uA" > "$LIMIT_PATH" 2>/dev/null; then
        echo "Battery ${temp_c}°C → limit set to ${current_mA}mA (${note})"
    else
        echo "daemon: failed to write ${current_uA} to $LIMIT_PATH (permission?)"
    fi

    sleep $SLEEP
done
