#!/system/bin/sh
set -e
MODDIR=${0%/*}

####################################
# Helpers
####################################
safe_sys_write() {
    if [ -w "$1" ]; then
        echo "$2" > "$1" 2>/dev/null || true
        echo "[+] Wrote $2 to $1" >/dev/kmsg 2>/dev/null || true
    fi
}

safe_resetprop() {
    resetprop -n "$1" "$2" 2>/dev/null || true
    echo "[+] Prop $1 set to $2" >/dev/kmsg 2>/dev/null || true
}

####################################
# ZRAM Configuration
####################################
setup_zram() {
    if [ -w /sys/block/zram0/disksize ]; then
        echo 4096M >/sys/block/zram0/disksize || true
        if ! swapon --show | grep -q "zram0"; then
            mkswap /dev/block/zram0 || true
            swapon /dev/block/zram0 || true
        fi
        setprop ro.vendor.qti.config.zram true || true
        echo "[+] ZRAM configured" >/dev/kmsg 2>/dev/null || true
    fi
}

####################################
# Apply System Properties
####################################
apply_props() {
    # Logging & Debug
    safe_resetprop persist.logd.size 65536
    safe_resetprop persist.logd.size.crash 1M
    safe_resetprop persist.logd.size.radio 1M
    safe_resetprop persist.logd.size.system 1M
    safe_resetprop logd.logpersistd.enable false
    safe_resetprop ro.logd.size OFF
    safe_resetprop ro.logd.kernel false
    safe_resetprop ro.statsd.enable false

    # Media & Metrics
    safe_resetprop media.metrics.enabled false
    safe_resetprop media.stagefright.log-uri 0

    # Networking
    safe_resetprop net.ipv4.tcp_no_metrics_save 1

    # Dalvik optimizations
    safe_resetprop persist.sys.dalvik.hyperthreading true
    safe_resetprop persist.sys.dalvik.multithread true

    echo "[+] System properties applied" >/dev/kmsg 2>/dev/null || true
}

####################################
# HWUI Performance Profile
####################################
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
    echo "[+] HWUI performance profile applied" >/dev/kmsg 2>/dev/null || true
}

wait_for_surfaceflinger() {
    (
        for i in $(seq 1 10); do
            if service list | grep -q "SurfaceFlinger:"; then
                apply_hwui_performance
                break
            fi
            sleep 2
        done
    ) &
}

