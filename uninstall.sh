# Don't modify anything after this
# Uninstall script: removes service and daemon scripts
#
[[ -f "$INFO" ]] && {
  while read LINE; do
    if [[ "$(echo -n "$LINE" | tail -c 1)" == "~" ]]; then
      continue
    elif [[ -f "$LINE~" ]]; then
      mv -f "$LINE~" "$LINE"
    else
      rm -f "$LINE"
      while true; do
        LINE=$(dirname $LINE)
        [[ "$(ls -A $LINE 2>/dev/null)" ]] && break 1 || rm -rf "$LINE"
      done
    fi
    TARGETS="/system/etc/init.d /data/adb/service.d /data/adb/ksu/service.d /data/adb/ap/service.d"
for target in $TARGETS; do
    if [ -d "$target" ]; then
        rm -f "$target/99service"
        rm -f "$target/99daemon"
        echo "Removed service.sh and daemon.sh from $target"
  done < $INFO
  rm -f "$INFO"
}
