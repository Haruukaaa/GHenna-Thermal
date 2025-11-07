#!/system/bin/sh
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 5
  done
}

wait_until_boot_complete

SC=/sys/class
SM=/sys/module

# ➜ PERMISSIONS
chmod 777 $SC/power_supply/*/*
chmod 777 $SM/qpnp_smbcharger/*/*
chmod 777 $SM/dwc3_msm/*/*
chmod 777 $SM/phy_msm_usb/*/*

echo '1' > $SC/fast_charge/force_fast_charge
echo '1' > $SC/power_supply/battery/system_temp_level
echo '1' > /sys/kernel/fast_charge/failsafe
echo '1' > $SC/power_supply/battery/allow_hvdcp3
echo '1' > $SC/power_supply/usb/pd_allowed
echo '1' > $SC/power_supply/battery/subsystem/usb/pd_allowed
echo '0' > $SC/power_supply/battery/input_current_limited
echo '1' > $SC/power_supply/battery/input_current_settled
echo '0' > $SC/qcom-battery/restricted_charging
echo '350' > $SC/power_supply/bms/temp_cool
echo '600' > $SC/power_supply/bms/temp_hot
echo '500' > $SC/power_supply/bms/temp_warm
echo '5500000' > $SC/power_supply/usb/current_max
echo '5500000' > $SC/power_supply/usb/hw_current_max
echo '5500000' > $SC/power_supply/usb/pd_current_max
echo '5500000' > $SC/power_supply/usb/ctm_current_max
echo '5500000' > $SC/power_supply/usb/sdp_current_max
echo '5500000' > $SC/power_supply/main/current_max
echo '5500000' > $SC/power_supply/main/constant_charge_current_max
echo '5500000' > $SC/power_supply/battery/current_max
echo '5500000' > $SC/power_supply/battery/constant_charge_current_max
echo '5500000' > $SC/qcom-battery/restricted_current
echo '5500000' > $SC/power_supply/pc_port/current_max
echo '5500000' > $SC/power_supply/constant_charge_current__max

su -lp 2000 -c "cmd notification post -S bigtext -t 'Tairitsu 🎻❌' 'Tag' '$(getprop ro.soc.model) is my Assistant, let me help to boost your device with song.'"

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
echo 115000 > /sys/class/thermal/thermal_zone32/trip_point_0_temp
echo 115000 > /sys/class/thermal/thermal_zone33/trip_point_0_temp
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
            system("find /sys -name mode | grep 'thermal_zone' | while IFS= read -r thermal_zone_status; do if [ \"$(cat \"$thermal_zone_status\")\" = 'enabled' ]; then echo 'disabled' > \"$thermal_zone_status\"; fi; done");
        sleep(1);
        system("find /sys -name enabled | grep 'msm_thermal' | while IFS= read -r msm_thermal_status; do if [ \"$(cat \"$msm_thermal_status\")\" = 'Y' ]; then echo 'N' > \"$msm_thermal_status\"; fi; if [ \"$(cat \"$msm_thermal_status\")\" = '1' ]; then echo '0' > \"$msm_thermal_status\"; fi; done");
        system("stop logd");
        sleep(1);
        system("for thermal in $(resetprop | awk -F '[][]' '/thermal/ {print $2}'); do if [ \"$(resetprop \"$thermal\")\" = 'running' ] || [ \"$(resetprop \"$thermal\")\" = 'restarting' ]; then sleep 1; stop \"$(echo \"$thermal\" | sed 's/init.svc.//')\"; fi; sleep 3; if [ \"$(resetprop \"$thermal\")\" = 'running' ] || [ \"$(resetprop \"$thermal\")\" = 'restarting' ]; then resetprop -n \"$thermal\" stopped; fi; done");
        sleep(1);
        if (system("resetprop sys.thermal.enable | grep -q 'true'") == 0)
        {
            system("resetprop -n sys.thermal.enable false");
        }
        sleep(1);
        system("find /sys -name temp | grep 'thermal_zone' | while IFS= read -r thermal_zone_temp; do if [ -r \"$thermal_zone_temp\" ]; then chmod a-r \"$thermal_zone_temp\"; fi; done");
    done    

}
if [ -e /sys/class/kgsl/kgsl-3d0/devfreq/governor ]; then
  echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
  echo 0 > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
echo 0 > /sys/module/msm_performance/parameters/touchboost
fi
done
sleep 10

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

while [ -z "$(resetprop sys.boot_completed)" ]; do
  sleep 5
done
while true; do
  sleep 2
  thermal_active=$(resetprop | grep thermal | grep -e running -e restarting)
  if [ "$thermal_active" ]; then
    sleep 2
  else
    break
  fi
done

su -lp 2000 -c "cmd notification post -S bigtext -t 'Tairitsu 🎻✅' 'Tag' 'My job has done, $(getprop ro.soc.model). Now, let your new owner handle this.'"
    exit 0
    
    
