#!/system/bin/sh
# GHenna Lynae
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done
}

# Execute main optimization script with proper permissions
if
write() {
  if [ -f "$1" ]; then
    if [ ! -w "$1" ]; then
      chmod +w "$1"
    fi
    echo "$2" > "$1"
  fi
  directory=/data/adb/modules/gehenna/
if [ -f  /data/adb/modules/gehenna/system/etc/.nth_fc/.fc_main.sh ]; then
    chmod 0755 /system/etc/.nth_fc/.fc_main.sh
    sh /system/etc/.nth_fc/.fc_main.sh
fi
done
}

su -lp 2000 -c "cmd notification post -S bigtext -t 'Lynae' 'Tag' ' First time I saw $(getprop ro.soc.model) I thought that quiet, $(getprop ro.product.board), was I wrong. We clicked instantly.'"

sleep 1

# Enhanced Universal Deep Sleep Optimization
optimize_deep_sleep() {
    # Clean up logs
    rm -f /storage/emulated/0/*.log 2>/dev/null
    rm -f /data/log/*.log 2>/dev/null
    rm -f /cache/*.log 2>/dev/null
    rm -f /data/anr/*.log 2>/dev/null
    rm -f /data/tombstones/* 2>/dev/null
    rm -rf /data/system/dropbox/* 2>/dev/null
        # Disable wakeup sources that prevent deep sleep
        for wakeup in /sys/class/wakeup/*/active_count; do
            if [ -d "$(dirname "$wakeup")" ]; then
                echo "disabled" > "$(dirname "$wakeup")/active_wakeup" 2>/dev/null
            fi
        done
    # Device Idle Configuration
    dumpsys deviceidle reset 2>/dev/null
    dumpsys deviceidle enable light 2>/dev/null
    dumpsys deviceidle enable deep 2>/dev/null
    dumpsys deviceidle force-idle 2>/dev/null
    
    # Aggressive Doze Constants
    settings put global device_idle_constants inactive_to=30000,motion_inactive_to=0,wait_for_unlock=true 2>/dev/null
    
    # Disable keep-alive mechanisms
    settings put global low_power_mode 1 2>/dev/null
    settings put global low_power_mode_trigger_level 20 2>/dev/null
    settings put global low_power 1 2>/dev/null
    
    # Disable network keep-alives
    settings put global wifi_sleep_policy 2 2>/dev/null
    settings put global mobile_data_always_on 0 2>/dev/null
    settings put global wifi_always_on 0 2>/dev/null
    settings put global background_data 0 2>/dev/null
    settings put global auto_sync 0 2>/dev/null
    
    # Restrict network operations during sleep
    settings put global network_scoring_ui_enabled 0 2>/dev/null
    settings put global airplane_mode_on 1 2>/dev/null
    
    # Disable location services during sleep
    settings put secure location_mode 0 2>/dev/null
    
    # Disable adaptive battery management for aggressive idle
    settings put global adaptive_battery_management_enabled 0 2>/dev/null
    
    # Qualcomm sleep settings
    echo "1" > /sys/module/msm_pm/parameters/sleep_disabled 2>/dev/null
    echo "0" > /sys/module/msm_pm/parameters/pc_opt_enabled 2>/dev/null
    echo "0" > /sys/module/msm_pm/parameters/core_lock_enabled 2>/dev/null
    echo "0" > /sys/module/msm_pm/parameters/suspend_enabled 2>/dev/null
    
    # Disable wakeup sources that prevent deep sleep
    for wakeup in /sys/class/wakeup/*/active_count; do
        if [ -d "$(dirname "$wakeup")" ]; then
            echo "disabled" > "$(dirname "$wakeup")/active_wakeup" 2>/dev/null
        fi
    done
    
    # Disable wakelocks for common wake sources
    echo "0" > /sys/power/wake_lock 2>/dev/null || true
    
    # Force battery saver mode
    cmd battery set level 100 2>/dev/null
    cmd battery unplug 2>/dev/null
    
    # Trim memory caches
    pm trim-caches 999999999 2>/dev/null
}

optimize_deep_sleep
# Enhanced GMS Doze Management
optimize_gms_doze() {
    local gms_components=(
        "com.google.android.gms/.chimera.GmsIntentOperationService"
        "com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"
        "com.google.android.gms/com.google.android.gms.chimera.GmsInitializer"
        "com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService"
        "com.google.android.gms/com.google.android.gms.phenotype.service.PhenotypeService"
        "com.google.android.gms/com.google.android.gms.update.SystemUpdateService"
        "com.google.android.gms/com.google.android.gms.update.SystemUpdateActivity"
        "com.google.android.gms/com.google.android.gms.mdm.services.DevicePolicyService"
        "com.google.android.gms/com.google.android.gms.mdm.MdmService"
        "com.google.android.gms/com.google.android.gms.usagereporting.service.UsageReportingService"
    )
    
    # Disable aggressive GMS components
    for component in "${gms_components[@]}"; do
        su -c "pm disable '$component'" 2>/dev/null
    done
    
    # Put GMS in doze whitelist restrictions
    su -c "pm set-inactive com.google.android.gms true" 2>/dev/null
    
    # Disable GMS background processes
    su -c "pm disable-user --user 0 com.google.android.gms" 2>/dev/null
    
    # Restrict battery optimization for GMS
    su -c "dumpsys deviceidle whitelist -com.google.android.gms" 2>/dev/null
    
    # Force stop GMS to free resources immediately
    su -c "am force-stop com.google.android.gms" 2>/dev/null
    
    # Kill any remaining GMS processes
    su -c "killall -9 com.google.android.gms" 2>/dev/null || su -c "pkill -f com.google.android.gms" 2>/dev/null
    
    # Disable GMS location services to reduce battery drain
    su -c "pm disable com.google.android.gms/com.google.android.gms.location.service.LocationService" 2>/dev/null
    su -c "pm disable com.google.android.gms/com.google.android.gms.location.GeofenceService" 2>/dev/null
    
    # Restrict GMS network usage
    su -c "pm restrict-background-data com.google.android.gms true" 2>/dev/null
    
    # Set aggressive battery optimization for GMS
    su -c "dumpsys deviceidle tempwhitelist -c com.google.android.gms" 2>/dev/null
}

optimize_gms_doze

# Enhanced Tracing and Logging Optimization
disable_tracing_and_logging() {
    # Disable accessibility tracing
    cmd accessibility stop-trace 2>/dev/null
    
    # Disable migard tracing (if available)
    cmd migard dump-trace false 2>/dev/null
    cmd migard start-trace false 2>/dev/null
    cmd migard stop-trace true 2>/dev/null
    cmd migard trace-buffer-size 0 2>/dev/null
}

disable_tracing_and_logging

# Aggressive Logcat Optimization
optimize_logcat() {
    # Clear all logcat buffers
    logcat -c 2>/dev/null
    
    # Set minimal buffer sizes for all logcat buffers
    logcat -G 16K 2>/dev/null
    logcat -b all -G 16K 2>/dev/null
    logcat -b main -G 32K 2>/dev/null
    logcat -b system -G 16K 2>/dev/null
    logcat -b events -G 16K 2>/dev/null
    logcat -b crash -G 16K 2>/dev/null
    logcat -b kernel -G 16K 2>/dev/null
    
    # Disable various logging mechanisms
    setprop persist.sys.usb.config adb 2>/dev/null
    setprop ro.logd.size.stats 0 2>/dev/null
    setprop ro.logdumpd.enabled false 2>/dev/null
    
    # Disable kernel logging
    echo "0" > /proc/sys/kernel/printk_ratelimit 2>/dev/null
    echo "0" > /proc/sys/kernel/sysctl_writes_strict 2>/dev/null
    
    # Disable ftrace if available
    if [ -d /sys/kernel/debug/tracing ]; then
        echo "0" > /sys/kernel/debug/tracing/tracing_on 2>/dev/null
        echo "nop" > /sys/kernel/debug/tracing/current_tracer 2>/dev/null
        echo "0" > /sys/kernel/debug/tracing/events/enable 2>/dev/null
    fi
    
    # Disable strace
    setprop debug.atrace.tags.enableflags 0 2>/dev/null
    
    # Disable systrace
    setprop debug.force_rtl false 2>/dev/null
    
    # Disable selinux logging
    echo "0" > /sys/module/selinux/parameters/enforce 2>/dev/null 2>&1 || true
}

optimize_logcat

# Enhanced SurfaceFlinger and Graphics Optimization
optimize_graphics() {
    # Prioritize SurfaceFlinger for rendering
    change_task_cgroup "surfaceflinger" "top-app" "cpuset"
    change_task_cgroup "surfaceflinger" "foreground" "stune"
    change_task_nice "surfaceflinger" "-20"
    change_task_affinity "surfaceflinger" "ff"
    
    # Optimize graphics composer
    change_task_cgroup "android.hardware.graphics.composer" "top-app" "cpuset"
    change_task_cgroup "android.hardware.graphics.composer" "foreground" "stune"
    change_task_nice "android.hardware.graphics.composer" "-20"
    change_task_affinity "android.hardware.graphics.composer" "ff"
    
    # Optimize render threads
    change_task_cgroup "RenderThread" "top-app" "cpuset"
    change_task_nice "RenderThread" "-19"
    change_task_affinity "RenderThread" "ff"
    
    # Hardware acceleration properties
    setprop debug.sf.hw 1
    setprop debug.sf.latch_unsignaled 1
    setprop ro.hardware.keystore msm8998
    
    # Frame rate optimization
    setprop debug.force_rtl false
    setprop debug.hwui.drop_shadow_cache_size 6
    setprop debug.hwui.texture_cache_flushrate 0.4
    setprop debug.hwui.drop_shadow_cache_size 6
    
    # Disable VSync blocking
    setprop debug.atrace.tags.enableflags 0
    setprop debug.force_rtl false
    
    # Render performance properties
    setprop ro.hwui.render_ahead_lines 2
    setprop ro.hwui.texture_cache_size 72
}

optimize_graphics

# Memory and Task Management Optimization
change_task_affinity() {
    # $1:task_name $2:cpu_mask (hex format)
    local ps_ret
    ps_ret=$(ps -A 2>/dev/null || ps 2>/dev/null)
    
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | grep -v "PID" | awk '{print $1}'); do
        if [ -d "/proc/$temp_pid" ]; then
            for temp_tid in $(ls "/proc/$temp_pid/task/" 2>/dev/null); do
                # Set CPU affinity using taskset if available
                taskset -p "$2" "$temp_tid" 2>/dev/null || {
                    # Fallback: write directly to cpuset
                    echo "$temp_tid" > "/dev/cpuset/top-app/tasks" 2>/dev/null
                }
            done
        fi
    done
}

change_task_cgroup() {
    # $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
    local comm
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | grep -v "PID" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            comm="$(cat /proc/$temp_pid/task/$temp_tid/comm)"
            echo "$temp_tid" >"/dev/$3/$2/tasks"
        done
    done
}

change_task_nice() {
    # $1:task_name $2:nice(relative to 120)
    for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | grep -v "PID" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            renice -n +40 -p "$temp_tid"
            renice -n -19 -p "$temp_tid"
            renice -n "$2" -p "$temp_tid"
        done
    done
}

optimize_memory_management() {
    local ps_ret
    ps_ret=$(ps -A 2>/dev/null || ps 2>/dev/null)
    
    # Optimize kswapd (kernel swap daemon)
    # Higher priority, pin to efficiency cores
    change_task_nice "kswapd" "-10"
    change_task_affinity "kswapd" "0f"  # Use first 4 cores
    
    # Optimize oom_reaper (out of memory killer)
    # High priority, pin to efficiency cores
    change_task_nice "oom_reaper" "-10"
    change_task_affinity "oom_reaper" "0f"  # Use first 4 cores
    
    # Optimize memory compaction daemon
    change_task_nice "kcompactd" "-5" 2>/dev/null
    
    # Optimize writeback daemon
    change_task_nice "kthreadd" "-5" 2>/dev/null
    change_task_nice "writeback" "-5" 2>/dev/null
    
    # Memory pressure reduction
    echo "0" > /proc/sys/vm/watermark_scale_factor 2>/dev/null
    echo "0" > /proc/sys/vm/numa_stat 2>/dev/null
    
    # Aggressive memory reclaim
    echo "100" > /proc/sys/vm/swappiness 2>/dev/null
    echo "10" > /proc/sys/vm/dirty_ratio 2>/dev/null
    echo "5" > /proc/sys/vm/dirty_background_ratio 2>/dev/null
    
    # Disable memory overcommit safeguards
    echo "1" > /proc/sys/vm/overcommit_memory 2>/dev/null
    
    # Reduce memory fragmentation
    echo "1" > /proc/sys/vm/compact_unevictable_allowed 2>/dev/null
    
    # Disable transparent huge pages to reduce latency
    echo "never" > /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null
    echo "never" > /sys/kernel/mm/transparent_hugepage/defrag 2>/dev/null
    
    # Memory pool optimization
    for mem_pool in /sys/module/*/parameters/mempools; do
        if [ -d "$(dirname "$mem_pool")" ]; then
            echo "0" > "$mem_pool" 2>/dev/null
        fi
    done
}

optimize_memory_management

change_task_nice "kswapd" "-2"
change_task_nice "oom_reaper" "-2"
change_task_affinity "kswapd" "7f"
change_task_affinity "oom_reaper" "7f"
for queue in /sys/block/*/queue; do
    echo "0" > "$queue/iostats" 2>/dev/null
done
for h in /proc/sys/kernel; do
    echo "0" > "$h/perf_event_paranoid" 2>/dev/null
    echo "off" > "$h/printk_devkmsg" 2>/dev/null
    echo "0" > "$h/sched_latency_ns" 2>/dev/null
    echo "0" > "$h/randomize_va_space" 2>/dev/null
    echo "0" > "$h/timer_migration" 2>/dev/null
    echo "0" > "$h/sysctl_writes_strict" 2>/dev/null
    echo "0 0 0 0" > "$h/printk" 2>/dev/null
    echo "-1" > "$h/sched_rt_runtime_us" 2>/dev/null
    echo "200000" > "$h/threads-max" 2>/dev/null
    echo "0" > "$h/sched_tunable_scaling" 2>/dev/null
    echo "0" > "$h/panic" 2>/dev/null
    echo "0" > "$h/panic_on_oops" 2>/dev/null
    echo "2" > "$h/sched_rr_timeslice_ms" 2>/dev/null
    echo "0" > "$h/sched_energy_aware" 2>/dev/null
    echo "1" > "$h/sched_util_clamp_min" 2>/dev/null
    echo "1" > "$h/sched_util_clamp_min_rt_default" 2>/dev/null
    echo "2" > "$h/sched_pelt_multiplier" 2>/dev/null
    echo "1000000" > "$h/sched_rt_period_us" 2>/dev/null
done

# Universal Thermal Throttling Disable (works on all SOCs)
disable_thermal_throttling() {
        # Generic Thermal Zone Disable
    for thermal_zone in /sys/class/thermal/thermal_zone*; do
        echo "0" > "$thermal_zone/mode" 2>/dev/null
    done

    # Qualcomm MSM Thermal
    echo "0" > /sys/kernel/msm_thermal/enabled 2>/dev/null
    echo "N" > /sys/module/msm_thermal/parameters/enabled 2>/dev/null
    echo "0" > /sys/module/msm_thermal/core_control/enabled 2>/dev/null
    echo "0" > /sys/module/msm_thermal/vdd_restriction/enabled 2>/dev/null

            # Disable thermal cooling devices
        for cooling_device in /sys/class/thermal/cooling_device*; do
            if [ -d "$cooling_device" ]; then
                echo "0" > "$cooling_device/cur_state" 2>/dev/null
            fi
        done

        # Disable hardware monitoring thermal throttling
        for hwmon in /sys/class/hwmon/hwmon*/temp*_max; do
            if [ -f "$hwmon" ]; then
                # Set battery-safe temperature limit (in millidegrees)
                echo "50000" > "$hwmon" 2>/dev/null
            fi
        done
        
        # Battery thermal management for charging
        [ -f /sys/class/power_supply/battery/constant_charge_current_max ] && echo "2000000" > /sys/class/power_supply/battery/constant_charge_current_max 2>/dev/null
        [ -f /sys/class/power_supply/battery/batt_therm_fcc_limit ] && echo "2000000" > /sys/class/power_supply/battery/batt_therm_fcc_limit 2>/dev/null
        [ -f /sys/class/power_supply/bms/batt_therm_fcc_limit ] && echo "2000000" > /sys/class/power_supply/bms/batt_therm_fcc_limit 2>/dev/null
}

disable_thermal_throttling

# RCU and Kernel Optimization
echo "1" > /sys/kernel/rcu_normal 2>/dev/null  # Enable normal RCU for stability
echo "0" > /sys/kernel/rcu_expedited 2>/dev/null  # Keep expedited off for performance
echo "1" > /proc/sys/kernel/timer_migration 2>/dev/null
echo "0" > /sys/devices/system/cpu/isolated 2>/dev/null
echo "120" > /proc/sys/kernel/hung_task_timeout_secs 2>/dev/null  # Set reasonable timeout for stability

# Scheduler Tuning
[ -d /dev/stune/top-app ] && {
    echo "0" > /dev/stune/top-app/schedtune.boost 2>/dev/null  # Reduce boost for stability
    echo "1" > /dev/stune/top-app/schedtune.prefer_idle 2>/dev/null  # Prefer idle for better scheduling
}

# Enhanced scheduler features (kernel 4.9+, may not be available on all devices)
if [ -f /sys/kernel/debug/sched_features ]; then
    # NEXT_BUDDY: Improve cache locality
    echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features 2>/dev/null
    # TTWU_QUEUE: Enable task wake-up queue for stability
    echo "TTWU_QUEUE" > /sys/kernel/debug/sched_features 2>/dev/null
    # ENERGY_AWARE: Enable energy-aware scheduling
    echo "ENERGY_AWARE" > /sys/kernel/debug/sched_features 2>/dev/null
fi
# Debug and Tracing Disables
disable_debug_tracing() {
    # Ftrace
    [ -f /sys/kernel/debug/tracing/tracing_on ] && echo "0" > /sys/kernel/debug/tracing/tracing_on 2>/dev/null
    
    # RPM debugging
    [ -f /sys/kernel/debug/rpm_log ] && echo "0" > /sys/kernel/debug/rpm_log 2>/dev/null
    
    # Page clustering
    [ -f /proc/sys/vm/page-cluster ] && echo "0" > /proc/sys/vm/page-cluster 2>/dev/null
    
    # VM statistics interval
    [ -f /proc/sys/vm/stat_interval ] && echo "120" > /proc/sys/vm/stat_interval 2>/dev/null
    
    # Debug locks
    [ -f /proc/sys/kernel/debug_locks ] && echo "0" > /proc/sys/kernel/debug_locks 2>/dev/null
    
    # Kernel tracing
    [ -f /sys/kernel/tracing/tracing_on ] && echo "0" > /sys/kernel/tracing/tracing_on 2>/dev/null
    
    # Scheduler statistics
    [ -f /proc/sys/kernel/sched_schedstats ] && echo "0" > /proc/sys/kernel/sched_schedstats 2>/dev/null
    
    # Split lock mitigation
    [ -f /proc/sys/kernel/split_lock_mitigate ] && echo "0" > /proc/sys/kernel/split_lock_mitigate 2>/dev/null
}

# Scheduler Parameters Optimization
optimize_scheduler_params() {
    # Task migration batch size
    [ -f /proc/sys/kernel/sched_nr_migrate ] && echo "32" > /proc/sys/kernel/sched_nr_migrate 2>/dev/null
    
    # Performance event paranoia level
    [ -f /proc/sys/kernel/perf_event_paranoid ] && echo "0" > /proc/sys/kernel/perf_event_paranoid 2>/dev/null
    
    # Child process runs first
    [ -f /proc/sys/kernel/sched_child_runs_first ] && echo "1" > /proc/sys/kernel/sched_child_runs_first 2>/dev/null
    
    # Scheduler tuning scaling
    [ -f /proc/sys/kernel/sched_tunable_scaling ] && echo "0" > /proc/sys/kernel/sched_tunable_scaling 2>/dev/null
    
    # Memory compaction proactiveness
    [ -f /proc/sys/vm/compaction_proactiveness ] && echo "0" > /proc/sys/vm/compaction_proactiveness 2>/dev/null
    
    # Scheduler latency
    [ -f /proc/sys/kernel/sched_latency_ns ] && echo "4000000" > /proc/sys/kernel/sched_latency_ns 2>/dev/null
    
    # Auto group scheduler
    [ -f /proc/sys/kernel/sched_autogroup_enabled ] && echo "0" > /proc/sys/kernel/sched_autogroup_enabled 2>/dev/null
    
    # CPU time limits for perf events
    [ -f /proc/sys/kernel/perf_cpu_time_max_percent ] && echo "3" > /proc/sys/kernel/perf_cpu_time_max_percent 2>/dev/null
    
    # Migration cost threshold
    [ -f /proc/sys/kernel/sched_migration_cost_ns ] && echo "50000" > /proc/sys/kernel/sched_migration_cost_ns 2>/dev/null
    
    # Minimum granularity
    [ -f /proc/sys/kernel/sched_min_granularity_ns ] && echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns 2>/dev/null
    
    # Minimum task utilization for colocation
    [ -f /proc/sys/kernel/sched_min_task_util_for_colocation ] && echo "0" > /proc/sys/kernel/sched_min_task_util_for_colocation 2>/dev/null
    
    # Wakeup granularity
    [ -f /proc/sys/kernel/sched_wakeup_granularity_ns ] && echo "1500000" > /proc/sys/kernel/sched_wakeup_granularity_ns 2>/dev/null
}

# Module Parameters
optimize_module_params() {
        # MMC core SPI CRC
        [ -f /sys/module/mmc_core/parameters/use_spi_crc ] && echo "0" > /sys/module/mmc_core/parameters/use_spi_crc 2>/dev/null
        
        # CPUFreq bouncing
        [ -f /sys/module/cpufreq_bouncing/parameters/enable ] && echo "0" > /sys/module/cpufreq_bouncing/parameters/enable 2>/dev/null
        
        # CPUFreq Interactive Governor Optimization
        [ -f /sys/module/cpufreq_interactive/parameters/go_hispeed_load ] && echo "85" > /sys/module/cpufreq_interactive/parameters/go_hispeed_load 2>/dev/null
        [ -f /sys/module/cpufreq_interactive/parameters/hispeed_freq ] && cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq > /sys/module/cpufreq_interactive/parameters/hispeed_freq 2>/dev/null
        [ -f /sys/module/cpufreq_interactive/parameters/min_sample_time ] && echo "40000" > /sys/module/cpufreq_interactive/parameters/min_sample_time 2>/dev/null
        [ -f /sys/module/cpufreq_interactive/parameters/max_freq_hysteresis ] && echo "80000" > /sys/module/cpufreq_interactive/parameters/max_freq_hysteresis 2>/dev/null
        
        # Low Memory Killer Optimization
        [ -f /sys/module/lowmemorykiller/parameters/minfree ] && echo "1024,2048,4096,8192,12288,16384" > /sys/module/lowmemorykiller/parameters/minfree 2>/dev/null
        [ -f /sys/module/lowmemorykiller/parameters/cost ] && echo "32" > /sys/module/lowmemorykiller/parameters/cost 2>/dev/null
        
        # TCP Congestion Control Optimization
        [ -f /sys/module/tcp_cubic/parameters/beta ] && echo "819" > /sys/module/tcp_cubic/parameters/beta 2>/dev/null
        [ -f /sys/module/tcp_cubic/parameters/fast_convergence ] && echo "1" > /sys/module/tcp_cubic/parameters/fast_convergence 2>/dev/null
        [ -f /sys/module/tcp_cubic/parameters/tcp_friendliness ] && echo "1" > /sys/module/tcp_cubic/parameters/tcp_friendliness 2>/dev/null
        
        # Kernel Timer Optimization
        [ -f /sys/module/timer/parameters/sample_period ] && echo "1000000" > /sys/module/timer/parameters/sample_period 2>/dev/null
        
        # Scheduler Module Parameters
        [ -f /sys/module/bfq/parameters/timeout_sync ] && echo "100" > /sys/module/bfq/parameters/timeout_sync 2>/dev/null
        [ -f /sys/module/bfq/parameters/timeout_async ] && echo "250" > /sys/module/bfq/parameters/timeout_async 2>/dev/null
        
        # Qualcomm Specific Modules
        [ -f /sys/module/msm_thermal/parameters/enabled ] && echo "N" > /sys/module/msm_thermal/parameters/enabled 2>/dev/null
        [ -f /sys/module/qcom_cpufreq/parameters/boost ] && echo "0" > /sys/module/qcom_cpufreq/parameters/boost 2>/dev/null
    }

# OPlus Scheduler (if available)
optimize_oplus_scheduler() {
    # OPlus task scheduling info
    [ -f /proc/task_info/task_sched_info/task_sched_info_enable ] && echo "0" > /proc/task_info/task_sched_info/task_sched_info_enable 2>/dev/null
    
    # OPlus scheduler assist
    [ -f /proc/oplus_scheduler/sched_assist/sched_assist_enabled ] && echo "0" > /proc/oplus_scheduler/sched_assist/sched_assist_enabled 2>/dev/null
}

# Kernel Logging Optimization
optimize_kernel_logging() {
    # Printk levels (emergency, alert, crit, err)
    [ -f /proc/sys/kernel/printk ] && echo "0 0 0 0" > /proc/sys/kernel/printk 2>/dev/null
    
    # Printk device messages
    [ -f /proc/sys/kernel/printk_devkmsg ] && echo "off" > /proc/sys/kernel/printk_devkmsg 2>/dev/null
    
    # Printk PID logging
    [ -f /sys/module/printk/parameters/pid ] && echo "0" > /sys/module/printk/parameters/pid 2>/dev/null
    
    # Printk CPU logging
    [ -f /sys/module/printk/parameters/cpu ] && echo "0" > /sys/module/printk/parameters/cpu 2>/dev/null
    
    # Printk timestamp logging
    [ -f /sys/module/printk/parameters/time ] && echo "0" > /sys/module/printk/parameters/time 2>/dev/null
    
    # Printk mode
    [ -f /sys/kernel/printk_mode/printk_mode ] && echo "0" > /sys/kernel/printk_mode/printk_mode 2>/dev/null
    
    # Filesystem sync
    [ -f /sys/module/sync/parameters/fsync_enabled ] && echo "N" > /sys/module/sync/parameters/fsync_enabled 2>/dev/null
    
    # Ignore loglevel
    [ -f /sys/module/printk/parameters/ignore_loglevel ] && echo "1" > /sys/module/printk/parameters/ignore_loglevel 2>/dev/null
    
    # Printk rate limiting
    [ -f /sys/module/printk/parameters/printk_ratelimit ] && echo "0" > /sys/module/printk/parameters/printk_ratelimit 2>/dev/null
    
    # Console suspend
    [ -f /sys/module/printk/parameters/console_suspend ] && echo "1" > /sys/module/printk/parameters/console_suspend 2>/dev/null
}

# Panic Control
disable_panic_handling() {
    # Helper to safely write a value if the file exists
    write_safe() {
        local path="$1"; local val="$2"
        if [ -e "$path" ]; then
            if [ ! -w "$path" ]; then
                chmod 0644 "$path" 2>/dev/null || true
            fi
            echo "$val" > "$path" 2>/dev/null || true
        fi
    }

    # Explicit common panic knobs
    write_safe /proc/sys/kernel/panic 0
    write_safe /proc/sys/kernel/panic_on_oops 0
    write_safe /proc/sys/kernel/panic_on_warn 0
    write_safe /proc/sys/kernel/panic_on_rcu_stall 0
    write_safe /sys/module/kernel/parameters/panic 0
    write_safe /sys/module/kernel/parameters/panic_on_warn 0
    write_safe /sys/module/kernel/parameters/pause_on_oops 0
    write_safe /sys/module/kernel/panic_on_rcu_stall 0

    # Pattern-based disables: any kernel/module parameter containing "panic" or "pause_on_oops"
    for f in /proc/sys/kernel/*panic* /sys/module/*/parameters/*panic* /sys/module/*/parameters/*pause_on_oops*; do
        if [ -f "$f" ]; then
            echo "0" > "$f" 2>/dev/null || true
        fi
    done

    # Best-effort: disable soft/hard watchdog/lockup panic knobs if present
    for f in "/proc/sys/kernel/soft_watchdog" "/proc/sys/kernel/soft_lockup_panic" "/proc/sys/kernel/hard_lockup_panic"; do
        [ -f "$f" ] && echo "0" > "$f" 2>/dev/null || true
    done
}

# Memory Cache and Debug Optimization
optimize_memory_cache() {
    # Drop memory caches
    [ -f /proc/sys/vm/drop_caches ] && echo "3" > /proc/sys/vm/drop_caches 2>/dev/null
    
    # Compact memory
    [ -f /proc/sys/vm/compact_memory ] && echo "1" > /proc/sys/vm/compact_memory 2>/dev/null
    
    # Exception trace debug
    [ -f /proc/sys/debug/exception-trace ] && echo "0" > /proc/sys/debug/exception-trace 2>/dev/null
    
    # VFS cache pressure
    [ -f /proc/sys/vm/vfs_cache_pressure ] && echo "80" > /proc/sys/vm/vfs_cache_pressure 2>/dev/null
}

# DRI and GPU Debug Disables & GPU Optimization
disable_gpu_debug() {
    # DRI debug - Primary and secondary devices
    [ -f /sys/kernel/debug/dri/0/debug/enable ] && echo "0" > /sys/kernel/debug/dri/0/debug/enable 2>/dev/null
    [ -f /sys/kernel/debug/dri/1/debug/enable ] && echo "0" > /sys/kernel/debug/dri/1/debug/enable 2>/dev/null
    [ -f /sys/kernel/debug/dri/128/debug/enable ] && echo "0" > /sys/kernel/debug/dri/128/debug/enable 2>/dev/null
    
    # Spurious IRQ debug
    [ -f /sys/module/spurious/parameters/noirqdebug ] && echo "1" > /sys/module/spurious/parameters/noirqdebug 2>/dev/null
    
    # SDE rotator event logging
    [ -f /sys/kernel/debug/sde_rotator0/evtlog/enable ] && echo "0" > /sys/kernel/debug/sde_rotator0/evtlog/enable 2>/dev/null
    [ -f /sys/kernel/debug/sde_rotator1/evtlog/enable ] && echo "0" > /sys/kernel/debug/sde_rotator1/evtlog/enable 2>/dev/null
    
    # Disable GPU tracing
    [ -f /sys/kernel/debug/gpu/enable ] && echo "0" > /sys/kernel/debug/gpu/enable 2>/dev/null
    [ -f /sys/kernel/debug/graphics/enable ] && echo "0" > /sys/kernel/debug/graphics/enable 2>/dev/null
    
    # Qualcomm KGSL GPU Optimization
    for gpu_device in /sys/class/kgsl/kgsl-*/; do
        if [ -d "$gpu_device" ]; then
            # Set GPU to performance mode for better rendering
            if [ -f "$gpu_device/devfreq/governor" ]; then
                echo "performance" > "$gpu_device/devfreq/governor" 2>/dev/null
            fi
            # Disable GPU event logging
            if [ -f "$gpu_device/devfreq/events" ]; then
                echo "0" > "$gpu_device/devfreq/events" 2>/dev/null
            fi
            # Disable power counter traces
            if [ -f "$gpu_device/events/power_counter" ]; then
                echo "0" > "$gpu_device/events/power_counter" 2>/dev/null
            fi
            # Set maximum GPU frequency
            if [ -f "$gpu_device/devfreq/max_freq" ]; then
                max_freq=$(cat "$gpu_device/devfreq/max_freq" 2>/dev/null)
                echo "$max_freq" > "$gpu_device/devfreq/max_freq" 2>/dev/null
            fi
        fi
    done
    
    # Disable HWComposer debugging
    [ -f /sys/kernel/debug/hwcomposer/disable_debug ] && echo "1" > /sys/kernel/debug/hwcomposer/disable_debug 2>/dev/null
    [ -f /sys/kernel/debug/hwcomposer/enable ] && echo "0" > /sys/kernel/debug/hwcomposer/enable 2>/dev/null
    
    # Disable Adreno (GPU) specific debug features
    [ -f /sys/kernel/debug/adreno/enable ] && echo "0" > /sys/kernel/debug/adreno/enable 2>/dev/null
    [ -f /sys/kernel/debug/adreno/debugfs_maxdebug ] && echo "0" > /sys/kernel/debug/adreno/debugfs_maxdebug 2>/dev/null
    
    # Disable GPU memory debugging
    [ -f /sys/kernel/debug/gpumemdebug ] && echo "0" > /sys/kernel/debug/gpumemdebug 2>/dev/null
    [ -f /sys/kernel/debug/gpu/memtrack ] && echo "0" > /sys/kernel/debug/gpu/memtrack 2>/dev/null
    
    # Disable display pipeline debugging
    [ -f /sys/kernel/debug/sde ] && echo "0" > /sys/kernel/debug/sde 2>/dev/null
    [ -f /sys/kernel/debug/sde/stats ] && echo "0" > /sys/kernel/debug/sde/stats 2>/dev/null
    
    # Disable fence debug
    [ -f /sys/kernel/debug/sync/fence_timeline ] && echo "0" > /sys/kernel/debug/sync/fence_timeline 2>/dev/null
    
    # Disable MMU debug
    [ -f /sys/kernel/debug/gpu/mmu ] && echo "0" > /sys/kernel/debug/gpu/mmu 2>/dev/null
    
    # Disable ftrace GPU events
    if [ -d /sys/kernel/debug/tracing/events/gpu ]; then
        echo "0" > /sys/kernel/debug/tracing/events/gpu/enable 2>/dev/null
    fi
    if [ -d /sys/kernel/debug/tracing/events/sde ]; then
        echo "0" > /sys/kernel/debug/tracing/events/sde/enable 2>/dev/null
    fi
}
su -lp 2000 -c "cmd notification post -S bigtext -t 'Lynae' 'Tag' 'Lemme let you in on a little secret.'"
    exit 0
