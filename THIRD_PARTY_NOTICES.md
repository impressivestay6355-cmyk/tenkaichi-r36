# Third-party notices

## The port

`dbzbt3/bt3.aarch64` is built from [Tenkaichi3DecompAndroid](https://github.com/dfdx047/Tenkaichi3DecompAndroid)
at commit `c3b7c86` (MIT), merged with [Tenkaichi3Decomp](https://github.com/z3xox/Tenkaichi3Decomp) 0.1.38.6
(AGPL-3.0), with this port's own changes. It is therefore distributed under the **AGPL-3.0**; its complete source
code is the `tenkaichi-r36-source-v1.0.zip` attached to the same release. `dbzbt3/bt3-install.aarch64` and `dbzbt3/bt3-progress.aarch64` are this port's own
programs.

## Statically linked libraries

- Dear ImGui (MIT)
- miniaudio (public domain / MIT-0)
- xxHash (BSD-2-Clause)
- newlib libm (BSD-style, see the file headers)
- GCC 7.5.0 libstdc++ / libgcc, unmodified, from the Ubuntu 18.04 cross packages (GPL-3.0 with the GCC Runtime
  Library Exception 3.1)
- glibc 2.27 start-up files `crt1.o`, `crti.o`, `crtn.o` and `libc_nonshared.a` (LGPL-2.1+ with its linking
  exception)

## Bundled files

- `dbzbt3/fonts/`: Anton (SIL OFL 1.1), DejaVu (Bitstream Vera license).
- `dbzbt3/tbo/ui/`: online menu artwork, credits in `dbzbt3/licenses/tbo-ui-credits.txt`.

- `dbzbt3/libs.aarch64/libSDL3.so.0`: SDL 3, "SDL3 with SDL2 backend" fork by bmdhacks (zlib).

glibc and SDL 2 are not shipped: the port uses the device's own copies.
License texts: [dbzbt3/licenses](dbzbt3/licenses).
