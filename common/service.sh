#!/system/bin/sh
# GHenna Ye Shunguang
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done
}
    # Send notification about device model
su -lp 2000 -c "cmd notification post -S bigtext -t 'Ye Shunguang' 'Tag' 'I will be right here waiting.'"
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
    
# Aggressive Deep Sleep Configuration

# Reset and enable device idle modes
dumpsys deviceidle reset >/dev/null 2>&1
dumpsys deviceidle enable light >/dev/null 2>&1
dumpsys deviceidle enable deep >/dev/null 2>&1
dumpsys deviceidle force-idle >/dev/null 2>&1

# Aggressive Doze constants (shorter timers)
settings put global device_idle_constants \
    inactive_to=15000,motion_inactive_to=0,min_time_to_alarm=60000,max_idle_pending_time=30000,max_idle_pending_jobs_count=1,wait_for_unlock=true >/dev/null 2>&1

# Enable low power mode
settings put global low_power_mode 1 >/dev/null 2>&1
settings put global low_power_mode_trigger_level 15 >/dev/null 2>&1
settings put global low_power 1 >/dev/null 2>&1

# Disable network keep-alives
settings put global wifi_sleep_policy 2 >/dev/null 2>&1
settings put global mobile_data_always_on 0 >/dev/null 2>&1
settings put global wifi_always_on 0 >/dev/null 2>&1
settings put global background_data 0 >/dev/null 2>&1
settings put global auto_sync 0 >/dev/null 2>&1

# Restrict network operations during sleep
settings put global network_scoring_ui_enabled 0 >/dev/null 2>&1
settings put global airplane_mode_on 1 >/dev/null 2>&1

# Disable location services during sleep
settings put secure location_mode 0 >/dev/null 2>&1

# Disable adaptive battery management
settings put global adaptive_battery_management_enabled 0 >/dev/null 2>&1

# Disable wakeup sources
for wakeup in /sys/class/wakeup/*/active_count; do
    dir="$(dirname "$wakeup")"
    if [ -d "$dir" ]; then
        echo "disabled" > "$dir/active_wakeup" 2>/dev/null
    fi
done

# Disable wakelocks
echo "0" > /sys/power/wake_lock 2>/dev/null || true

# Force battery saver mode
cmd battery set level 100 >/dev/null 2>&1
cmd battery unplug >/dev/null 2>&1

# Suspend background jobs
cmd jobscheduler run -u >/dev/null 2>&1 || true

# Trim memory caches
pm trim-caches 999999999 >/dev/null 2>&1

optimize_gms_doze() {
    local gms_pkg="com.google.android.gms"
    local gms_components=(
        "$gms_pkg/.chimera.GmsIntentOperationService"
        "$gms_pkg/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"
        "$gms_pkg/com.google.android.gms.chimera.GmsInitializer"
        "$gms_pkg/com.google.android.gms.analytics.service.AnalyticsService"
        "$gms_pkg/com.google.android.gms.phenotype.service.PhenotypeService"
        "$gms_pkg/com.google.android.gms.update.SystemUpdateService"
        "$gms_pkg/com.google.android.gms.update.SystemUpdateActivity"
        "$gms_pkg/com.google.android.gms.mdm.services.DevicePolicyService"
        "$gms_pkg/com.google.android.gms.mdm.MdmService"
        "$gms_pkg/com.google.android.gms.usagereporting.service.UsageReportingService"
        "$gms_pkg/com.google.android.gms.location.service.LocationService"
        "$gms_pkg/com.google.android.gms.location.GeofenceService"
    )

    # Disable selected GMS components
    for component in "${gms_components[@]}"; do
        if su -c "pm disable $component" >/dev/null 2>&1; then
            echo "    [-] Disabled: $component"
        else
            echo "    [!] Failed to disable: $component"
        fi
    done

    # Apply background restrictions
    su -c "pm set-inactive $gms_pkg true" >/dev/null 2>&1
    su -c "cmd appops set $gms_pkg RUN_IN_BACKGROUND ignore" >/dev/null 2>&1
    su -c "cmd appops set $gms_pkg WAKE_LOCK ignore" >/dev/null 2>&1

    # Remove from device idle whitelist
    su -c "cmd deviceidle whitelist -$gms_pkg" >/dev/null 2>&1

    # Force-stop the package
    su -c "am force-stop $gms_pkg" >/dev/null 2>&1
}

    # Enhanced Tracing and Logging Optimization
    disable_tracing_and_logging() {
        # Disable accessibility tracing
        cmd accessibility stop-trace 2>/dev/null
        
        # Disable migard tracing (if available)
        cmd migard dump-trace false 2>/dev/null
        cmd migard start-trace false 2>/dev/null
        cmd migard stop-trace true 2>/dev/null
        cmd migard trace-buffer-size 0 2>/dev/null
        
        # Disable input method tracing
        cmd input_method tracing stop 2>/dev/null
        
        # Disable window and UI tracing
        cmd window tracing size 0 2>/dev/null
        cmd window tracing stop 2>/dev/null
        
        # Disable status bar tracing
        cmd statusbar tracing stop 2>/dev/null
        
        # Disable memory tracing
        cmd memory_trace disable 2>/dev/null
        
        # Disable animation tracing
        cmd animation tracing stop 2>/dev/null
        
        # Disable network tracing
        cmd net_utils tracing disable 2>/dev/null
        
        # Disable graphics tracing
        cmd graphics tracing stop 2>/dev/null
        
        # Disable package manager tracing
        cmd package tracing stop 2>/dev/null
        
        # Disable wm tracing
        cmd wm tracing stop 2>/dev/null
        
        # Disable activity manager tracing
        cmd activity tracing stop 2>/dev/null
        
        # Disable broadcast tracing
        cmd broadcast tracing disable 2>/dev/null
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
        # $1: task_name (pattern)
        # $2: cpu_mask (hex or decimal acceptable for taskset)
        local name mask ps_ret pid tid
        name="$1"
        mask="$2"
        ps_ret=$(ps -A 2>/dev/null || ps 2>/dev/null)

        echo "$ps_ret" | grep -i -E "$name" | grep -v "PID" | awk '{print $1}' | while read -r pid; do
            [ -d "/proc/$pid" ] || continue

            if command -v taskset >/dev/null 2>&1; then
                # Prefer taskset when available (works on both pid and tid)
                taskset -p "$mask" "$pid" 2>/dev/null || true
                for tid in $(ls "/proc/$pid/task/" 2>/dev/null); do
                    taskset -p "$mask" "$tid" 2>/dev/null || true
                done
            else
                # Fallback: if cpuset exists, try to move threads into top-app (best-effort)
                for tid in $(ls "/proc/$pid/task/" 2>/dev/null); do
                    if [ -w "/dev/cpuset/top-app/tasks" ]; then
                        echo "$tid" > "/dev/cpuset/top-app/tasks" 2>/dev/null || true
                    fi
                done
            fi
        done
    }

    change_task_cgroup() {
        # $1: task_name (pattern)
        # $2: cgroup_name
        # $3: "cpuset"/"stune" (subsystem)
        local name cg sub ps_ret pid tid comm target_dir
        name="$1"
        cg="$2"
        sub="$3"
        ps_ret=$(ps -A 2>/dev/null || ps 2>/dev/null)

        target_dir="/dev/${sub}/${cg}"
        if [ ! -d "$target_dir" ] && [ ! -f "$target_dir/tasks" ]; then
            return 0
        fi
        echo "$ps_ret" | grep -i -E "$name" | grep -v "PID" | awk '{print $1}' | while read -r pid; do
            [ -d "/proc/$pid" ] || continue
            for tid in $(ls "/proc/$pid/task/" 2>/dev/null); do
                comm="$(cat /proc/$pid/task/$tid/comm 2>/dev/null)"
                if [ -w "$target_dir/tasks" ]; then
                    echo "$tid" > "$target_dir/tasks" 2>/dev/null || true
                fi
            done
        done
    }

    change_task_nice() {
        # $1: task_name (pattern)
        # $2: nice value (can be negative)
        local name nice_val ps_ret pid tid
        name="$1"
        nice_val="$2"
        ps_ret=$(ps -A 2>/dev/null || ps 2>/dev/null)

        echo "$ps_ret" | grep -i -E "$name" | grep -v "PID" | awk '{print $1}' | while read -r pid; do
            [ -d "/proc/$pid" ] || continue
            for tid in $(ls "/proc/$pid/task/" 2>/dev/null); do
                renice -n "$nice_val" -p "$tid" 2>/dev/null || true
            done
        done
    }

    optimize_memory_management() {
        # Define safe write helper locally if not in scope
        safe_sys_write() {
            local path="$1" val="$2"
            if [ -e "$path" ]; then
                [ -w "$path" ] || chmod 0644 "$path" 2>/dev/null || true
                printf "%s" "$val" > "$path" 2>/dev/null || true
            fi
        }

# Check for LMKD daemon (Android 11+)
check_lmkd() {
    if pidof lmkd >/dev/null 2>&1; then
        echo "[+] LMKD detected: modern low memory killer active" \
            >/dev/kmsg 2>/dev/null || echo "[+] LMKD detected"
        
        # Optional: show LMKD process info
        local lmkd_pid
        lmkd_pid=$(pidof lmkd)
        echo "    [-] LMKD PID: $lmkd_pid"
        
        # Optional: check memory pressure levels
        if [ -r /proc/pressure/memory ]; then
            echo "    [-] Memory pressure status:"
            cat /proc/pressure/memory
        fi
    else
        echo "[!] LMKD not detected; device may use legacy lowmemorykiller" \
            >/dev/kmsg 2>/dev/null || echo "[!] LMKD not detected"
    fi
}

        # Optimize kernel memory daemons
        change_task_nice "kswapd" "-10"
        change_task_affinity "kswapd" "0f"
        change_task_nice "oom_reaper" "-10"
        change_task_affinity "oom_reaper" "0f"
        change_task_nice "kcompactd" "-5"
        change_task_nice "writeback" "-5"

        # Memory tuning parameters
        safe_sys_write /proc/sys/vm/watermark_scale_factor 0
        safe_sys_write /proc/sys/vm/numa_stat 0
        safe_sys_write /proc/sys/vm/swappiness 100
        safe_sys_write /proc/sys/vm/dirty_ratio 10
        safe_sys_write /proc/sys/vm/dirty_background_ratio 5
        safe_sys_write /proc/sys/vm/overcommit_memory 1
        safe_sys_write /proc/sys/vm/compact_unevictable_allowed 1

        # Disable transparent huge pages for latency reduction
        safe_sys_write /sys/kernel/mm/transparent_hugepage/enabled never
        safe_sys_write /sys/kernel/mm/transparent_hugepage/defrag never

        # Clear memory pools
        for pool in /sys/module/*/parameters/mempools; do
            [ -f "$pool" ] && safe_sys_write "$pool" 0
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
        echo "2" > "$h/perf_event_paranoid" 2>/dev/null
        echo "on" > "$h/printk_devkmsg" 2>/dev/null
        echo "5000000" > "$h/sched_latency_ns" 2>/dev/null
        echo "2" > "$h/randomize_va_space" 2>/dev/null
        echo "1" > "$h/timer_migration" 2>/dev/null
        echo "1" > "$h/sysctl_writes_strict" 2>/dev/null
        echo "4 4 1 7" > "$h/printk" 2>/dev/null
        echo "950000" > "$h/sched_rt_runtime_us" 2>/dev/null
        echo "32768" > "$h/threads-max" 2>/dev/null
        echo "1" > "$h/sched_tunable_scaling" 2>/dev/null
        echo "10" > "$h/panic" 2>/dev/null
        echo "1" > "$h/panic_on_oops" 2>/dev/null
        echo "100" > "$h/sched_rr_timeslice_ms" 2>/dev/null
        echo "1" > "$h/sched_energy_aware" 2>/dev/null
        echo "0" > "$h/sched_util_clamp_min" 2>/dev/null
        echo "0" > "$h/sched_util_clamp_min_rt_default" 2>/dev/null
        echo "1" > "$h/sched_pelt_multiplier" 2>/dev/null
        echo "1000000" > "$h/sched_rt_period_us" 2>/dev/null
    done

    # Universal Thermal Throttling Disable (works on all SOCs)
    # Thermal Throttling: relax non-battery-related thermal controls safely
    # Service Script: Thermal Throttling Relaxation + Charging Profiles + Temp-Aware Charging
disable_thermal_throttling() {
    local tz type cd_type

    for tz in /sys/class/thermal/thermal_zone*; do
        [ -d "$tz" ] || continue
        type="$(cat "$tz/type" 2>/dev/null || echo "")"
        case "$type" in
            *battery*|*charger*|*bms*|*fuel_gauge*|*battery_therm*) continue ;;
        esac
        [ -w "$tz/mode" ] && echo "disabled" > "$tz/mode" 2>/dev/null || true
    done

    for cd in /sys/class/thermal/cooling_device*; do
        [ -d "$cd" ] || continue
        cd_type="$(cat "$cd/type" 2>/dev/null || echo "")"
        case "$cd_type" in
            *battery*|*charger*|*bms*|*fuel_gauge*) continue ;;
        esac
        [ -w "$cd/cur_state" ] && echo "0" > "$cd/cur_state" 2>/dev/null || true
    done
}
# ============================================================
# Charging Limit Control
# ============================================================
set_charge_limit() {
    local limit_ma=$1
    local path="/sys/class/power_supply/battery/constant_charge_current_max"

    if [ -w "$path" ]; then
        echo $((limit_ma * 1000)) > "$path" 2>/dev/null || true
    fi
}

# ============================================================
# Charging Mode Selector
# ============================================================
set_charge_mode() {
    local mode=$1
    case "$mode" in
        balanced)
            set_charge_limit 3000   # ~33W
            echo "Charging mode set to BALANCED (~33W)"
            ;;
        fast)
            set_charge_limit 6000   # ~67W
            echo "Charging mode set to FAST (~67W)"
            ;;
        *)
            echo "Unknown mode: $mode"
            echo "Available modes: balanced, fast"
            ;;
    esac
}

# ============================================================
# Temperature-Aware Charging
# ============================================================
set_temp_aware_charge() {
    local temp_path="/sys/class/power_supply/battery/temp"
    local temp_raw temp_c

    if [ -r "$temp_path" ]; then
        temp_raw=$(cat "$temp_path")
        temp_c=$((temp_raw / 10))   # convert to °C

        if [ "$temp_c" -ge 45 ]; then
            # High temp → force balanced mode
            set_charge_limit 3000
            echo "Battery temp ${temp_c}°C: limiting to BALANCED (~33W)"
        elif [ "$temp_c" -ge 40 ]; then
            # Moderate temp → reduce fast mode slightly
            set_charge_limit 4500
            echo "Battery temp ${temp_c}°C: limiting to ~45W"
        else
            # Normal temp → allow fast mode
            set_charge_limit 6000
            echo "Battery temp ${temp_c}°C: allowing FAST (~67W)"
        fi
    fi
}

# ============================================================
# Run functions
# ============================================================
disable_thermal_throttling
# Example usage:
# set_charge_mode balanced
# set_charge_mode fast
# set_temp_aware_charge
 # Do NOT modify battery charging or FCC limits — leave battery/charging controls alone

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
# Panic Control
disable_panic_handling()
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

    # Scheduler Parameters Optimization
    optimize_scheduler_params() {

        # Helper to safely write to sysfs/proc files if present
        safe_sys_write() {
            local path="$1" val="$2"
            if [ -e "$path" ]; then
                if [ ! -w "$path" ]; then
                    chmod 0644 "$path" 2>/dev/null || true
                fi
                printf "%s" "$val" > "$path" 2>/dev/null || true
            fi
        }

        # Disable I/O debugging for existing block devices (iterate actual devices)
        for devpath in /sys/block/*; do
            [ -d "$devpath" ] || continue
            dev="$(basename "$devpath")"
            safe_sys_write "/sys/block/${dev}/queue/iostats" "0"
        done

        # Scheduler and VM tuning (safe writes)
        safe_sys_write /proc/sys/kernel/sched_energy_aware 1
        safe_sys_write /proc/sys/kernel/sched_nr_migrate 32
        safe_sys_write /proc/sys/kernel/perf_event_paranoid 0
        safe_sys_write /proc/sys/kernel/sched_child_runs_first 1
        safe_sys_write /proc/sys/kernel/sched_tunable_scaling 0
        safe_sys_write /proc/sys/vm/compaction_proactiveness 0
        safe_sys_write /proc/sys/kernel/sched_latency_ns 4000000
        safe_sys_write /proc/sys/kernel/sched_autogroup_enabled 0
        safe_sys_write /proc/sys/kernel/perf_cpu_time_max_percent 3
        safe_sys_write /proc/sys/kernel/sched_migration_cost_ns 50000
        safe_sys_write /proc/sys/kernel/sched_min_granularity_ns 1000000
        safe_sys_write /proc/sys/kernel/sched_min_task_util_for_colocation 0
        safe_sys_write /proc/sys/kernel/sched_wakeup_granularity_ns 1500000
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
    
    # Disable HWComposer debugging
    [ -f /sys/kernel/debug/hwcomposer/disable_debug ] && echo "1" > /sys/kernel/debug/hwcomposer/disable_debug 2>/dev/null
    [ -f /sys/kernel/debug/hwcomposer/enable ] && echo "0" > /sys/kernel/debug/hwcomposer/enable 2>/dev/null
    
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
su -lp 2000 -c "cmd notification post -S bigtext -t 'Ye Shunguang' 'Tag' ' Whenever you need me.'"
    exit 0
