#!/system/bin/sh

# GHenna Lilith
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done

  # We don't have the permission to rw "/storage/emulated/0" before the user unlocks the screen
  test_file="/storage/emulated/0/Android/.PERMISSION_TEST"
  true >"$test_file"
  while [[ ! -f "$test_file" ]]; do
    true >"$test_file"
    sleep 1
  done
  rm -f "$test_file"
}

wait_until_login

su -lp 2000 -c "cmd notification post -S bigtext -t 'Lilith' 'Tag' '$(getprop ro.product.board) Darling, shall we go date right now?.'"

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
cmd accessibility stop-trace
cmd migard dump-trace false
cmd migard start-trace false
cmd migard stop-trace true
cmd migard trace-buffer-size 0
cmd input_method tracing stop
cmd window tracing size 0
cmd window tracing stop
cmd statusbar tracing stop
logcat -G 64K
logcat -b main -G 128K
logcat -c

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

echo "0 0 0 0" > "/proc/sys/kernel/printk"
echo "0" > "/sys/kernel/printk_mode/printk_mode"
echo "0" > "/sys/module/printk/parameters/cpu"
echo "0" > "/sys/module/printk/parameters/pid"
echo "0" > "/sys/module/printk/parameters/printk_ratelimit"
echo "0" > "/sys/module/printk/parameters/time"
echo "1" > "/sys/module/printk/parameters/console_suspend"
echo "1" > "/sys/module/printk/parameters/ignore_loglevel"
echo "off" > "/proc/sys/kernel/printk_devkmsg"
echo "0" > /proc/sys/kernel/hung_task_timeout_secs
echo "0" > /proc/sys/kernel/softlockup_panic
echo "55" /proc/sys/kernel/perf_cpu_time_max_percent
echo "24000" /proc/sys/kernel/perf_event_max_sample_rate
echo "570" /proc/sys/kernel/perf_event_mlock_kb
echo "0" /proc/sys/kernel/sched_boost
echo "95" /proc/sys/kernel/sched_downmigrate
echo "160" /proc/sys/kernel/sched_group_upmigrate

su -lp 2000 -c "cmd notification post -S bigtext -t 'Lilith' 'Tag' '$(getprop ro.product.board) Darling, i bored, give me a hug.'"
    exit 0
