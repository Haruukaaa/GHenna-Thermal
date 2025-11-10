#info

SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=true

print_modname() {
  ui_print "      Welcome to Ghenna Thermal  ʕ⁠·⁠ᴥ⁠·⁠ʔ     "
  sleep 1
  ui_print "Codename           : Tairitsu               "
  sleep 1
  ui_print "Created            : Haruka"
  sleep 1
  ui_print "Publisher          : Haruka"
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
  sleep 1
  ui_print "° RAM      :  $(free | grep Mem |  awk '{print $2}')
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
  unzip -o "$ZIPFILE" -x 'META-INF/*' -d "$MODPATH" >&2
}

set_permissions() {
  set_perm_recursive "$MODPATH" 0 0 0755 0644
}

