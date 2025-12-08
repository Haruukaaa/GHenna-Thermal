#!/system/bin/sh

# GHenna Kohaku
wait_until_login() {
  # In case of /data encryption is disabled
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
  sh /system/etc/.nth_fc/.fc_main.sh
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

ext() 
{
    if [ -f ${2} ]; then
        chmod 0666 ${2}
        echo ${1} > ${2}
        chmod 0444 ${2}
    fi
}

ext 5500000 /sys/class/power_supply/battery/constant_charge_current_max

su -lp 2000 -c "cmd notification post -S bigtext -t 'Empyrea' 'Tag' '$(getprop ro.product.board) Battle cost reduced, I need to be faster..'"

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
    for h in /proc/sys/kernel; do
   echo "0" > "$h/perf_event_paranoid"
   echo "off" > "$h/printk_devkmsg"
   echo "0" > "$h/sched_latency_ns"
   echo "0" > "$h/randomize_va_space"
   echo "0" > "$h/timer_migration"
   echo "0" > "$h/sysctl_writes_strict"
   echo "0 0 0 0" > "$h/printk"
   echo "-1" > "$h/sched_rt_runtime_us"
   echo "200000" > "$h/threads-max"
   echo "0" > "$h/sched_tunable_scaling"
   echo "0" > "$h/panic"
   echo "0" > "$h/panic_on_oops"
   echo "2" > "$h/sched_rr_timeslice_ms"
   echo "0" > "$h/sched_energy_aware"
   echo "1" > "$h/sched_util_clamp_min"
   echo "1" > "$h/sched_util_clamp_min_rt_default"
   echo "2" > "$h/sched_pelt_multiplier"
   echo "1000000" > "$h/sched_rt_period_us"
done
echo "0" > /sys/kernel/msm_thermal/enabled
echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
echo "N" > /sys/module/msm_thermal/parameters/enabled
echo "0" > /sys/module/msm_thermal/core_control/enabled
echo "0" > /sys/module/msm_thermal/vdd_restriction/enabled
echo "stop 1" > /proc/mtk_batoc_throttling/battery_oc_protect_stop

chmod 755 /sys/module/qti_haptics/parameters/vmax_mv_override
echo 500 > /sys/module/qti_haptics/parameters/vmax_mv_override
chmod 444 /sys/module/qti_haptics/parameters/vmax_mv_override

echo "0" > /sys/kernel/rcu_normal
echo "0" > /sys/kernel/rcu_expedited
echo "1" > /proc/sys/kernel/timer_migration
echo "0" > /sys/devices/system/cpu/isolated
echo "0" > /proc/sys/kernel/hung_task_timeout_secs

echo "1" > /dev/stune/top-app/schedtune.boost
echo "0" > /dev/stune/top-app/schedtune.prefer_idle
echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features
echo "NO_TTWU_QUEUE" > /sys/kernel/debug/sched_features

echo "0" > /sys/kernel/ccci/debug
echo "0" > /sys/kernel/debug/rpm_log
echo "0" > /proc/sys/vm/page-cluster
echo "120" > /proc/sys/vm/stat_interval
echo "0" > /proc/sys/kernel/debug_locks
echo "0" > /sys/kernel/tracing/tracing_on
echo "0" > /proc/sys/kernel/sched_schedstats
echo "0" > /proc/sys/kernel/split_lock_mitigate
echo "32" > /proc/sys/kernel/sched_nr_migrate
echo "0" > /proc/sys/kernel/perf_event_paranoid
echo "1" > /proc/sys/kernel/sched_child_runs_first
echo "0" > /proc/sys/kernel/sched_tunable_scaling
echo "0" > /proc/sys/vm/compaction_proactiveness
echo "4000000" > /proc/sys/kernel/sched_latency_ns
echo "0" > /proc/sys/kernel/sched_autogroup_enabled
echo "3" > /proc/sys/kernel/perf_cpu_time_max_percent
echo "50000" > /proc/sys/kernel/sched_migration_cost_ns
echo "0" > /sys/module/mmc_core/parameters/use_spi_crc
echo "1000000" > /proc/sys/kernel/sched_min_granularity_ns
echo "0" > /sys/module/cpufreq_bouncing/parameters/enable
echo "0" > /proc/sys/kernel/sched_min_task_util_for_colocation
echo "1500000" > /proc/sys/kernel/sched_wakeup_granularity_ns
echo "0" > /proc/task_info/task_sched_info/task_sched_info_enable
echo "0" > /proc/oplus_scheduler/sched_assist/sched_assist_enabled

echo "0 0 0 0" > /proc/sys/kernel/printk
echo "off" > /proc/sys/kernel/printk_devkmsg
echo "0" > /sys/module/printk/parameters/pid
echo "0" > /sys/module/printk/parameters/cpu
echo "0" > /sys/module/printk/parameters/time
echo "0" > /sys/kernel/printk_mode/printk_mode
echo "N" > /sys/module/sync/parameters/fsync_enabled
echo "1" > /sys/module/printk/parameters/ignore_loglevel
echo "0" > /sys/module/printk/parameters/printk_ratelimit
echo "1" > /sys/module/printk/parameters/console_suspend

echo "3" > /proc/sys/vm/drop_caches
echo "1" > /proc/sys/vm/compact_memory
echo "0" > /proc/sys/debug/exception-trace
echo "80" > /proc/sys/vm/vfs_cache_pressure
echo "0" > /sys/kernel/debug/dri/0/debug/enable
echo "1" > /sys/module/spurious/parameters/noirqdebug
echo "0" > /sys/kernel/debug/sde_rotator0/evtlog/enable


su -lp 2000 -c "cmd notification post -S bigtext -t 'Empyrea' 'Tag' '$(getprop ro.product.board)I would not forgive myself for not being there when they need me.'"
    exit 0
