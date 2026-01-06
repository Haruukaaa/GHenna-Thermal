#!/system/bin/sh
MODDIR ${0%/*}
# Set zram configurations
echo 4096M >/sys/block/zram0/disksize
mkswap /data/zram0
swapon  /data/zram0
setprop ro.vendor.qti.config.zram true
# This script will be executed in post-fs-data mode
    # disable I/O debugging
echo "0" > /sys/block/sda/queue/iostats
echo "0" > /sys/block/loop1/queue/iostats
echo "0" > /sys/block/loop2/queue/iostats
echo "0" > /sys/block/loop3/queue/iostats
echo "0" > /sys/block/loop4/queue/iostats
echo "0" > /sys/block/loop5/queue/iostats
echo "0" > /sys/block/loop6/queue/iostats
echo "0" > /sys/block/loop7/queue/iostats
echo "0" > /sys/block/dm-0/queue/iostats
echo "0" > /sys/block/loop0/queue/iostats
echo "0" > /sys/block/mmcblk1/queue/iostats
echo "0" > /sys/block/mmcblk0/queue/iostats
echo "0" > /sys/block/mmcblk0rpmb/queue/iostats

#sqlitelog
resetprop -n debug.sqlite.journalmode OFF
#wal sync
resetprop -n debug.sqlite.wal.syncmode OFF
#Close Logd (according to the developer mode)
resetprop -n persist.logd.limit OFF
resetprop -n persist.logd.size 65536
resetprop -n persist.logd.size.crash 1M
resetprop -n persist.logd.size.radio 1M
resetprop -n persist.logd.size.system 1M
resetprop -n persist.mm.enable.prefetch false
resetprop -n log.tag.stats_log OFF
resetprop -n ro.logd.size OFF
resetprop -n ro.logd.size.stats 64K
#Bluetooth log (according to the developer mode)
resetprop -n vendor.bluetooth.startbtlogger false
#Kernel log (metaphysics)
resetprop -n persist.sys.offlinelog.kernel false
#Close the logcat service (mysterious and mysterious)
resetprop -n persist.sys.offlinelog.logcat false
resetprop -n persist.sys.offlinelog.logcatkernel false
#MIUI kernel log (from Suilong)
resetprop -n sys.miui.ndcd off
#Turn off forcing software GLES rendering
#resetprop -n persist.sys.force_sw_gles 0
#Disable error detection
resetprop -n ro.kernel.android.checkjni 0
resetprop -n ro.kernel.checkjni 0
#wpa debug disabled
resetprop -n persist.wpa_supplicant.debug false
#Optimize system sleep (metaphysics)
#resetprop -n pm.sleep_mode 1
#resetprop -n ro.ril.disable.power.collapse 0

####################################
# Disable Unnecessary Things (by @nonosvaimos)
####################################
resetprop -n av.debug.disable.pers.cache true
resetprop -n config.disable_rtt true
resetprop -n config.stats 0
resetprop -n db.log.slow_query_threshold 0
resetprop -n debug.atrace.tags.enableflags false
resetprop -n debug.egl.profiler 0
resetprop -n debug.enable.wl_log false
resetprop -n debug.hwc.otf 0
resetprop -n debug.hwc_dump_en 0
resetprop -n debug.mdpcomp.logs 0
resetprop -n debug.qualcomm.sns.daemon 0
resetprop -n debug.qualcomm.sns.libsensor1 0
resetprop -n debug.sf.ddms 0
resetprop -n debug.sf.disable_client_composition_cache 1
resetprop -n debug.sf.dump 0
resetprop -n debug.sqlite.journalmode OFF
resetprop -n debug.sqlite.wal.syncmode OFF
resetprop -n debug_test 0
resetprop -n libc.debug.malloc 0
resetprop -n log.shaders 0
resetprop -n log.tag.all 0
resetprop -n log.tag.stats_log OFF
resetprop -n log_ao 0
resetprop -n log_frame_info 0
resetprop -n logd.logpersistd.enable false
resetprop -n logd.statistics 0
resetprop -n media.metrics.enabled false
resetprop -n media.metrics 0
resetprop -n media.stagefright.log-uri 0
resetprop -n net.ipv4.tcp_no_metrics_save 1
resetprop -n persist.anr.dumpthr 0
resetprop -n persist.data.qmi.adb_logmask 0
resetprop -n persist.debug.sensors.hal 0 
resetprop -n persist.debug.wfd.enable false
resetprop -n persist.ims.disableADBLogs true
resetprop -n persist.ims.disabled true
resetprop -n persist.ims.disableDebugLogs true
resetprop -n persist.ims.disableIMSLogs true
resetprop -n persist.ims.disableQXDMLogs true
resetprop -n persist.logd.limit OFF
resetprop -n persist.logd.size.crash OFF
resetprop -n persist.logd.size.radio OFF
resetprop -n persist.logd.size.system OFF
resetprop -n persist.logd.size OFF
resetprop -n persist.service.logd.enable false
resetprop -n persist.sys.perf.debug false
resetprop -n persist.sys.ssr.enable_debug false
resetprop -n persist.sys.ssr.restart_level 1
resetprop -n persist.sys.strictmode.disable true
resetprop -n persist.traced.enable false
resetprop -n persist.traced_perf.enable false
resetprop -n persist.vendor.crash.detect false
resetprop -n persist.vendor.radio.adb_log_on 0
resetprop -n persist.vendor.radio.snapshot_enabled false
resetprop -n persist.vendor.radio.snapshot_timer 0
resetprop -n persist.vendor.sys.modem.logging.enable false
resetprop -n persist.vendor.sys.reduce_qdss_log 1
resetprop -n persist.vendor.verbose_logging_enabled false
resetprop -n persist.wpa_supplicant.debug false
resetprop -n ro.config.ksm.support false
resetprop -n ro.debuggable 0
resetprop -n ro.kernel.android.checkjni 0
resetprop -n ro.logd.kernel false
resetprop -n ro.logd.size.stats OFF
resetprop -n ro.logd.size OFF
resetprop -n ro.logdumpd.enabled false
resetprop -n ro.statsd.enable false
resetprop -n ro.telephony.call_ring.multiple false
resetprop -n ro.vendor.connsys.dedicated.log 0
resetprop -n rw.logger 0
resetprop -n sys.miui.ndcd 0
resetprop -n sys.wifitracing.started 0
resetprop -n vendor.vidc.debug.level 0
resetprop -n vidc.debug.level 0
####################################
# DalvikHyperthreading (by @modulostk)
####################################
resetprop -n persist.sys.dalvik.hyperthreading true
resetprop -n persist.sys.dalvik.multithread true
####################################
# Optimizing Texture for Performance
####################################
# Apply a runtime HWUI profile once SurfaceFlinger is up so texture
# rendering gets larger caches while the compositor is running.
apply_hwui_performance() {
    resetprop -n ro.hwui.texture_cache_size 128
    resetprop -n ro.hwui.layer_cache_size 96
    resetprop -n ro.hwui.r_buffer_cache_size 16
    resetprop -n ro.hwui.path_cache_size 64
    resetprop -n ro.hwui.gradient_cache_size 2
    resetprop -n ro.hwui.drop_shadow_cache_size 12
    resetprop -n ro.hwui.texture_cache_flushrate 0.2
    resetprop -n ro.hwui.text_small_cache_width 2048
    resetprop -n ro.hwui.text_small_cache_height 2048
    resetprop -n ro.hwui.text_large_cache_width 4096
    resetprop -n ro.hwui.text_large_cache_height 4096
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
    resetprop -n ro.lmk.debug false
    resetprop -n ro.lmk.upgrade_pressure 40
    resetprop -n ro.lmk.downgrade_pressure 60
    resetprop -n ro.lmk.kill_heaviest_task false
    resetprop -n ro.lmk.psi_complete_stall_ms=500
    resetprop -n ro.lmk.psi_partial_stall_ms=70
    resetprop -n ro.lmk.thrashing_limit=100
    resetprop -n ro.lmk.thrashing_limit_decay=10
    resetprop -n ro.lmk.swap_util_max=100
fi
done
