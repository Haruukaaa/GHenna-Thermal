
#!/system/bin/sh
MODDIR=${0%/*}
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 1
  done
 test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true >"$test_file"
  while [[ ! -f "$test_file" ]]; do
    true >"$test_file"
    sleep 1
  done
  rm -f "$test_file"
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
    
    
