#!/system/bin/sh
MODDIR=${0%/*}

# Set zram configurations (safe-write)
if [ -w /sys/block/zram0/disksize ]; then
    echo 4096M >/sys/block/zram0/disksize 2>/dev/null || true
    mkswap /data/zram0 2>/dev/null || true
    swapon /data/zram0 2>/dev/null || true
    setprop ro.vendor.qti.config.zram true 2>/dev/null || true
fi

# This script will be executed in post-fs-data mode

# Helper: write to sysfs if writable
safe_sys_write() {
    [ -w "$1" ] && echo "$2" > "$1" 2>/dev/null || true
}

# Helper: resetprop quietly
safe_resetprop() {
    resetprop -n "$1" "$2" 2>/dev/null || true
}

# Consolidated properties (key value pairs)
apply_props() {
    while read -r key val; do
        [ -z "$key" ] && continue
        safe_resetprop "$key" "$val"
    done <<'EOF'
debug.sqlite.journalmode OFF
debug.sqlite.wal.syncmode OFF
persist.logd.limit OFF
persist.logd.size 65536
persist.logd.size.crash 1M
persist.logd.size.radio 1M
persist.logd.size.system 1M
persist.mm.enable.prefetch false
log.tag.stats_log OFF
ro.logd.size OFF
ro.logd.size.stats 64K
vendor.bluetooth.startbtlogger false
persist.sys.offlinelog.kernel false
persist.sys.offlinelog.logcat false
persist.sys.offlinelog.logcatkernel false
sys.miui.ndcd off
ro.kernel.android.checkjni 0
ro.kernel.checkjni 0
persist.wpa_supplicant.debug false
av.debug.disable.pers.cache true
config.disable_rtt true
config.stats 0
db.log.slow_query_threshold 0
debug.atrace.tags.enableflags false
debug.egl.profiler 0
debug.enable.wl_log false
debug.hwc.otf 0
debug.hwc_dump_en 0
debug.mdpcomp.logs 0
debug.qualcomm.sns.daemon 0
debug.qualcomm.sns.libsensor1 0
debug.sf.ddms 0
debug.sf.disable_client_composition_cache 1
debug.sf.dump 0
debug_test 0
libc.debug.malloc 0
log.shaders 0
log.tag.all 0
log_ao 0
log_frame_info 0
logd.logpersistd.enable false
logd.statistics 0
media.metrics.enabled false
media.metrics 0
media.stagefright.log-uri 0
net.ipv4.tcp_no_metrics_save 1
persist.anr.dumpthr 0
persist.data.qmi.adb_logmask 0
persist.debug.sensors.hal 0
persist.debug.wfd.enable false
persist.ims.disableADBLogs true
persist.ims.disabled true
persist.ims.disableDebugLogs true
persist.ims.disableIMSLogs true
persist.ims.disableQXDMLogs true
persist.logd.size.crash OFF
persist.logd.size.radio OFF
persist.logd.size.system OFF
persist.logd.size OFF
persist.service.logd.enable false
persist.sys.perf.debug false
persist.sys.ssr.enable_debug false
persist.sys.ssr.restart_level 1
persist.sys.strictmode.disable true
persist.traced.enable false
persist.traced_perf.enable false
persist.vendor.crash.detect false
persist.vendor.radio.adb_log_on 0
persist.vendor.radio.snapshot_enabled false
persist.vendor.radio.snapshot_timer 0
persist.vendor.sys.modem.logging.enable false
persist.vendor.sys.reduce_qdss_log 1
persist.vendor.verbose_logging_enabled false
ro.config.ksm.support false
ro.debuggable 0
ro.logd.kernel false
ro.logd.size.stats OFF
ro.logd.size OFF
ro.logdumpd.enabled false
ro.statsd.enable false
ro.telephony.call_ring.multiple false
ro.vendor.connsys.dedicated.log 0
rw.logger 0
sys.miui.ndcd 0
sys.wifitracing.started 0
vendor.vidc.debug.level 0
vidc.debug.level 0
persist.sys.dalvik.hyperthreading true
persist.sys.dalvik.multithread true
EOF
}

apply_props

####################################
# Optimizing Texture for Performance
####################################
# Apply a runtime HWUI profile once SurfaceFlinger is up so texture
# rendering gets larger caches while the compositor is running.
apply_hwui_performance() {
    safe_resetprop ro.hwui.texture_cache_size 128
    safe_resetprop ro.hwui.layer_cache_size 96
    safe_resetprop ro.hwui.r_buffer_cache_size 16
    safe_resetprop ro.hwui.path_cache_size 64
    safe_resetprop ro.hwui.gradient_cache_size 2
    safe_resetprop ro.hwui.drop_shadow_cache_size 12
    safe_resetprop ro.hwui.texture_cache_flushrate 0.2
    safe_resetprop ro.hwui.text_small_cache_width 2048
    safe_resetprop ro.hwui.text_small_cache_height 2048
    safe_resetprop ro.hwui.text_large_cache_width 4096
    safe_resetprop ro.hwui.text_large_cache_height 4096
    echo "HWUI performance profile applied" >/dev/kmsg 2>/dev/null || true
}

# Wait for SurfaceFlinger, then apply the performance profile (non-blocking).
(
    for i in 1 2 3 4 5 6 7 8 9 10; do
        sf=$(service list | grep -c "SurfaceFlinger:")
        if [ "$sf" -ge 1 ]; then
            apply_hwui_performance
            break
        fi
        sleep 2
    done
) &

####################################
# LMK
####################################
# If the new LMKD daemon is present, prefer it and skip legacy LMK props.
# Otherwise apply the legacy `ro.lmk.*` tuning values.
if pidof lmkd >/dev/null 2>&1; then
    echo "LMKD detected; skipping legacy ro.lmk.* properties" >/dev/kmsg 2>/dev/null || true
else
    safe_resetprop ro.lmk.debug false
    safe_resetprop ro.lmk.upgrade_pressure 40
    safe_resetprop ro.lmk.downgrade_pressure 60
    safe_resetprop ro.lmk.kill_heaviest_task false
    safe_resetprop ro.lmk.psi_complete_stall_ms 500
    safe_resetprop ro.lmk.psi_partial_stall_ms 70
    safe_resetprop ro.lmk.thrashing_limit 100
    safe_resetprop ro.lmk.thrashing_limit_decay 10
    safe_resetprop ro.lmk.swap_util_max 100
fi
done

