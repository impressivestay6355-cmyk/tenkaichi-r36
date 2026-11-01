# Notice: provenance and licences

> Paths like `bt3/...`, `bt4/...` and `licenses/...` refer to the source zips on the release page (`dbz-bt3-r36s-source.zip`, `dbz-bt4-r36s-source.zip`). Licence texts are in `licenses/` inside each package (`dbzbt3/licenses`, `dbzbt4/licenses`) and in `licenses-all/` inside each source zip.

This repository combines the work of several authors. Each keeps their copyright; each work stays under its own licence.

## 1. Tenkaichi3Decomp: z3xox and contributors

- Repository: <https://github.com/z3xox/Tenkaichi3Decomp>, taken at tag `v0.1.39.2` (see `bt4/UPSTREAM_LOCK.json`; BT3 tree: commit `dd6b20c`).
- Licences: **AGPL-3.0** (`LICENSE`) and **MIT**, `Copyright (c) 2026 z3xox and contributors` (`LICENSE-MIT`).
- It provides the decompiled game code (`src/`, `include/`), the native runtime (`port/src`, `port/include`), the in-game updater and the
  Tenkaichi Budokai Online screens. Its README states that the decompiled game code is not covered by the MIT licence and that rights in it
  belong to the game's rights holders.
- Contributors credited in the code: RexxColder (OpenGL renderer, custom stages and songs), dfdx047 (Tenkaichi3DecompAndroid, whose work the project builds on), JosephLlacchua (in-game update download, PR #107), bmdhacks (SDL3 build with an SDL2 backend, zlib; `licenses/LICENSE.SDL3-sdl2-backend.txt`).
- The Android app and its build files are not included here (they are not part of the handheld packages).

## 2. Tenkaichi3Decomp-Vita: arielxflores

- Repository: <https://github.com/arielxflores/Tenkaichi3Decomp-Vita>. The PlayStation Vita port of Tenkaichi3Decomp. Its OpenGL renderer path and Vita runtime (`port/vita/`, `port/vglr/`) are the base of the handheld renderer here, adapted to OpenGL ES 3 on aarch64 Linux.
- Licences (as its README states): **AGPL-3.0** for the port's code (`licenses/LICENSE.Tenkaichi3Decomp-Vita.txt`), **MIT** for the original MIT code it inherits, and **LGPL-3.0** for its vitaGL patch (`port/vita/vitagl/vitagl.patch`).
- Credits it gives, repeated here: z3xox and the contributors of Tenkaichi3Decomp; BT3-Decompiled's authors (the decompilation); Spike, developer of Dragon Ball Z: Budokai Tenkaichi 3; Rinnegatamante (vitaGL, vitaShaRK); bythos14 (SceShaccCgExt); GrapheneCt (CapUnlocker); the VitaSDK team.

## 3. BT4decomp (DBZ-BT4-Tag-Team-Decomp): NauTaro

- Repository: <https://github.com/NauTaro/DBZ-BT4-Tag-Team-Decomp>
- Based on tag `v0.1.39.2-R8.1`; later revisions are listed in `bt4/CHANGELOG.md`.
- Licences: **AGPL-3.0** (`licenses/LICENSE.BT4decomp-AGPL.txt`), plus the MIT file inherited from Tenkaichi3Decomp.
- It provides the BT4 B14 Rev2 adaptation, Tag Team (simultaneous team battles), tournaments, spectators, proximity voice, the installer and the
  online services: the Supabase signaling project (`bt4/supabase`) and the Tag Team room Worker (`bt4/cloudflare`).
- BT4 content, artwork and icons retain their respective authors' rights (`bt4/docs/presentation/CREDITS.md`).
- **Online play in the BT4 port is NauTaro's service.** The handheld client talks to the same rooms as the PC version. The matchmaking Worker in
  `bt4/port/matchmaking` is an optional fallback for 1 vs 1 room codes only. As the AGPL requires for network services, the source of the
  services is in the BT4 source zip (`bt4/cloudflare`, `bt4/supabase`, `bt4/port/matchmaking`).

## 3b. Budokai Tenkaichi 4 (the game): Team BT4

- Budokai Tenkaichi 4 (B14 Rev2) is a modified version of the Budokai Tenkaichi 3 game (a mod for the PlayStation 2) created by **Team BT4 / TeamBT4 Projects**.
- Nothing of Team BT4's mod is distributed here. The BT4 disc image (ISO) is a modified version of the Budokai Tenkaichi 3 game, created by Team BT4, and is not included: the user supplies their own copy. The port only reads that copy on the first start. The site states no licence terms; all rights in the mod, its content and artwork remain with Team BT4 and the respective authors.

## 4. Handheld (R36S) port: ImpressiveStay (assisted by AI)

- The aarch64 / OpenGL ES 3 handheld layer (`port/r36s/`, the changes in `port/vglr/` and `port/src/gs/`, the launchers, installers, frame pacing, settings
  and matchmaking Worker), written on top of the works above.
- Licence: **AGPL-3.0**, the same as the works it is derived from. `Copyright (c) 2026 ImpressiveStay`.

## 5. Interface art

- Tenkaichi Budokai Online announcer artwork: **MarshallPunk**. Button artwork: **pluantoine**, CC BY 4.0 (`licenses/tbo-ui-credits.txt`).

## 6. Libraries

See [THIRD_PARTY.md](THIRD_PARTY.md). Every licence text is in `licenses/`.

## 7. Source offer (AGPL-3.0 sections 6 and 13)

Each binary package corresponds to the source zip of the same release (same repository, same tag). Anyone who receives a package or uses
the services may obtain that source from this repository's releases page.

## 8. What is not included

No game data, disc images, BIOS or `libshacccg`-style system files. The user supplies their own legally obtained disc.
Dragon Ball and related names are trademarks of their owners; no affiliation or endorsement is implied.
