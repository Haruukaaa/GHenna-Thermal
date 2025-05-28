# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi

############
# Permissions
############

print_modname() {
  ui_print "      Welcome to Ghenna Thermal  ʕ⁠·⁠ᴥ⁠·⁠ʔ     "
  sleep 1
  ui_print "Codename           : Kafka               "
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

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'service.sh' -d $MODPATH >&2
  unzip -o "$ZIPFILE" 'module.prop' -d $MODPATH >&2
  sleep 2
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0777 0777
  set_perm $MODPATH/service.sh 0 0 0777
  set_perm $MODPATH/system/etc/.nth_fc/.fc_lib 0 0 0777
  set_perm $MODPATH/system/etc/.nth_fc/.fc_main.sh 0 0 0777
  
    # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# You can add more functions to assist your custom script code
REPLACE="
/system/vendor/etc/thermal-engine-map.conf
/system/vendor/etc/thermal-engine.conf
/system/vendor/etc/thermal-engine-normal.conf
/system/vendor/etc/thermal-engine-sgame.conf
/system/vendor/etc/thermal-engine-pubgmhd.conf
/system/vendor/etc/perf/commonresourceconfigs.xml
/system/vendor/etc/perf/perfboostsconfig.xml
/system/vendor/etc/perf/targetconfig.xml
/system/vendor/etc/perf/targetresourceconfigs.xml
"
