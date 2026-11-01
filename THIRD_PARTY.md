# Third-party components

Texts of all licences are in [`licenses/`](licenses). "R36S" = linked into the handheld packages; "PC / other" = in the source tree for other targets only.

| Component | Use | Licence | Where |
|---|---|---|---|
| Dear ImGui | Settings and online windows | MIT | R36S |
| miniaudio | Audio | MIT-0 / public domain | R36S |
| xxHash | Hashing | BSD-2-Clause | R36S |
| newlib libm (PS2 single-precision maths) | Exact float maths | BSD-style (`COPYING.NEWLIB`) | R36S |
| miniz | Unpacking updates and texture packs | MIT | R36S |
| Monocypher | Ed25519 / update signature checks | BSD-2-Clause or CC0 | R36S |
| AMD FidelityFX FSR 1 (`ffx_a.h`, `ffx_fsr1.h`, `fsr_easu.frag`) | Upscaling | MIT | R36S |
| Qualcomm Snapdragon Game Super Resolution (`sgsr.frag`) | Upscaling | BSD-3-Clause | R36S |
| SDL3 (sdl2-compat backend) / SDL | Window, input, audio device | zlib | R36S |
| glibc, GCC runtime (with runtime exception) | C runtime shipped in the packages | LGPL-2.1+ / GPL-3.0 with GCC Runtime Library Exception | R36S |
| DejaVu fonts | Text | Bitstream Vera / DejaVu | R36S |
| Anton font | Titles | SIL OFL 1.1 | R36S |
| xBRZ | Menu upscaling (BT4) | GPL-3.0 | R36S (BT4) |
| libdatachannel, libjuice | WebRTC data channels, ICE (BT4 online) | MPL-2.0 | R36S (BT4) |
| usrsctp | SCTP for data channels | BSD | R36S (BT4) |
| plog | Logging | MIT | R36S (BT4) |
| Mbed TLS | TLS | Apache-2.0 OR GPL-2.0-or-later | R36S (BT4) |
| curl | HTTPS | curl licence (MIT-style) | R36S (BT4) |
| certifi CA bundle | TLS roots | MPL-2.0 | R36S (BT4) |
| nlohmann/json | JSON | MIT | R36S (BT4) |
| Opus | Voice codec | BSD-3-Clause | PC / R36S sources (BT4) |
| libsrtp, OpenSSL, winpthreads | Voice runtime on Windows | BSD / OpenSSL / MIT-style | PC (BT4) |
| libadrenotools | Android GPU driver loading | BSD-2-Clause | Android |
| vitaGL, vitaShaRK, SceShaccCgExt, math-neon, vitasdk | PlayStation Vita build | LGPL-3.0 / GPL-3.0 / MIT | Vita |

Combining AGPL-3.0 code with GPL-3.0 code (xBRZ) is allowed by AGPL-3.0 section 13; the combined work is distributed under AGPL-3.0 with the GPL-3.0 parts
remaining under GPL-3.0.
