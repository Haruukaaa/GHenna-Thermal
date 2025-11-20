
#!/system/bin/sh
MODDIR=${0%/*}

#!/system/bin/sh
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 1
  done
}

wait_until_boot_complete

kill_thermal_process() {
    local pid=$1
    local name=$2
    if [ -n "$pid" ]; then
        kill -SIGSTOP "$pid" 2>/dev/null
        sleep 0.5
        if ps -p "$pid" > /dev/null; then
            kill -9 "$pid" 2>/dev/null
            log_activity "Force-killed $name (PID $pid) with SIGKILL"
        fi
        # Final fallback: pkill -9 if PID still exists
        if ps -p "$pid" > /dev/null; then
            pkill -9 -f "$name" 2>/dev/null
            log_activity "Nuclear pkill -9 executed on $name"
        fi
    fi
}

disable_thermal_zones() {
    for zone in /sys/class/thermal/thermal_zone*/mode; do
        if [ -f "$zone" ] && [ "$(cat "$zone")" != "disabled" ]; then
            chmod 644 "$zone"
            echo "disabled" > "$zone"
        fi
    done
    
    for zone2 in /sys/class/thermal/thermal_zone*/policy; do
        if [ -f "$zone2" ] && [ "$(cat "$zone2")" != "userspace" ]; then
            echo "userspace" > "$zone2"
        fi
    done
    log_activity "Disabled Thermal Zones"
}

stop_thermal_services() {
    thermal_services() {
        find /system/etc/init /vendor/etc/init /odm/etc/init -type f 2>/dev/null | 
        xargs grep -l '^service.*thermal' 2>/dev/null | 
        xargs grep -h '^service' | awk '{print $2}'
    }
    
    for svc in $(thermal_services); do
        if getprop | grep -q "init.svc.$svc.*running"; then
            stop "$svc"
            sleep 0.5
            pid=$(pidof "$svc")
            [ -n "$pid" ] && kill_thermal_process "$pid" "$svc"
        fi
    done
        for dead in android.hardware.thermal-service.mediatek android.hardware.thermal@2.0-service.mtk; do
        if getprop | grep -q "init.svc.$dead.*running"; then
            stop "$dead"
            pid=$(pidof "$dead")
            [ -n "$pid" ] && kill -SIGSTOP "$pid"
        fi
    done
        for pid in $(pgrep thermal); do
        kill -SIGSTOP "$pid"
    done
        thermal() {
    find /system/etc/init /vendor/etc/init /odm/etc/init -type f 2>/dev/null | xargs grep -h "^service" | awk '{print $2}' | grep thermal
    }

    thermal_service=$(thermal)

    if [ "$thermal_service" != "vendor.thermal-hal" ] && [ "$thermal_service" != "android.hardware.thermal-service.mediatek" ]; then
      stop "$thermal_service"
      sleep 0.5
       pid=$(pidof "$thermal_service")
         if [ -n "$pid" ]; then
        kill -9 "$pid"
      fi
    fi
}

disable_gpu_limits() {
    if [ -f "/proc/gpufreq/gpufreq_power_limited" ]; then
        for setting in ignore_batt_oc ignore_batt_percent ignore_low_batt ignore_thermal_protect ignore_pbm_limited; do
            if ! grep -q "$setting 1" "/proc/gpufreq/gpufreq_power_limited"; then
                echo "$setting 1" > /proc/gpufreq/gpufreq_power_limited
            fi
        done
    fi
}

set_cpu_limits() {
    if [ -f /sys/devices/virtual/thermal/thermal_message/cpu_limits ]; then
        for cpu in 0 2 4 6 7; do
            maxfreq_path="/sys/devices/system/cpu/cpu$cpu/cpufreq/cpuinfo_max_freq"
            if [ -f "$maxfreq_path" ]; then
                maxfreq=$(cat "$maxfreq_path")
                if [ -n "$maxfreq" ] && [ "$maxfreq" -gt 0 ]; then
                    current_limit=$(grep "cpu$cpu" /sys/devices/virtual/thermal/thermal_message/cpu_limits)
                    if [ -z "$current_limit" ] || [ "$current_limit" != "cpu$cpu $maxfreq" ]; then
                        echo "cpu$cpu $maxfreq" > /sys/devices/virtual/thermal/thermal_message/cpu_limits
                    fi
                fi
            fi
        done
    fi
}

reset_thermal_properties() {
    for prop in $(getprop | awk -F '[][]' '/init\.svc_/ {print $2}'); do
        if [ -n "$prop" ]; then
            resetprop -n "$prop" ""
        fi
    done
    
    getprop | awk -F '[][]' '/ro.*thermal/ {print $2}' | while read -r prop; do
        if [ "$(getprop "$prop")" != "0" ]; then
            resetprop -n "$prop" 0
        fi
    done

    for prop in $(getprop | grep thermal | cut -f1 -d] | cut -f2 -d[ | grep -F init.svc.); do
        if [ "$(getprop "$prop")" != "stopped" ]; then
            setprop "$prop" stopped
        fi
    done
    
    for prop in $(getprop | grep thermal | cut -f1 -d] | cut -f2 -d[ | grep -F init.svc_); do
        setprop "$prop" ""
    done

    log_activity "Reset Thermal Properties"
    done

    for pid in $(pgrep -f thermal); do
        kill_thermal_process "$pid" "thermal"
    done
        for dead in android.hardware.thermal-service.mediatek android.hardware.thermal@2.0-service.mtk; do
        pid=$(pidof "$dead")
        [ -n "$pid" ] && kill_thermal_process "$pid" "$dead"
    done
    [ -f /sys/class/kgsl/kgsl-3d0/throttling ] && echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
    [ -f /sys/class/kgsl/kgsl-3d0/force_clk_on ] && echo "1" > /sys/class/kgsl/kgsl-3d0/force_clk_on
    [ -f /sys/class/kgsl-3d0/bus_split ] && echo "0" > /sys/class/kgsl-3d0/bus_split
    [ -f /sys/class/kgsl/kgsl-3d0/force_bus_on ] && echo "1" > /sys/class/kgsl/kgsl-3d0/force_bus_on
    [ -f /sys/class/kgsl/kgsl-3d0/force_no_nap ] && echo "1" > /sys/class/kgsl/kgsl-3d0/force_no_nap
    [ -f /sys/module/msm_performance/parameters/touchboost ] && echo "0" > /sys/module/msm_performance/parameters/touchboost
}

disable_ppm_policies() {
    if [ -d /proc/ppm ] && [ -f /proc/ppm/policy_status ]; then
        for idx in $(grep -E 'FORCE_LIMIT|PWR_THRO|THERMAL' /proc/ppm/policy_status | awk -F'[][]' '{print $2}'); do
            current_status=$(grep "^$idx " /proc/ppm/policy_status | awk '{print $2}')
            if [ "$current_status" != "0" ]; then
                echo "$idx 0" > /proc/ppm/policy_status
            fi
        done
    fi
}

hide_thermal_monitoring() {
    find /sys/devices/virtual/thermal -type f -exec sh -c '
        for file; do
            if [ "$(stat -c "%a" "$file")" != "0" ]; then
                chmod 000 "$file"
            fi
        done
    ' sh {} +
}

disable_thermal_stats() {
    if [ "$(cmd thermalservice get-status)" != "0" ]; then
        cmd thermalservice override-status 0
    fi
}

sleep 1
rm -f /storage/emulated/0/*.log;
settings delete global device_idle_constants
settings delete global device_idle_constants_user
dumpsys deviceidle enable light
dumpsys deviceidle enable deep
settings put global device_idle_constants
sleep 1
su -c "pm disable com.google.android.gms/.chimera.GmsIntentOperationService"
su -c "pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

setprop debug.sf.hw 1
setprop debug.sf.latch_unsignaled 1
setprop debug.sf.prime_shader_cache.solid_layers true;
setprop debug.sf.prime_shader_cache.shadow_layers true;
setprop debug.sf.prime_shader_cache.image_layers true;
setprop debug.sf.prime_shader_cache.clipped_layers true;
setprop debug.sf.prime_shader_cache.edge_extension_shader true;
setprop debug.sf.prime_shader_cache.hole_punch false;
setprop debug.sf.prime_shader_cache.solid_dimmed_layers false;
setprop debug.sf.prime_shader_cache.image_dimmed_layers false;
setprop debug.sf.prime_shader_cache.pip_image_layers false;
setprop debug.sf.prime_shader_cache.transparent_image_dimmed_layers false;
setprop debug.sf.prime_shader_cache.clipped_dimmed_image_layers false
    if [ -f "$touch" ]; then
        chmod 644 "$touch" >/dev/null 2>&1
        echo "1" > "$touch" 2>/dev/null
        chmod 444 "$touch" >/dev/null 2>&1  
    fi
done

for queue in /sys/block/*/queue; do
    echo "0" > "$queue/iostats"
done
chmod 755 /sys/module/qti_haptics/parameters/vmax_mv_override
echo 500 > /sys/module/qti_haptics/parameters/vmax_mv_override
chmod 444 /sys/module/qti_haptics/parameters/vmax_mv_override


echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/panic_on_rcu_stall
echo "0" > /proc/sys/kernel/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic
echo "0" > /sys/module/kernel/parameters/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic_on_oops
echo "0" > /sys/vm/panic_on_oom

echo '0' > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo "0 0 0 0" > /proc/sys/kernel/printk
echo "0" > /sys/kernel/printk_mode/printk_mode
echo "0" > /sys/module/printk/parameters/cpu
echo "0" > /sys/module/printk/parameters/pid
echo "0" > /sys/module/printk/parameters/printk_ratelimit
echo "0" > /sys/module/printk/parameters/time
echo "1" > /sys/module/printk/parameters/console_suspend
echo "1" > /sys/module/printk/parameters/ignore_loglevel
echo "off" > /proc/sys/kernel/printk_devkmsg
echo "0" > /proc/sys/kernel/hung_task_timeout_secs
echo "0" > /proc/sys/kernel/softlockup_panic
echo "55" /proc/sys/kernel/perf_cpu_time_max_percent
echo "24000" /proc/sys/kernel/perf_event_max_sample_rate
echo "570" /proc/sys/kernel/perf_event_mlock_kb
echo "0" /proc/sys/kernel/sched_boost
echo "95" /proc/sys/kernel/sched_downmigrate
echo "160" /proc/sys/kernel/sched_group_upmigrate
    sleep 2
su -lp 2000 -c "cmd notification post -S bigtext -t 'Tairitsu 🎻✅' 'Tag' 'My job has done, $(getprop ro.soc.model). Now, let your new owner handle this.'"
sleep 1
    exit 0
    
    
