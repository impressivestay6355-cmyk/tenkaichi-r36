#!/bin/bash

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source "$controlfolder/control.txt"
[ -f "${controlfolder}/mod_${CFW_NAME}.txt" ] && source "${controlfolder}/mod_${CFW_NAME}.txt"
get_controls

SCRIPT_DIR=$(cd -- "$(dirname -- "$(readlink -f -- "$0" 2>/dev/null || echo "$0")")" 2>/dev/null && pwd -P)
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/dbzbt3/bt3.aarch64" ]; then
  GAMEDIR="$SCRIPT_DIR/dbzbt3"
else
  GAMEDIR="/$directory/ports/dbzbt3"
fi
cd "$GAMEDIR" || exit 1

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
echo "[dbzbt3] gamedir=$GAMEDIR cfw=${CFW_NAME:-?} device=${DEVICE_NAME:-?}"

msg() { if command -v pm_message > /dev/null 2>&1; then pm_message "$*"; else echo "$*"; fi; }
finish() { command -v pm_finish > /dev/null 2>&1 && pm_finish; }
DEVICE_ARCH=${DEVICE_ARCH:-aarch64}

$ESUDO chmod +x "$GAMEDIR/bt3.aarch64" "$GAMEDIR/bt4.aarch64" "$GAMEDIR/bt3-install.aarch64" "$GAMEDIR/bt3-progress.aarch64" 2> /dev/null

if [ ! -f "$GAMEDIR/gamedata/.installed" ]; then
  shopt -s nullglob nocaseglob
  discs=("$GAMEDIR"/assets/*.iso)
  shopt -u nocaseglob
  if [ ${#discs[@]} -eq 0 ]; then
    msg "No disc image found. Put your Budokai Tenkaichi 3 USA (SLUS-21678) .iso in ports/dbzbt3/assets."
    sleep 15
    finish
    exit 1
  fi
  for disc in "${discs[@]}"; do
    [ -f "$GAMEDIR/gamedata/.installed" ] && break
    if [ -x "$GAMEDIR/bt3-progress.aarch64" ]; then
      ./bt3-install.aarch64 "$disc" "$GAMEDIR/gamedata" | ./bt3-progress.aarch64
    else
      msg "First start: copying the game's files from $(basename "$disc"). This takes a few minutes..."
      shown=-5
      ./bt3-install.aarch64 "$disc" "$GAMEDIR/gamedata" | while read -r tag pct rest; do
        if [ "$tag" = "@progress" ] && [ "$pct" -ge $((shown + 5)) ]; then
          shown=$pct
          msg "First start: copying the game's files... $pct %"
        fi
      done
    fi
  done
  if [ ! -f "$GAMEDIR/gamedata/.installed" ]; then
    msg "The disc image could not be used: see ports/dbzbt3/log.txt."
    sleep 15
    finish
    exit 1
  fi
  echo "Done. The .iso in ports/dbzbt3/assets can be deleted now to free space."
fi

if [ ! -f "$GAMEDIR/gamedata/.eu" ]; then
  shopt -s nullglob nocaseglob
  for disc in "$GAMEDIR"/assets/*.iso; do
    ./bt3-install.aarch64 --eu "$disc" "$GAMEDIR/gamedata" > /dev/null && { echo "European languages installed from $(basename "$disc")"; break; }
  done
  shopt -u nullglob nocaseglob
fi

if grep -q '^modified=1' "$GAMEDIR/gamedata/.installed"; then
  export BT3_MODDED_DISC=1
fi

[ -f "$GAMEDIR/bt3_settings.txt" ] || cp "$GAMEDIR/bt3_settings.default.txt" "$GAMEDIR/bt3_settings.txt"
grep -q '^alpha_fetch4=' "$GAMEDIR/bt3_settings.txt" && sed -i '/^alpha_fetch4=/d;s/^alpha_fetch=1/alpha_fetch=0/' "$GAMEDIR/bt3_settings.txt"
if ! grep -q '^r36s_defaults=4' "$GAMEDIR/bt3_settings.txt"; then
  sed -i '/^fx_off=/d;/^frameskip=/d;/^scale4=/d;/^scale=/d;/^r36s_defaults=/d' "$GAMEDIR/bt3_settings.txt"
  printf 'fx_off=63\nframeskip=2\nscale4=3\nr36s_defaults=4\n' >> "$GAMEDIR/bt3_settings.txt"
fi
mkdir -p "$GAMEDIR/saves" "$GAMEDIR/textures" "$GAMEDIR/stages" "$GAMEDIR/songs" "$GAMEDIR/gamedata/mods"

if [ ${#sdl_controllerconfig} -lt 100000 ]; then
  export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
fi

if [ "${CFW_NAME,,}" = "knulli" ]; then
  swap_abxy() { sed -e 's/,a:/,@A@:/g; s/,b:/,a:/g; s/,@A@:/,b:/g' \
                    -e 's/,x:/,@X@:/g; s/,y:/,x:/g; s/,@X@:/,y:/g'; }
  [ -n "${SDL_GAMECONTROLLERCONFIG:-}" ] && export SDL_GAMECONTROLLERCONFIG="$(printf '%s\n' "$SDL_GAMECONTROLLERCONFIG" | swap_abxy)"
  if [ -f "${SDL_GAMECONTROLLERCONFIG_FILE:-}" ]; then
    swap_abxy < "$SDL_GAMECONTROLLERCONFIG_FILE" > "$GAMEDIR/gamecontrollerdb_swapped.txt" &&
      export SDL_GAMECONTROLLERCONFIG_FILE="$GAMEDIR/gamecontrollerdb_swapped.txt"
  fi
  echo "[dbzbt3] knulli: A/B and X/Y swapped"
fi

AUDIO_DRV="${SDL_AUDIODRIVER:-alsa}"
for s in "${XDG_RUNTIME_DIR:-/nonexistent}/pulse/native" "/run/user/$(id -u)/pulse/native" \
         /run/user/*/pulse/native /run/pulse/native /var/run/pulse/native; do
  if [ -S "$s" ]; then export PULSE_SERVER="unix:$s"; AUDIO_DRV="pulseaudio,alsa"; break; fi
done
case "$AUDIO_DRV" in sdl2|"") AUDIO_DRV=alsa ;; esac
echo "[dbzbt3] audio: $AUDIO_DRV${PULSE_SERVER:+ ($PULSE_SERVER)}"

BIN=bt3.aarch64
if [ -f "$GAMEDIR/bt4.aarch64" ] && [ "$(od -An -tx4 -j 82932 -N4 "$GAMEDIR/gamedata/disc/SLUS_216.78" 2> /dev/null | tr -d ' ')" = "080efb88" ]; then
  BIN=bt4.aarch64
fi

export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"
if [ -f "$GAMEDIR/libs.${DEVICE_ARCH}/libSDL3.so.0" ]; then
  case "${SDL_VIDEODRIVER:-}" in sdl2|"") v=kmsdrm ;; *) v="$SDL_VIDEODRIVER" ;; esac
  if [ "$v" = "wayland" ]; then
    sock=""
    if pidof sway > /dev/null 2>&1 || pidof labwc > /dev/null 2>&1 || pidof weston > /dev/null 2>&1; then
      for dir in "${XDG_RUNTIME_DIR:-}" /var/run /run /run/user/0 /tmp; do
        [ -n "$dir" ] || continue
        for w in "${WAYLAND_DISPLAY:-}" wayland-1 wayland-0; do
          [ -n "$w" ] && [ -S "$dir/$w" ] && { sock="$dir/$w"; break 2; }
        done
      done
    fi
    if [ -n "$sock" ]; then
      export XDG_RUNTIME_DIR="$(dirname "$sock")" WAYLAND_DISPLAY="$(basename "$sock")"
      echo "wayland: $sock"
    elif [ -e /dev/dri/card0 ]; then
      echo "wayland: no compositor, KMSDRM instead"
      v=kmsdrm
    elif [ -e /dev/mali ] || [ -e /dev/mali0 ] || [ -e /dev/disp ]; then
      echo "wayland: no compositor, the Mali display driver instead"
      v=mali
    fi
  fi
  if [ "$v" = "kmsdrm" ] && [ -n "${XDG_RUNTIME_DIR:-}" ] && [ ! -d "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR=/tmp/kmsdrm_runtime
    mkdir -p "$XDG_RUNTIME_DIR" && chmod 700 "$XDG_RUNTIME_DIR"
  fi
  [ -z "${SDL3SHIM_SDL2_VIDEODRIVER:-}" ] && export SDL3SHIM_SDL2_VIDEODRIVER="$v"
  [ -z "${SDL3SHIM_SDL2_AUDIODRIVER:-}" ] && export SDL3SHIM_SDL2_AUDIODRIVER="$AUDIO_DRV"
  export SDL_VIDEODRIVER=sdl2 SDL_AUDIODRIVER=sdl2
fi
echo "SDL: SDL3 driver $SDL_VIDEODRIVER, SDL2 driver ${SDL3SHIM_SDL2_VIDEODRIVER:-} / ${SDL3SHIM_SDL2_AUDIODRIVER:-}"

if [ -n "${GPTOKEYB2:-}" ]; then
  $GPTOKEYB2 "$BIN" -c "$GAMEDIR/bt3.ini" > /dev/null 2>&1 &
elif [ -n "${GPTOKEYB:-}" ]; then
  $GPTOKEYB "$BIN" > /dev/null 2>&1 &
fi

exec 9> /tmp/dbzbt3.lock
if command -v flock > /dev/null && ! flock -n 9; then
  echo "already running"
  exit 1
fi

for node in /dev/dri/card0 /dev/dri/renderD128 /dev/mali0; do
  [ -e "$node" ] && { [ -r "$node" ] && [ -w "$node" ] || $ESUDO chmod 666 "$node"; }
done

wifi_ps=""
for w in /sys/class/net/wlan*; do
  [ -e "$w" ] || continue
  i=$(basename "$w")
  if command -v iw > /dev/null 2>&1; then
    case "$($ESUDO iw dev "$i" get power_save 2>/dev/null)" in *on*) wifi_ps="$wifi_ps $i";; esac
    $ESUDO iw dev "$i" set power_save off 2>/dev/null
  elif command -v iwconfig > /dev/null 2>&1; then
    $ESUDO iwconfig "$i" power off 2>/dev/null
  fi
  echo "wifi: $i power saving off"
done

GPU_MHZ=${BT3_GPU_MHZ:-520}
clock_max=$(grep -s '^clock_max=' "$GAMEDIR/bt3_settings.txt" | tail -1 | cut -d= -f2)
[ "$clock_max" = "1" ] && GPU_MHZ=99999
gpufreq=""
for d in /sys/class/devfreq/*; do
  [ -f "$d/available_frequencies" ] || continue
  case "$(basename "$d")$(cat "$d/name" 2>/dev/null)" in *gpu*|*mali*|*ff400000*) gpufreq="$d"; break ;; esac
done
if [ -n "$gpufreq" ]; then
  want=$((GPU_MHZ * 1000000))
  avail=$(cat "$gpufreq/available_frequencies")
  if ! echo " $avail " | grep -q " $want "; then
    want=$(echo $avail | tr ' ' '\n' | sort -n | tail -1)
  fi
  old_gov=$(cat "$gpufreq/governor" 2>/dev/null); old_min=$(cat "$gpufreq/min_freq" 2>/dev/null); old_max=$(cat "$gpufreq/max_freq" 2>/dev/null)
  for f in max_freq min_freq max_freq; do echo "$want" | $ESUDO tee "$gpufreq/$f" > /dev/null 2>&1; done
  echo "GPU locked at $(cat "$gpufreq/cur_freq" 2>/dev/null) Hz ($gpufreq)"
fi
dmcfreq=""
if [ "${BT3_DMC:-1}" != "0" ]; then
  for d in /sys/class/devfreq/dmc /sys/class/devfreq/*.dmc /sys/devices/platform/dmc/devfreq/dmc; do
    [ -f "$d/available_frequencies" ] && dmcfreq="$d" && break
  done
fi
if [ -n "$dmcfreq" ]; then
  dmc_top=$(cat "$dmcfreq/available_frequencies" | tr ' ' '\n' | sort -n | tail -1)
  dmc_gov=$(cat "$dmcfreq/governor"); dmc_min=$(cat "$dmcfreq/min_freq"); dmc_max=$(cat "$dmcfreq/max_freq")
  for f in max_freq min_freq; do echo "$dmc_top" | $ESUDO tee "$dmcfreq/$f" > /dev/null 2>&1; done
  echo "RAM locked at $(cat "$dmcfreq/cur_freq" 2>/dev/null) Hz ($dmcfreq)"
fi
cpugov=/sys/devices/system/cpu/cpufreq/policy0/scaling_governor
[ -f "$cpugov" ] || cpugov=/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
[ -f "$cpugov" ] && old_cpu=$(cat "$cpugov") && echo performance | $ESUDO tee /sys/devices/system/cpu/cpufreq/policy*/scaling_governor /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null 2>&1

ZRAM_MB=${BT3_ZRAM_MB:-500}
zram=""
if [ "$ZRAM_MB" -gt 0 ]; then
  [ -e /sys/block/zram0 ] || $ESUDO modprobe zram num_devices=1 2>/dev/null
  command -v mkswap > /dev/null 2>&1 && command -v swapon > /dev/null 2>&1 || ZRAM_MB=0
  if [ "$ZRAM_MB" -le 0 ]; then
    echo "zram: no mkswap / swapon here, left alone"
  elif grep -q '^/dev/zram' /proc/swaps && [ "$(awk '/^\/dev\/zram/ {s += $3} END {print int(s / 1024)}' /proc/swaps)" -ge "$ZRAM_MB" ]; then
    echo "zram: already on with ${ZRAM_MB} MB or more, left as it is"
  elif [ -e /sys/block/zram0 ]; then
    zram=/sys/block/zram0
    zram_was_swap=0; grep -q '^/dev/zram0 ' /proc/swaps && zram_was_swap=1
    zram_old_size=$(cat $zram/disksize)
    zram_old_alg=$(sed -n 's/.*\[\(.*\)\].*/\1/p' $zram/comp_algorithm)
    [ $zram_was_swap = 1 ] && $ESUDO swapoff /dev/zram0
    echo 1 | $ESUDO tee $zram/reset > /dev/null
    for alg in lz4 lzo-rle lzo; do
      grep -qw "$alg" $zram/comp_algorithm && echo $alg | $ESUDO tee $zram/comp_algorithm > /dev/null && break
    done
    echo "${ZRAM_MB}M" | $ESUDO tee $zram/disksize > /dev/null
    $ESUDO mkswap /dev/zram0 > /dev/null && $ESUDO swapon -p 100 /dev/zram0
    echo "zram: $(grep '^/dev/zram0 ' /proc/swaps)"
  else
    echo "zram: not available in this kernel"
  fi
fi

sync
STOPPED_SVC=""
for svc in tailscaled.service; do
  if command -v systemctl > /dev/null 2>&1 && systemctl is-active --quiet "$svc" 2> /dev/null; then
    $ESUDO systemctl stop "$svc" > /dev/null 2>&1 && STOPPED_SVC="$STOPPED_SVC $svc"
  fi
done
echo 3 | $ESUDO tee /proc/sys/vm/drop_caches > /dev/null 2>&1
old_swappiness=$(cat /proc/sys/vm/swappiness 2>/dev/null)
echo 10 | $ESUDO tee /proc/sys/vm/swappiness > /dev/null 2>&1

command -v pm_platform_helper > /dev/null 2>&1 && pm_platform_helper "$GAMEDIR/$BIN"
./$BIN &
game=$!
sleep 1
for t in /proc/$game/task/*; do $ESUDO renice -n -10 -p "${t##*/}" > /dev/null 2>&1; done
wait $game
status=$?
if [ $status = 4 ]; then
  tried="${SDL3SHIM_SDL2_VIDEODRIVER:-}"
  for alt in kmsdrm mali wayland; do
    [ $status = 4 ] || break
    [ "$alt" = "$tried" ] && continue
    case $alt in kmsdrm) [ -e /dev/dri/card0 ] || continue ;; mali) [ -e /dev/mali ] || [ -e /dev/mali0 ] || [ -e /dev/disp ] || continue ;; esac
    echo "display: no GPU with $tried, trying $alt"
    export SDL3SHIM_SDL2_VIDEODRIVER=$alt
    ./$BIN &
    game=$!
    wait $game
    status=$?
  done
fi
[ -n "$old_swappiness" ] && echo "$old_swappiness" | $ESUDO tee /proc/sys/vm/swappiness > /dev/null 2>&1

if [ -n "$zram" ]; then
  $ESUDO swapoff /dev/zram0 2>/dev/null
  echo 1 | $ESUDO tee $zram/reset > /dev/null
  if [ "$zram_old_size" != "0" ]; then
    [ -n "$zram_old_alg" ] && echo "$zram_old_alg" | $ESUDO tee $zram/comp_algorithm > /dev/null
    echo "$zram_old_size" | $ESUDO tee $zram/disksize > /dev/null
    if [ $zram_was_swap = 1 ]; then $ESUDO mkswap /dev/zram0 > /dev/null && $ESUDO swapon /dev/zram0; fi
  fi
fi

if [ -n "$gpufreq" ]; then
  echo "$old_min" | $ESUDO tee "$gpufreq/min_freq" > /dev/null
  echo "$old_max" | $ESUDO tee "$gpufreq/max_freq" > /dev/null
  echo "$old_gov" | $ESUDO tee "$gpufreq/governor" > /dev/null
fi
if [ -n "$dmcfreq" ]; then
  echo "$dmc_min" | $ESUDO tee "$dmcfreq/min_freq" > /dev/null
  echo "$dmc_max" | $ESUDO tee "$dmcfreq/max_freq" > /dev/null
  echo "$dmc_gov" | $ESUDO tee "$dmcfreq/governor" > /dev/null
fi
[ -n "$old_cpu" ] && echo "$old_cpu" | $ESUDO tee /sys/devices/system/cpu/cpufreq/policy*/scaling_governor /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null 2>&1
for i in $wifi_ps; do $ESUDO iw dev "$i" set power_save on 2>/dev/null; done

if [ $status -ne 0 ] && grep -q "no OpenGL ES 3.0 context\|could not start" "$GAMEDIR/log.txt"; then
  msg "The GPU could not be started: an OpenGL ES 3 driver (Mali-G31 or newer) is needed. Details in ports/dbzbt3/log.txt."
  sleep 15
elif [ $status -ge 128 ] && [ $status -ne 137 ] && [ $status -ne 143 ]; then
  msg "Tenkaichi 3 stopped (signal $((status - 128))). Please share ports/dbzbt3/log.txt."
  sleep 10
fi

for svc in $STOPPED_SVC; do $ESUDO systemctl start "$svc" > /dev/null 2>&1; done
finish
