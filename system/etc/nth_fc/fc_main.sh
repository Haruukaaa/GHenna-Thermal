#!/system/bin/sh
# Fast Charge - Universal for all SOCs
# Supports Qualcomm and other architectures

Set_value() {
    local value="$1"
    local path="$2"
    
    if [ -f "$path" ] 2>/dev/null; then
        chmod 0755 "$path" 2>/dev/null
        echo "$value" > "$path" 2>/dev/null
        chmod 0755 "$path" 2>/dev/null
    fi
}

Fast_charge() {
    local param="$1"
    local paths
    
    paths=$(find /sys/class/power_supply -name "$param" 2>/dev/null)
    # For other SOCs except Qualcomm, add additional search paths
    if [ "$SOC" != "Qualcomm" ]; then
        paths="$paths $(find /sys/devices -name "$param" 2>/dev/null)"
    fi
    for path in $paths; do
        if [ -f "$path" ]; then
            Set_value "$FC" "$path"
        fi
    done
}

# Configuration
FAST_CHARGE=${FAST_CHARGE:-<PROFILE>}
FAST_CHARGE1=$((FAST_CHARGE + 1000))
FC=$((FAST_CHARGE * 1000))
FCC=$((FAST_CHARGE1 * 1000))
CF=$((4000 * 1000))

# Find BMS path dynamically (works for all SOCs)
find_bms_path() {
    # Try multiple common paths
    for path in \
        $(find /sys/class/power_supply -name "bms" -type d 2>/dev/null) \
        $(find /sys/class/power_supply -name "fg" -type d 2>/dev/null) \
        $(find /sys/devices -name "*fg*" -type d 2>/dev/null | grep power_supply); do
        if [ -d "$path" ]; then
            echo "$path"
            return 0
        fi
    done
    echo "/sys/class/power_supply/bms"
}

# Detect SOC manufacturer
detect_soc() {
    local soc=$(getprop ro.soc.manufacturer 2>/dev/null)
    if [ -z "$soc" ]; then
        soc=$(getprop ro.board.platform 2>/dev/null)
    fi
    echo "$soc"
}

SOC=$(detect_soc)

# Find BMS temp paths dynamically
find_bms_temp_path() {
    local param="$1"
    find /sys/class/power_supply -name "$param" 2>/dev/null | head -1
}

BMS_TEMP_COOL=$(find_bms_temp_path "temp_cool")
BMS_TEMP_HOT=$(find_bms_temp_path "temp_hot")
BMS_TEMP_WARM=$(find_bms_temp_path "temp_warm")

while true; do
    # Qualcomm-specific settings
    Set_value '1' /sys/kernel/fast_charge/force_fast_charge 2>/dev/null
    Set_value '1' /sys/class/power_supply/battery/system_temp_level 2>/dev/null
    Set_value '1' /sys/kernel/fast_charge/failsafe 2>/dev/null
    Set_value '1' /sys/class/power_supply/battery/allow_hvdcp3 2>/dev/null
    Set_value '1' /sys/class/power_supply/usb/pd_allowed 2>/dev/null
    
    # Universal USB settings
    Set_value '1' /sys/class/power_supply/battery/subsystem/usb/pd_allowed 2>/dev/null
    Set_value '0' /sys/class/power_supply/battery/input_current_limited 2>/dev/null
    Set_value '1' /sys/class/power_supply/battery/input_current_settled 2>/dev/null
    
    # Qualcomm battery restrictions
    Set_value '0' /sys/class/qcom-battery/restricted_charging 2>/dev/null
    Set_value '0' /sys/class/qcom-battery/restrict_chg 2>/dev/null
    Set_value $FCC /sys/class/qcom-battery/restricted_current 2>/dev/null
    Set_value $FCC /sys/class/qcom-battery/restrict_cur 2>/dev/null
    
    # Dynamic BMS temperature settings (works for all SOCs)
    if [ -n "$BMS_TEMP_COOL" ] && [ -f "$BMS_TEMP_COOL" ]; then
        Set_value '150' "$BMS_TEMP_COOL"
    fi
    if [ -n "$BMS_TEMP_HOT" ] && [ -f "$BMS_TEMP_HOT" ]; then
        Set_value '480' "$BMS_TEMP_HOT"
    fi
    if [ -n "$BMS_TEMP_WARM" ] && [ -f "$BMS_TEMP_WARM" ]; then
        Set_value '480' "$BMS_TEMP_WARM"
    fi
    
    # Universal charge current settings
    Fast_charge current_max
    Fast_charge hw_current_max
    Fast_charge pd_current_max
    Fast_charge ctm_current_max
    Fast_charge sdp_current_max
    Fast_charge constant_charge_current_max
    
    sleep 5
done

