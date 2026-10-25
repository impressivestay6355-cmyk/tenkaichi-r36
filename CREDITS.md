# Credits

## Port

ImpressiveStay: the R36S / handheld port. This covers renderer and performance work for the Mali-G31, handheld
controls, the launcher, the installer and the packaging.

## Built on

- [Tenkaichi3Decomp](https://github.com/z3xox/Tenkaichi3Decomp) by **z3xox and contributors** (AGPL-3.0 from
  0.1.36, MIT before; this port is built on 0.1.38.6): the decompilation of *Budokai Tenkaichi 3* and its native PC port. All credit for the
  decompilation goes to them. Upstream also credits RexxColder for the OpenGL renderer and the custom stages and songs.
- [Tenkaichi3DecompAndroid](https://github.com/dfdx047/Tenkaichi3DecompAndroid) ("Dragon Rage") by **dfdx047**
  (MIT): the Android port this port branched from, at commit `c3b7c86` (Dragon Rage 0.4.0).

This repository adds the R36S build, the OpenGL ES 3 renderer work, the controls, the launcher script, the disc
installer and the packaging.

## Game

*Dragon Ball Z: Budokai Tenkaichi 3* by Spike, published by Bandai Namco / Atari. *Dragon Ball* by Akira Toriyama.
Not included.

## Third-party components

- [SDL 3](https://libsdl.org): window, sound, controllers (zlib).
- [SDL3 with SDL2 backend](https://github.com/bmdhacks/SDL/tree/sdl2-backend) by bmdhacks: runs on each CFW's own
  SDL 2 (zlib).
- [miniaudio](https://miniaud.io): sound (public domain / MIT-0).
- Anton and DejaVu fonts (SIL OFL / Bitstream Vera license).
- [Dear ImGui](https://github.com/ocornut/imgui): settings window (MIT).
- [xxHash](https://github.com/Cyan4973/xxHash): hashes (BSD-2-Clause).
- [newlib](https://sourceware.org/newlib/) libm: math functions (BSD-style).
- GCC runtime (static libstdc++ / libgcc, GCC Runtime Library Exception) and the glibc start-up files.
- [PortMaster](https://portmaster.games): `control.txt` and gptokeyb, from the device.

License texts: [dbzbt3/licenses](dbzbt3/licenses).
