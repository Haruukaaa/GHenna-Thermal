#!/system/bin/sh
wait_until_login() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
  sh /data/adb/modules/gehenna-thermal/system/etc/.nth_fc/.fc_main.sh
    sleep 3
  done
  test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true >"$test_file"
  while [[ ! -f "$test_file" ]]; do
    true >"$test_file"
    sleep 1
  done
  rm -f "$test_file"
}

wait_until_login

# Sleep some time to make sure init is completed
sleep 40

su -lp 2000 -c "cmd notification post -S bigtext -t 'Kakfa 🎻❌' 'Tag' '$(getprop ro.soc.model) said that I'm good at exploring performance, even though Im not fully understand what it means.'"

for svc in logd traced statsd; do
    if getprop init.svc.$svc | grep -q "running"; then
        su -c "stop $svc"
    fi
done
for component in LLCC L3 DDR DDRQOS; do
    base_path="/sys/devices/system/cpu/bus_dcvs/$component"
    [ ! -d "$base_path" ] && continue
    freq_file="$base_path/available_frequencies"
    [ ! -f "$freq_file" ] && continue

    freq=$(cat "$freq_file" | tr ' ' '\n' | sort -nr | head -n 1)
    [ -z "$freq" ] && continue

    for path in "$base_path"/*/max_freq "$base_path"/*/min_freq; do
        [ -e "$path" ] && chmod 644 "$path" && echo "$freq" > "$path" && chmod 444 "$path"
    done
done

cmd settings put global activity_starts_logging_enabled 0
cmd settings put global ble_scan_always_enabled 0
cmd settings put global hotword_detection_enabled 0
cmd settings put global mobile_data_always_on 0
cmd settings put global network_recommendations_enabled 0
cmd settings put global wifi_scan_always_enabled 0
cmd settings put secure adaptive_sleep 0
cmd settings put secure screensaver_activate_on_dock 0  
cmd settings put secure screensaver_activate_on_sleep 0
cmd settings put secure screensaver_enabled 0
cmd settings put secure send_action_app_error 0
cmd settings put system air_motion_engine 0
cmd settings put system air_motion_wake_up 0
cmd settings put system intelligent_sleep_mode 0
cmd settings put system master_motion 0
cmd settings put system motion_engine 0
cmd settings put system nearby_scanning_enabled 0
cmd settings put system nearby_scanning_permission_allowed 0
cmd settings put system rakuten_denwa 0
cmd settings put system send_security_reports 0
su -c "pm disable com.google.android.gms/.chimera.GmsIntentOperationService"
su -c "pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

for thermal in $(resetprop | awk -F '[][]' '/thermal/ {print $2}'); do
  if [[ $(resetprop "$thermal") == running ]] || [[ $(resetprop "$thermal") == stopped ]]; then
    stop "${thermal/init.svc.}"
    sleep 10
    resetprop -n "$thermal" stopped
  fi
   eval "$(seq 32 |
   sed 's/^/service call sensor_privacy /g' |sed 's/
   $/ 132 1/g)"
done
sleep 1
find /sys/ -type f -name "*throttling*" | while IFS= read -r throttling; do
    [ -w "$throttling" ] && echo 0 > "$throttling" 2>/dev/null
done
getprop | awk -F '[][]' '/ro.*thermal/ {print $2}' | while read -r prop; do
    resetprop -n "$prop" 0
done
  if resetprop dalvik.vm.dexopt.thermal-cutoff | grep -q '2'; then
    resetprop -n dalvik.vm.dexopt.thermal-cutoff 0
  fi
  if resetprop sys.thermal.enable | grep -q 'true'; then
    resetprop -n sys.thermal.enable false
  fi
  if resetprop ro.thermal_warmreset | grep -q 'true'; then
    resetprop -n ro.thermal_warmreset false
  fi
sleep 1    
echo 0 > /sys/class/thermal/thermal_zone*/mode
sleep 1
  if resetprop dalvik.vm.dexopt.thermal-cutoff | grep -q '2'; then
    resetprop -n dalvik.vm.dexopt.thermal-cutoff 0
  fi
  if resetprop sys.thermal.enable | grep -q 'true'; then
    resetprop -n sys.thermal.enable false
  fi
  if resetprop ro.thermal_warmreset | grep -q 'true'; then
    resetprop -n ro.thermal_warmreset false
  fi
sleep 1
  rm -f /data/vendor/thermal/config
  rm -f /data/vendor/thermal/thermal.dump
  rm -f /data/vendor/thermal/last_thermal.dump
  rm -f /data/vendor/thermal/thermal_history.dump
    for therm_serv in $thermal_prop; do
        stop $therm_serv
    done
ext() {
    if [ -f "\$2" ]; then
        chmod 0666 "\$2"
        echo "\$1" > "\$2"
        chmod 0444 "\$2"
    fi
}
if [ -e /sys/class/kgsl/kgsl-3d0/devfreq/governor ]; then
  echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
fi
done
sleep 10
echo 0 > /sys/class/kgsl/kgsl-3d0/throttling
echo 0 > /sys/class/kgsl/kgsl-3d0/bus_split
echo 1 > /sys/class/kgsl/kgsl-3d0/force_no_nap
echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_bus_on
echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on
#write /proc/sys/kernel/sched_lib_name "com.miHoYo., com.activision., UnityMain, libunity.so, libil2cpp.so"
echo "com.miHoYo., com.activision., UnityMain, libunity.so, libil2cpp.so, libfb.so" > /proc/sys/kernel/sched_lib_name
#write /proc/sys/kernel/sched_lib_mask_force 255
echo "240" > /proc/sys/kernel/sched_lib_mask_force

rm -f /storage/emulated/0/*.log;
settings delete global device_idle_constants
settings delete global device_idle_constants_user
dumpsys deviceidle enable light
dumpsys deviceidle enable deep
settings put global device_idle_constants
sleep 5

rm -rf /data/media/0/MIUI/Gallery
rm -rf /data/media/0/MIUI/.debug_log
rm -rf /data/media/0/MIUI/BugReportCache
rm -rf /data/media/0/mtklog
rm -rf /data/anr/*
rm -rf /dev/log/*
rm -rf /data/tombstones/*
rm -rf /data/log_other_mode/*
rm -rf /data/system/dropbox/*
rm -rf /data/system/usagestats/*
rm -rf /data/log/*
rm -rf /sys/kernel/debug/*

rm -rf /data/vendor/wlan_logs
touch /data/vendor/wlan_logs
chmod 000 /data/vendor/wlan_logs

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
for touch in \
    /sys/module/msm_performance/parameters/touchboost \
    /sys/power/pnpmgr/touch_boost \
    /proc/perfmgr/tchbst/kernel/tb_enable \
    /sys/devices/virtual/touch/touch_boost \
    /sys/module/msm_perfmon/parameters/touch_boost_enable \
    /sys/devices/platform/goodix_ts.0/switch_report_rate; do
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
sleep 5
fstrim /cache
fstrim /system
fstrim /data

su -lp 2000 -c "cmd notification post -S bigtext -t 'Kakfa 🎻✅' 'Tag' 'Oh, bye-bye, $(getprop ro.soc.model). See if you can surprise me next time.'"
    exit 0
    
    
