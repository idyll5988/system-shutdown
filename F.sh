#!/system/bin/sh
[ ! "$MODDIR" ] && MODDIR=${0%/*}
MODPATH="/data/adb/modules/AA+™"
[[ ! -e ${MODDIR}/ll/log ]] && mkdir -p ${MODDIR}/ll/log
source "${MODPATH}/scripts/GK.sh"
cd ${MODDIR}/ll/log
function renice() {
  pgrep -f $1 | while read pid; do
  renice -n -20 -p $pid >>进程.log
  echo $pid > /dev/cpuset/top-app/cgroup.procs
  echo $pid > /dev/stune/top-app/cgroup.procs
  done
}
[ -e /dev/stune/foreground/schedtune.prefer_idle ] && write_value /dev/stune/foreground/schedtune.prefer_idle "1"
[ -e /dev/stune/background/schedtune.prefer_idle ] && write_value /dev/stune/background/schedtune.prefer_idle "1"
[ -e /dev/stune/rt/schedtune.prefer_idle ] && write_value /dev/stune/rt/schedtune.prefer_idle "1"
[ -e /dev/stune/rt/schedtune.boost ] && write_value /dev/stune/rt/schedtune.boost "20"
[ -e /dev/stune/schedtune.prefer_idle ] && write_value /dev/stune/schedtune.prefer_idle "1"
[ -e /dev/stune/top-app/schedtune.prefer_idle ] && write_value /dev/stune/top-app/schedtune.prefer_idle "1"
[ -e /dev/stune/top-app/schedtune.boost ] && write_value /dev/stune/top-app/schedtune.boost "20"  
while true; do
screen_status=$(dumpsys window | grep "mScreenOn" | grep true)
if [[ "${screen_status}" ]]; then
log
renice com.android.systemui 
renice android
renice com.sec.android.app.launcher
true
fi
done

