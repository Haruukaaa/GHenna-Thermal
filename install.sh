#!/system/bin/sh
#
# Install script: sets up service and daemon for multiple root managers
#

# Paths to possible service directories
INITD_PATH="/system/etc/init.d"
MAGISK_PATH="/data/adb/service.d"
KSU_PATH="/data/adb/ksu/service.d"
APATCH_PATH="/data/adb/ap/service.d"

# Source scripts (adjust to your actual paths)
SERVICE_SRC="/path/to/service.sh"
DAEMON_SRC="/path/to/daemon.sh"

# Try each supported root manager directory
install_to_dir "$INITD_PATH"
install_to_dir "$MAGISK_PATH"
install_to_dir "$KSU_PATH"
install_to_dir "$APATCH_PATH"


print_modname() {
  ui_print "      Welcome to Ghenna Tweaks  ʕ⁠·⁠ᴥ⁠·⁠ʔ     "
  sleep 1
  ui_print "Codename           : Ye Shunguang               "
  sleep 1
  ui_print "Created            : Hirauki"
  sleep 1
  ui_print "Publisher          : Hirauki"
  sleep 1
  ui_print "Update             : https://t.me/hgane_rei"
  sleep 1
  ui_print "               "
  sleep 1
  ui_print "Checking your device"
  sleep 2
  ui_print "° DATE     : $(date +"%Y-%m-%d") "
  sleep 1
  ui_print "° DEVICE   : $(getprop ro.product.model) "
  sleep 1
  ui_print "° Android  : $(getprop ro.build.version.release) "
  sleep 1
  ui_print "° BRAND    : $(getprop ro.product.model) "
  sleep 1
  ui_print "° CODE     : $(getprop ro.product.board) "
  sleep 1
  ui_print "° MODEL    : $(getprop ro.soc.model) "
  sleep 1
  ui_print "° KERNEL   : $(uname -r) "
  sleep 2
  ui_print "PREPARE TO INSTALL"
  sleep 1
    ui_print " [■□□□□□□□□□] 10%  "
    sleep 1
    ui_print " [■■□□□□□□□□] 20%  "
    sleep 1
    ui_print " [■■■□□□□□□□] 30%  "
    sleep 1
    ui_print " [■■■■□□□□□□] 40%  "
    sleep 1
    ui_print " [■■■■■□□□□□] 50%  "
    sleep 1
    ui_print " [■■■■■■□□□□] 60%  "
    sleep 1
    ui_print " [■■■■■■■□□□] 70%  "
    sleep 1
    ui_print " [■■■■■■■■□□] 80%  "
    sleep 1
    ui_print " [■■■■■■■■■□] 90%  "
    sleep 2
    ui_print " [■■■■■■■■■■] 100% "
  sleep 1
  ui_print "                    D O N E     !!!!                    "
  sleep 1
  ui_print "               "
  busybox sleep 1
  ui_print "                  R E B O O T                         "
}

on_install() {
  ui_print "- Clearing package cache"
  [[ -e "/data/system/package_cache" ]] && rm -rf /data/system/package_cache/*
  
  ui_print "- Installing module files"
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" 'system/*' -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" 'service.sh' -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" 'module.prop' -d "$MODPATH" >&2
  unzip -o "$ZIPFILE" 'daemon.sh' -d "$MODPATH" >&2
  
  # Function to install into a target directory
    local target=$1
    if [ -d "$target" ]; then
        cp "$SERVICE_SRC" "$target/99service"
        cp "$DAEMON_SRC" "$target/100daemon"
        chmod 755 "$target/99service" "$target/100daemon"
        echo "Installed service.sh and daemon.sh into $target"
    fi
  sleep 2
  ui_print "- Installation completed successfully"
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0777 0755
  set_perm $MODPATH/service.sh 0 0 0777 0777
  set_perm $MODPATH/daemon.sh 0 0 0777 0777
    # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

