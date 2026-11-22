#!/bin/sh

# --- runtime dir (needed by PipeWire) ---
export XDG_RUNTIME_DIR="/run/user/$(id -u)"
[ -d "$XDG_RUNTIME_DIR" ] || mkdir -p "$XDG_RUNTIME_DIR"

# --- audio: PipeWire + Pulse compatibility + WirePlumber ---
pipewire &
for i in $(seq 1 20); do pactl info >/dev/null 2>&1 && break; sleep 0.1; done
pipewire-pulse &
for i in $(seq 1 20); do pactl info 2>/dev/null | grep -q "PulseAudio" && break; sleep 0.1; done
wireplumber &

# --- look & input ---
xrdb merge ~/.config/chadwm/.Xresources
xset r rate 200 50 &
~/.fehbg &
picom -b &

# --- brightness keys (handled by ~/.xbindkeysrc) ---
xbindkeys &

# --- bar + window manager ---
dash ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
