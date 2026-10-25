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

# The port's folder: where this script is (any CFW's ports folder, any card), else PortMaster's usual place
SCRIPT_DIR=$(cd -- "$(dirname -- "$(readlink -f -- "$0" 2>/dev/null || echo "$0")")" 2>/dev/null && pwd -P)
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/dbzbt3/bt3.aarch64" ]; then
  GAMEDIR="$SCRIPT_DIR/dbzbt3"
else
  GAMEDIR="/$directory/ports/dbzbt3"
fi
cd "$GAMEDIR" || exit 1

> "$GAMEDIR/log.txt" && exec > >(tee "$GAMEDIR/log.txt") 2>&1
echo "[dbzbt3] gamedir=$GAMEDIR cfw=${CFW_NAME:-?} device=${DEVICE_NAME:-?}"

# (PortMaster's helpers, where this version of it has them)
msg() { if command -v pm_message > /dev/null 2>&1; then pm_message "$*"; else echo "$*"; fi; }
finish() { command -v pm_finish > /dev/null 2>&1 && pm_finish; }
DEVICE_ARCH=${DEVICE_ARCH:-aarch64}

$ESUDO chmod +x "$GAMEDIR/bt3.aarch64" "$GAMEDIR/bt4.aarch64" "$GAMEDIR/bt3-install.aarch64" "$GAMEDIR/bt3-progress.aarch64" 2> /dev/null

# First start: the game's files from the user's own disc image (USA, SLUS-21678) in dbzbt3/assets.
# A modified image (translation, "Tenkaichi 4" and the like) installs too: its data is used, its code changes are not.
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
  # the copy's progress on a screen of its own (bt3-progress: title, bar, percentage); PortMaster's text messages
  # every 5 % if it cannot open the screen. About 4 GB from and to the same card: 5 to 15 minutes.
  # (each image in turn until the USA one is installed: a European one beside it is only for its languages, below)
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

# The European disc (SLES-54945) beside the USA one, optional: its languages (Italian, Spanish, German, French menus
# and battle HUD) and its opening soundtrack, about 60 files. The game itself still runs on the USA disc's data.
if [ ! -f "$GAMEDIR/gamedata/.eu" ]; then
  shopt -s nullglob nocaseglob
  for disc in "$GAMEDIR"/assets/*.iso; do
    ./bt3-install.aarch64 --eu "$disc" "$GAMEDIR/gamedata" > /dev/null && { echo "European languages installed from $(basename "$disc")"; break; }
  done
  shopt -u nullglob nocaseglob
fi

# A modified image (translation, mod): the engine takes its data as it is
if grep -q '^modified=1' "$GAMEDIR/gamedata/.installed"; then
  export BT3_MODDED_DISC=1
fi

# Settings for this handheld the first time (the engine writes its own changes into the same file)
[ -f "$GAMEDIR/bt3_settings.txt" ] || cp "$GAMEDIR/bt3_settings.default.txt" "$GAMEDIR/bt3_settings.txt"
# settings of an older version of this port: the lighter defaults of this one (all effects off, frame skipping)
grep -q '^alpha_fetch4=' "$GAMEDIR/bt3_settings.txt" && sed -i '/^alpha_fetch4=/d;s/^alpha_fetch=1/alpha_fetch=0/' "$GAMEDIR/bt3_settings.txt"
if ! grep -q '^r36s_defaults=4' "$GAMEDIR/bt3_settings.txt"; then
  sed -i '/^fx_off=/d;/^frameskip=/d;/^scale4=/d;/^scale=/d;/^r36s_defaults=/d' "$GAMEDIR/bt3_settings.txt"
  printf 'fx_off=63\nframeskip=2\nscale4=3\nr36s_defaults=4\n' >> "$GAMEDIR/bt3_settings.txt"
fi
mkdir -p "$GAMEDIR/saves" "$GAMEDIR/textures" "$GAMEDIR/stages" "$GAMEDIR/songs" "$GAMEDIR/gamedata/mods"

# Linux caps one environment string at 128 KiB; a whole controller database would stop every command from starting.
if [ ${#sdl_controllerconfig} -lt 100000 ]; then
  export SDL_GAMECONTROLLERCONFIG="$sdl_controllerconfig"
fi

# Knulli's controller database names the face buttons by their Nintendo labels: A/B and X/Y back to their places
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

# Sound: a PulseAudio / PipeWire server where the CFW runs one (ROCKNIX, Knulli...), ALSA otherwise (ArkOS, muOS...)
AUDIO_DRV="${SDL_AUDIODRIVER:-alsa}"
for s in "${XDG_RUNTIME_DIR:-/nonexistent}/pulse/native" "/run/user/$(id -u)/pulse/native" \
         /run/user/*/pulse/native /run/pulse/native /var/run/pulse/native; do
  if [ -S "$s" ]; then export PULSE_SERVER="unix:$s"; AUDIO_DRV="pulseaudio,alsa"; break; fi
done
case "$AUDIO_DRV" in sdl2|"") AUDIO_DRV=alsa ;; esac
echo "[dbzbt3] audio: $AUDIO_DRV${PULSE_SERVER:+ ($PULSE_SERVER)}"

# Budokai Tenkaichi 3 or the Team BT4 mod (SLUS-219.78): the program is told from a word of the disc's main program
BIN=bt3.aarch64
if [ -f "$GAMEDIR/bt4.aarch64" ] && [ "$(od -An -tx4 -j 82932 -N4 "$GAMEDIR/gamedata/disc/SLUS_216.78" 2> /dev/null | tr -d ' ')" = "080efb88" ]; then
  BIN=bt4.aarch64
fi

# SDL 3 as the SDL3-over-SDL2 shim in libs.aarch64: display, sound and pads through this CFW's own SDL 2
# (KMSDRM or Wayland, the Mali driver it was built for). A real SDL 3 of the CFW is used if the shim is removed.
export LD_LIBRARY_PATH="$GAMEDIR/libs.${DEVICE_ARCH}:$LD_LIBRARY_PATH"
if [ -f "$GAMEDIR/libs.${DEVICE_ARCH}/libSDL3.so.0" ]; then
  # SDL 2 reads SDL_VIDEODRIVER too: it must get the CFW's own driver, never "sdl2" (ArkOS sets none: KMSDRM / ALSA)
  case "${SDL_VIDEODRIVER:-}" in sdl2|"") v=kmsdrm ;; *) v="$SDL_VIDEODRIVER" ;; esac
  [ -z "${SDL3SHIM_SDL2_VIDEODRIVER:-}" ] && export SDL3SHIM_SDL2_VIDEODRIVER="$v"
  [ -z "${SDL3SHIM_SDL2_AUDIODRIVER:-}" ] && export SDL3SHIM_SDL2_AUDIODRIVER="$AUDIO_DRV"
  export SDL_VIDEODRIVER=sdl2 SDL_AUDIODRIVER=sdl2
fi
echo "SDL: SDL3 driver $SDL_VIDEODRIVER, SDL2 driver ${SDL3SHIM_SDL2_VIDEODRIVER:-} / ${SDL3SHIM_SDL2_AUDIODRIVER:-}"

# The renderer is OpenGL ES (bt3_settings.txt gpu_api=1); gpu_api=0 picks Vulkan, for a CFW with a Vulkan driver
# (ROCKNIX's panvk). Either falls back to the other if it cannot start.

# The game reads the pad through SDL; gptokeyb2 only provides the exit hotkey (START + SELECT): bt3.ini maps no keys.
# In the game: SELECT held for 2 seconds opens the settings (resolution, effects, controls, Quit).
if [ -n "${GPTOKEYB2:-}" ]; then
  $GPTOKEYB2 "$BIN" -c "$GAMEDIR/bt3.ini" > /dev/null 2>&1 &
elif [ -n "${GPTOKEYB:-}" ]; then
  $GPTOKEYB "$BIN" > /dev/null 2>&1 &
fi

# One instance only (a second start from the menu while the first still runs)
exec 9> /tmp/dbzbt3.lock
if command -v flock > /dev/null && ! flock -n 9; then
  echo "already running"
  exit 1
fi

# The GPU's device nodes readable by the game (some CFWs keep them root-only)
for node in /dev/dri/card0 /dev/dri/renderD128 /dev/mali0; do
  [ -e "$node" ] && { [ -r "$node" ] && [ -w "$node" ] || $ESUDO chmod 666 "$node"; }
done

# Wi-Fi power saving off while the game runs: with it the USB/SDIO adapters sleep and drop packets for seconds,
# and an online match is ended ("The connection to the other player was lost"). Put back on exit.
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

# RK3326: GPU locked at 520 MHz (BT3_GPU_MHZ to change; the highest step if 520 is not one) and the CPU at its top
# speed while the game runs; what was there before comes back afterwards.
GPU_MHZ=${BT3_GPU_MHZ:-520}
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
# The memory controller (RK3326 "dmc") at its top speed too: the GPU shares the RAM and a fight's picture is
# limited by how fast it can be read and written (BT3_DMC=0 leaves it alone)
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

# zram: 500 MB of compressed memory (BT3_ZRAM_MB to change, 0 = leave it alone) on /dev/zram0 while the game
# runs (RAM only, nothing written to the card); the device's earlier zram setup comes back afterwards.
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

# Free the file cache (the copy of the disc and the menus' files) so the game has the RAM to itself
sync
# (as the Halo port: background services that wake the CPU, stopped while playing, started again after)
STOPPED_SVC=""
for svc in tailscaled.service; do
  if command -v systemctl > /dev/null 2>&1 && systemctl is-active --quiet "$svc" 2> /dev/null; then
    $ESUDO systemctl stop "$svc" > /dev/null 2>&1 && STOPPED_SVC="$STOPPED_SVC $svc"
  fi
done
echo 3 | $ESUDO tee /proc/sys/vm/drop_caches > /dev/null 2>&1
# Swap only when the RAM is really full (zram is fast, but every page through it costs the CPU)
old_swappiness=$(cat /proc/sys/vm/swappiness 2>/dev/null)
echo 10 | $ESUDO tee /proc/sys/vm/swappiness > /dev/null 2>&1

command -v pm_platform_helper > /dev/null 2>&1 && pm_platform_helper "$GAMEDIR/$BIN"
./$BIN &
game=$!
# The game ahead of everything else the CFW runs (its threads: the game, the sound)
sleep 1
for t in /proc/$game/task/*; do $ESUDO renice -n -10 -p "${t##*/}" > /dev/null 2>&1; done
wait $game
status=$?
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
  # a crash (START + SELECT ends the game with signal 9: no message for that)
  msg "Tenkaichi 3 stopped (signal $((status - 128))). Please share ports/dbzbt3/log.txt."
  sleep 10
fi

for svc in $STOPPED_SVC; do $ESUDO systemctl start "$svc" > /dev/null 2>&1; done
finish
