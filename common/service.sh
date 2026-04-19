#!/system/bin/sh
# GHenna Angela
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

sleep 5

# Send notification about device model
su -lp 2000 -c "cmd notification post -S bigtext -t 'Angela' Tag 'I can do all the chores!'"

safe_sys_write() {
    local path="$1" val="$2"
    if [ -e "$path" ]; then
        [ -w "$path" ] || chmod 0644 "$path" 2>/dev/null || true
        printf "%s" "$val" > "$path" 2>/dev/null || true
    fi
}

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

        # Deep sleep / Doze optimization (shorter + more robust)
        deep_sleep_tweaks() {
            local key val

            # Reset and enable Doze/DeviceIdle
            for cmd in \
                "dumpsys deviceidle reset" \
                "dumpsys deviceidle enable light" \
                "dumpsys deviceidle enable deep" \
                "dumpsys deviceidle force-idle"; do
                $cmd >/dev/null 2>&1 || true
            done

            # Aggressive Doze constants
            settings put global device_idle_constants \
                inactive_to=15000,motion_inactive_to=0,min_time_to_alarm=60000,max_idle_pending_time=30000,max_idle_pending_jobs_count=1,wait_for_unlock=true >/dev/null 2>&1

            # Network / low-power restrictions
            for kv in \
                "low_power_mode=1" \
                "low_power_mode_trigger_level=15" \
                "low_power=1" \
                "wifi_sleep_policy=2" \
                "mobile_data_always_on=0" \
                "wifi_always_on=0" \
                "background_data=0" \
                "auto_sync=0" \
                "network_scoring_ui_enabled=0" \
                "airplane_mode_on=1" \
                "adaptive_battery_management_enabled=0"; do
                key="${kv%%=*}"
                val="${kv#*=}"
                settings put global "$key" "$val" >/dev/null 2>&1
            done

            # Disable location services during sleep
            settings put secure location_mode 0 >/dev/null 2>&1

            # Disable wakelocks / suspend background jobs
            echo "0" > /sys/power/wake_lock 2>/dev/null || true
            cmd jobscheduler run -u >/dev/null 2>&1 || true
        }
    }

# Trim memory caches
pm trim-caches 999999999 >/dev/null 2>&1
optimize_gms_doze() {
    # Disable selected GMS components
    for component in "${gms_components[@]}"; do
        if su -c "pm disable $component" >/dev/null 2>&1; then
            echo "    [-] Disabled: $component"
        else
            echo "    [!] Failed to disable: $component"
        fi
    done
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
    # Apply background restrictions
    su -c "pm set-inactive $gms_pkg true" >/dev/null 2>&1
    su -c "cmd appops set $gms_pkg RUN_IN_BACKGROUND ignore" >/dev/null 2>&1
    su -c "cmd appops set $gms_pkg WAKE_LOCK ignore" >/dev/null 2>&1
    # Remove from device idle whitelist
    su -c "cmd deviceidle whitelist -$gms_pkg" >/dev/null 2>&1
    # Force-stop the package
    su -c "am force-stop $gms_pkg" >/dev/null 2>&1
}

    # Aggressive Logcat + Kernel Stability Optimization
    optimize_logcat() {
        # Safe sysfs/proc writer (best-effort)
        safe_write() {
            local path="$1" val="$2"
            [ -e "$path" ] || return 0
            [ -w "$path" ] || chmod 0644 "$path" 2>/dev/null || true
            printf "%s" "$val" > "$path" 2>/dev/null || true
        }

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

        # Kernel stability: reduce printk noise and disable panic triggers
        safe_write /proc/sys/kernel/printk_ratelimit 0
        safe_write /proc/sys/kernel/sysctl_writes_strict 0
        safe_write /proc/sys/kernel/printk "0 0 0 0"
        safe_write /proc/sys/kernel/printk_devkmsg "off"
        safe_write /proc/sys/kernel/panic 0
        safe_write /proc/sys/kernel/panic_on_oops 0
        safe_write /proc/sys/kernel/panic_on_warn 0
        safe_write /proc/sys/kernel/soft_lockup_panic 0
        safe_write /proc/sys/kernel/hard_lockup_panic 0

        # Disable ftrace if available
        if [ -d /sys/kernel/debug/tracing ]; then
            safe_write /sys/kernel/debug/tracing/tracing_on 0
            safe_write /sys/kernel/debug/tracing/current_tracer nop
            safe_write /sys/kernel/debug/tracing/events/enable 0
        fi

        # Disable strace
        setprop debug.atrace.tags.enableflags 0 2>/dev/null

        # Disable systrace
        setprop debug.force_rtl false 2>/dev/null

        # Disable selinux logging
        safe_write /sys/module/selinux/parameters/enforce 0
    }

    # Enhanced SurfaceFlinger & Graphics Optimization
    optimize_graphics() {
        # Safe setter helpers (best-effort)
        safe_write() {
            local path="$1" val="$2"
            [ -e "$path" ] || return 0
            [ -w "$path" ] || chmod 0644 "$path" 2>/dev/null || true
            printf "%s" "$val" > "$path" 2>/dev/null || true
            local proc
            for proc in "surfaceflinger" "android.hardware.graphics.composer" "RenderThread" "audioserver" "system_server"; do
            change_task_nice "$proc" "-10"
            change_task_affinity "$proc" "ff"
    done
        }

        safe_setprop() {
            command -v setprop >/dev/null 2>&1 || return 0
            setprop "$1" "$2" 2>/dev/null || true
        }

        # Prioritize graphics-critical threads
        for proc in "surfaceflinger" "android.hardware.graphics.composer" "RenderThread"; do
            change_task_cgroup "$proc" "top-app" "cpuset"
            change_task_cgroup "$proc" "foreground" "stune"
        done

        change_task_nice "surfaceflinger" "-20"
        change_task_affinity "surfaceflinger" "ff"
        change_task_nice "android.hardware.graphics.composer" "-20"
        change_task_affinity "android.hardware.graphics.composer" "ff"
        change_task_nice "RenderThread" "-19"
        change_task_affinity "RenderThread" "ff"

        # Hardware acceleration properties
        safe_setprop debug.sf.hw 1
        safe_setprop debug.sf.latch_unsignaled 1
        safe_setprop debug.sf.disable_backpressure 1
        
        # Disable VSync blocking / tracing
        safe_setprop debug.atrace.tags.enableflags 0
        safe_setprop debug.force_rtl false

        # Render performance properties
        safe_setprop ro.hwui.render_ahead_lines 2
        safe_setprop ro.hwui.texture_cache_size 72

        # Ensure kernel doesn't log too much during graphics-intensive work
        safe_write /proc/sys/kernel/printk_ratelimit 0
        safe_write /proc/sys/kernel/sysctl_writes_strict 0
    }

    # Memory and Task Management Optimization
    change_task_affinity() {
        # $1: task_name (pattern)
        # $2: cpu_mask (hex or decimal acceptable for taskset)
        local name="$1" mask="$2" pid tid
        # Use pgrep for efficient PID lookup (case-insensitive match)
        for pid in $(pgrep -i "$name" 2>/dev/null); do
            [ -d "/proc/$pid" ] || continue
            if command -v taskset >/dev/null 2>&1; then
                # Set affinity for main process
                taskset -p "$mask" "$pid" 2>/dev/null || true
                # Set affinity for all threads
                for tid in /proc/$pid/task/*; do
                    [ -d "$tid" ] || continue
                    tid=${tid##*/}
                    taskset -p "$mask" "$tid" 2>/dev/null || true
                done
            else
                # Fallback: move threads to top-app cpuset
                for tid in /proc/$pid/task/*; do
                    [ -d "$tid" ] || continue
                    tid=${tid##*/}
                    if [ -w "/dev/cpuset/top-app/tasks" ]; then
                        echo "$tid" > "/dev/cpuset/top-app/tasks" 2>/dev/null || true
                    fi
                done
            fi
        done
        safe_sys_write /proc/sys/vm/compact_unevictable_allowed 1
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

kill_memory_hogs() {
    local proc pid
    for proc in \
        "com.google.android.gms" \
        "com.android.chrome" \
        "com.instagram.android" \
        "com.twitter.android" \
        "com.facebook.katana"; do
        if pidof "$proc" >/dev/null 2>/dev/null 2>&1; then
            echo "[!] High-RAM condition: stopping $proc" >/dev/kmsg 2>/dev/null || echo "[!] High-RAM condition: stopping $proc"
            am force-stop "$proc" >/dev/null 2>&1 || true
        fi
        for pid in $(pidof "$proc" 2>/dev/null); do
            [ -n "$pid" ] && kill -9 "$pid" >/dev/null 2>&1 || true
        done
    done
}

# Check for LMKD daemon and monitor RAM levels
check_lmkd() {
    local lmkd_pid ram_total_kb avail_kb used_kb used_pct threshold_kb=262144 threshold_pct=70

    if pidof lmkd >/dev/null 2>&1; then
        echo "[+] LMKD detected: modern low memory killer active" \
            >/dev/kmsg 2>/dev/null || echo "[+] LMKD detected"
        
        # Optional: show LMKD process info
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

    # Monitor available RAM and trigger cleanup if low or if RAM usage is high
    if [ -r /proc/meminfo ]; then
        ram_total_kb=$(awk '/MemTotal:/ {print $2}' /proc/meminfo 2>/dev/null)
        avail_kb=$(awk '/MemAvailable:/ {print $2}' /proc/meminfo 2>/dev/null)

        if [ -n "$ram_total_kb" ] && [ -n "$avail_kb" ] && [ "$ram_total_kb" -gt 0 ]; then
            used_kb=$((ram_total_kb - avail_kb))
            used_pct=$((used_kb * 100 / ram_total_kb))
            if [ "$used_pct" -ge "$threshold_pct" ] || [ "$avail_kb" -lt "$threshold_kb" ]; then
                echo "[!] High RAM usage detected: ${used_pct}% used, ${avail_kb}KB available" \
                    >/dev/kmsg 2>/dev/null || echo "[!] High RAM usage detected: ${used_pct}% used, ${avail_kb}KB available"
                
                pm trim-caches 999999999 >/dev/null 2>&1
                echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || true
                echo 1 > /proc/sys/vm/compact_memory 2>/dev/null || true
                am broadcast -a android.intent.action.GC >/dev/null 2>&1 || true
                kill_memory_hogs
            else
                echo "[+] RAM OK: ${used_pct}% used, ${avail_kb}KB available" >/dev/kmsg 2>/dev/null || true
            fi
        fi
    fi
}

# Memory tuning parameters
safe_sys_write /proc/sys/vm/watermark_scale_factor 1
safe_sys_write /proc/sys/vm/numa_stat 0
safe_sys_write /proc/sys/vm/swappiness 60
safe_sys_write /proc/sys/vm/dirty_ratio 15
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

    change_task_nice "kswapd" "0"
    change_task_nice "oom_reaper" "-5"
    change_task_affinity "kswapd" "0f"
    change_task_affinity "oom_reaper" "0f"
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
# Charging Limit Control
set_charge_limit() {
    local limit_ma=$1
    local path="/sys/class/power_supply/battery/constant_charge_current_max"

    if [ -w "$path" ]; then
        echo $((limit_ma * 1000)) > "$path" 2>/dev/null || true
    fi
}

get_device_max_charge_limit() {
    local path="/sys/class/power_supply/battery/constant_charge_current_max"
    local limit_ma=6000
    local raw

    if [ -r "$path" ]; then
        raw=$(cat "$path" 2>/dev/null || echo "")
        case "$raw" in
            ''|*[!0-9]*)
                ;;
            *)
                raw=$((raw / 1000))
                if [ "$raw" -gt "$limit_ma" ]; then
                    limit_ma="$raw"
                fi
                ;;
        esac
    fi

    printf '%s' "$limit_ma"
}

# Charging Mode Selector
set_charge_mode() {
    local mode=$1
    local max_limit

    case "$mode" in
        balanced)
            set_charge_limit 3000   # ~33W
            echo "Charging mode set to BALANCED (~33W)"
            ;;
        fast)
            max_limit=$(get_device_max_charge_limit)
            set_charge_limit "$max_limit"
            echo "Charging mode set to FAST (~${max_limit}mA)"
            ;;
        *)
            echo "Unknown mode: $mode"
            echo "Available modes: balanced, fast"
            ;;
    esac
}

# Temperature-Aware Charging
set_temp_aware_charge() {
    local temp_path="/sys/class/power_supply/battery/temp"
    local temp_raw temp_c max_limit

    if [ -r "$temp_path" ]; then
        temp_raw=$(cat "$temp_path" 2>/dev/null || echo "")
        case "$temp_raw" in
            ''|*[!0-9]*)
                echo "Battery temp unreadable: '$temp_raw'"
                return 1
                ;;
        esac

        temp_c=$((temp_raw / 10))   # convert to °C
        max_limit=$(get_device_max_charge_limit)

        if [ "$temp_c" -ge 60 ]; then
            set_charge_limit 0
            echo "Battery temp ${temp_c}°C: charging disabled"
        elif [ "$temp_c" -ge 50 ]; then
            set_charge_limit 4000
            echo "Battery temp ${temp_c}°C: reduced to ~18W"
        elif [ "$temp_c" -ge 45 ]; then
            set_charge_limit 4500
            echo "Battery temp ${temp_c}°C: reduced to ~45W"
        else
            set_charge_limit "$max_limit"
            echo "Battery temp ${temp_c}°C: allowing device max fast charge (~${max_limit}mA)"
        fi
    fi
}

# RCU and Kernel Optimization
echo "1" > /sys/kernel/rcu_normal 2>/dev/null
echo "0" > /sys/kernel/rcu_expedited 2>/dev/null
echo "1" > /proc/sys/kernel/timer_migration 2>/dev/null
echo "0" > /sys/devices/system/cpu/isolated 2>/dev/null
echo "120" > /proc/sys/kernel/hung_task_timeout_secs 2>/dev/null

# Scheduler Tuning
[ -d /dev/stune/top-app ] && {
    echo "0" > /dev/stune/top-app/schedtune.boost 2>/dev/null
    echo "1" > /dev/stune/top-app/schedtune.prefer_idle 2>/dev/null
}

# Enhanced scheduler features
if [ -f /sys/kernel/debug/sched_features ]; then
    # NEXT_BUDDY: Improve cache locality
    echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features 2>/dev/null
    # TTWU_QUEUE: Enable task wake-up queue for stability
    echo "TTWU_QUEUE" > /sys/kernel/debug/sched_features 2>/dev/null
    # ENERGY_AWARE: Enable energy-aware scheduling
    echo "ENERGY_AWARE" > /sys/kernel/debug/sched_features 2>/dev/null
fi
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

    # disables any kernel/module parameter containing "panic" or "pause_on_oops"
    for f in /proc/sys/kernel/*panic* /sys/module/*/parameters/*panic* /sys/module/*/parameters/*pause_on_oops*; do
        if [ -f "$f" ]; then
            echo "0" > "$f" 2>/dev/null || true
        fi
    done

    # disable soft/hard watchdog/lockup panic knobs if present
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

        # Disable I/O debugging for existing block devices
        for devpath in /sys/block/*; do
            [ -d "$devpath" ] || continue
            dev="$(basename "$devpath")"
            safe_sys_write "/sys/block/${dev}/queue/iostats" "0"

            # Enhanced I/O optimizations
            # Set I/O scheduler to bfq, else noop for SSD-like performance
            if [ -f "/sys/block/${dev}/queue/scheduler" ]; then
                if grep -q "bfq" "/sys/block/${dev}/queue/scheduler" 2>/dev/null; then
                    echo "bfq" > "/sys/block/${dev}/queue/scheduler" 2>/dev/null || true
                elif grep -q "noop" "/sys/block/${dev}/queue/scheduler" 2>/dev/null; then
                    echo "noop" > "/sys/block/${dev}/queue/scheduler" 2>/dev/null || true
                fi
            fi

            # Increase read-ahead for better sequential I/O
            safe_sys_write "/sys/block/${dev}/queue/read_ahead_kb" "2048"

            # Optimize queue depth
            safe_sys_write "/sys/block/${dev}/queue/nr_requests" "128"

            # Disable entropy contribution from I/O for performance
            safe_sys_write "/sys/block/${dev}/queue/add_random" "0"

            # Assume SSD for modern devices
            safe_sys_write "/sys/block/${dev}/queue/rotational" "0"

            # Reduce I/O latency
            safe_sys_write "/sys/block/${dev}/queue/iosched/slice_idle" "0"
            safe_sys_write "/sys/block/${dev}/queue/iosched/group_idle" "1"
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
        safe_write() {
            [ -f "$1" ] && echo "$2" > "$1" 2>/dev/null
        }
        safe_write /proc/sys/kernel/printk "0 0 0 0"
        safe_write /proc/sys/kernel/printk_devkmsg "off"
        safe_write /sys/module/printk/parameters/pid "0"
        safe_write /sys/module/printk/parameters/cpu "0"
        safe_write /sys/module/printk/parameters/time "0"
        safe_write /sys/kernel/printk_mode/printk_mode "0"
        safe_write /sys/module/sync/parameters/fsync_enabled "N"
        safe_write /sys/module/printk/parameters/ignore_loglevel "1"
        safe_write /sys/module/printk/parameters/printk_ratelimit "0"
        safe_write /sys/module/printk/parameters/console_suspend "1"
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
    local path event_dir

    disable_if() {
        [ -e "$1" ] || return 0
        printf "%s" "$2" > "$1" 2>/dev/null || true
    }

    # Disable all DRI debug targets
    for path in /sys/kernel/debug/dri/*/debug/enable; do
        [ -f "$path" ] && disable_if "$path" 0
    done

    # Spurious IRQ debug
    disable_if /sys/module/spurious/parameters/noirqdebug 1

    # Disable GPU/graphics debug nodes
    disable_if /sys/kernel/debug/gpu/enable 0
    disable_if /sys/kernel/debug/graphics/enable 0
    disable_if /sys/kernel/debug/gpumemdebug 0
    disable_if /sys/kernel/debug/gpu/memtrack 0
    disable_if /sys/kernel/debug/gpu/mmu 0
    disable_if /sys/kernel/debug/hwcomposer/disable_debug 1
    disable_if /sys/kernel/debug/hwcomposer/enable 0
    disable_if /sys/kernel/debug/sde 0
    disable_if /sys/kernel/debug/sde/stats 0
    disable_if /sys/kernel/debug/sde_rotator0/evtlog/enable 0
    disable_if /sys/kernel/debug/sde_rotator1/evtlog/enable 0
    disable_if /sys/kernel/debug/sync/fence_timeline 0

    # Disable Qualcomm / Adreno GPU module debug knobs
    disable_if /sys/module/kgsl/parameters/debug_mask 0
    disable_if /sys/module/kgsl/parameters/debug_level 0
    disable_if /sys/module/kgsl/parameters/gpu_debug 0
    disable_if /sys/module/adreno/parameters/debug 0
    disable_if /sys/module/adreno/parameters/ctx_debug 0

    # Disable tracing events for GPU and display subsystems
    for event_dir in \
        /sys/kernel/debug/tracing/events/gpu \
        /sys/kernel/debug/tracing/events/sde \
        /sys/kernel/debug/tracing/events/drm \
        /sys/kernel/debug/tracing/events/hwcomposer \
        /sys/kernel/debug/tracing/events/graphics \
        /sys/kernel/debug/tracing/events/ion; do
        [ -d "$event_dir" ] && disable_if "$event_dir/enable" 0
    done

    # Disable global tracing if available
    if [ -d /sys/kernel/debug/tracing ]; then
        disable_if /sys/kernel/debug/tracing/tracing_on 0
        disable_if /sys/kernel/debug/tracing/current_tracer nop
        disable_if /sys/kernel/debug/tracing/events/enable 0
    fi
}

tune_io_scheduler() {
    local dev
    for dev in /sys/block/*; do
        [ -d "$dev" ] || continue
        if [ -f "$dev/queue/scheduler" ]; then
            if grep -q "bfq" "$dev/queue/scheduler" 2>/dev/null; then
                echo "bfq" > "$dev/queue/scheduler" 2>/dev/null || true
            elif grep -q "mq-deadline" "$dev/queue/scheduler" 2>/dev/null; then
                echo "mq-deadline" > "$dev/queue/scheduler" 2>/dev/null || true
            elif grep -q "noop" "$dev/queue/scheduler" 2>/dev/null; then
                echo "noop" > "$dev/queue/scheduler" 2>/dev/null || true
            fi
        fi
        safe_sys_write "$dev/queue/read_ahead_kb" 1024
        safe_sys_write "$dev/queue/nr_requests" 128
        safe_sys_write "$dev/queue/add_random" 0
        safe_sys_write "$dev/queue/rotational" 0
        safe_sys_write "$dev/queue/iosched/slice_idle" 0
        safe_sys_write "$dev/queue/iosched/group_idle" 1
    done
}

tune_kernel_stability() {
    safe_sys_write /proc/sys/kernel/sched_tunable_scaling 0
    safe_sys_write /proc/sys/kernel/sched_migration_cost_ns 50000
    safe_sys_write /proc/sys/kernel/sched_autogroup_enabled 0
    safe_sys_write /proc/sys/kernel/perf_cpu_time_max_percent 3
    safe_sys_write /proc/sys/kernel/sched_min_granularity_ns 1000000
    safe_sys_write /proc/sys/kernel/sched_wakeup_granularity_ns 1500000
    safe_sys_write /proc/sys/kernel/oom_kill_allocating_task 1
    safe_sys_write /proc/sys/kernel/panic 0
    safe_sys_write /proc/sys/kernel/panic_on_oops 0
    safe_sys_write /proc/sys/kernel/panic_on_warn 0
    safe_sys_write /proc/sys/kernel/soft_lockup_panic 0
    safe_sys_write /proc/sys/kernel/hard_lockup_panic 0
}

main() {
    su -lp 2000 -c "cmd notification post -S bigtext -t 'Angela' Tag 'Ulalaaaa... I got your board!'"
}
exit 0
