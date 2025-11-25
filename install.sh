#info

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

print_modname() {
  ui_print "      Welcome to Ghenna Tweaks  ʕ⁠·⁠ᴥ⁠·⁠ʔ     "
  sleep 1
  ui_print "Codename           : Tairitsu               "
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
  sleep2
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
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
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
  set_perm $MODPATH/system/bin/P0 0 0 0755 0755
  set_perm $MODPATH/system/bin/P1 0 0 0755 0755
  
    # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

