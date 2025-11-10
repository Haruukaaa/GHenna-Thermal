#!/system/bin/sh
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 5
  done
}

wait_until_boot_complete

su -lp 2000 -c "cmd notification post -S bigtext -t 'Tairitsu 🎻✅' 'Tag' 'My job has done, $(getprop ro.soc.model). Now, let your new owner handle this.'"

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
    done
su -c "pm disable com.google.android.gms/.chimera.GmsIntentOperationService"
su -c "pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver"

disable_thermal_properties() {
    for thermal in $(resetprop | awk -F '[][]' '/thermal/ {print $2}'); do
        if [[ $(resetprop "$thermal") == running ]] || [[ $(resetprop "$thermal") == restarting ]]; then
            stop "${thermal/init.svc.}"
            sleep 10
            resetprop -n "$thermal" stopped
        fi
    done
}
sleep 1
disable_thermal_services() {
    for rc in $(find /system/etc/init /vendor/etc/init /odm/etc/init -type f); do
        grep -r "^service" "$rc" | awk '/thermal/ {print $2}'
    done | while read -r svc; do
        echo "Stopping $svc"
        start "$svc"
        stop "$svc"
    done
}
freeze_thermal_processes() {
    for pid in $(pgrep thermal); do
        echo "Freeze $pid"
        kill -SIGSTOP "$pid"
    done
}
sleep 1
reset_thermal_properties() {
    resetprop -n dalvik.vm.dexopt.thermal-cutoff 0
    resetprop -n sys.thermal.enable false
    resetprop -n ro.thermal_warmreset false
    resetprop -n vendor.thermal.bt_completed 0
}
    for therm_serv in $thermal_prop; do
    disable_cpu_freq_limits() {
    for limit in /sys/power/cpufreq_min_limit /sys/power/cpufreq_max_limit; do
        [ -e "$limit" ] && chmod 000 "$limit"
    done
sleep 1
   done
if [ -e /sys/class/kgsl/kgsl-3d0/devfreq/governor ]; then
  echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
  echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
echo 0 > /sys/module/msm_performance/parameters/touchboost
fi
done
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
    change_task_affinity ".hardware.biometrics.fingerprint" "ff"
    change_task_affinity ".hardware.camera.provider" "ff"    
    fi
done

for queue in /sys/block/*/queue; do
    echo "0" > "$queue/iostats"
done
chmod 755 /sys/module/qti_haptics/parameters/vmax_mv_override
echo 500 > /sys/module/qti_haptics/parameters/vmax_mv_override
chmod 444 /sys/module/qti_haptics/parameters/vmax_mv_override
change_task_cgroup "system_server" "top-app" "cpuset"
change_task_cgroup "system_server" "foreground" "stune"
change_task_nice "kswapd" "-2"
change_task_nice "oom_reaper" "-2"
change_task_affinity "kswapd" "7f"
change_task_affinity "oom_reaper" "7f"


echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/panic_on_rcu_stall
echo "0" > /proc/sys/kernel/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic
echo "0" > /sys/module/kernel/parameters/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic_on_oops
echo "0" > /sys/vm/panic_on_oom

sleep 5
fstrim /cache
fstrim /system
fstrim /data
    sleep 2
  else
  fi
done
    exit 0
    
    
