# Dragon Ball Z: Budokai Tenkaichi 3 (native)

Native port built on the BT3 decompilation (Tenkaichi3Decomp, z3xox; Android port, dfdx047).
Renderer: the PS Vita port's (Tenkaichi3Decomp-Vita, arielxflores), on OpenGL ES 3.
Port for handhelds by ImpressiveStay. Not an emulator. The game is not included.

## Install

1. Copy `dbzbt3/` and `DBZ Budokai Tenkaichi 3.sh` into `ports/`.
2. Put your own *Budokai Tenkaichi 3* USA (`SLUS-21678`) disc image (`.iso`) in `dbzbt3/assets/`.
3. Start the port. The first start copies the game's files (about 4 GB free space, 5-15 minutes);
   the `.iso` can be deleted afterwards.

Works with PortMaster on ArkOS, ROCKNIX, muOS, Knulli, AmberELEC and the like
(aarch64, OpenGL ES 3 GPU: Mali-G31 or newer, 1 GB RAM).

## Controls

| Button | Action |
| --- | --- |
| SELECT (hold 2 s) | settings (effects, frame skipping, sound, controls, online, quit) |
| L3 (in fights) | one full turn of the stick (aura, beam and rush clashes); can be turned off in Controls |
| START + SELECT | quit |

## Files

Saves in `saves/`, settings in `bt3_settings.txt`, the log in `log.txt`.

## Credits and licences

- Tenkaichi3Decomp (BT3 decompilation and native runtime): **z3xox** and contributors, https://github.com/z3xox/Tenkaichi3Decomp, AGPL-3.0 and MIT
- Android port of Tenkaichi3Decomp: **dfdx047**; in-game update download: **JosephLlacchua**
- Tenkaichi3Decomp-Vita (renderer): **arielxflores**, https://github.com/arielxflores/Tenkaichi3Decomp-Vita, AGPL-3.0
- Also credited by the Vita port: BT3-Decompiled's authors (the decompilation); Spike, developer of Dragon Ball Z: Budokai Tenkaichi 3; Rinnegatamante (vitaGL, vitaShaRK); bythos14 (SceShaccCgExt); GrapheneCt (CapUnlocker); the VitaSDK team
- Handheld port: **ImpressiveStay** (assisted by AI), AGPL-3.0
- Interface art: MarshallPunk, pluantoine (CC BY 4.0)
- Every licence text is in `licenses/`; `licenses/NOTICE.txt` says who wrote what. The source of this exact package is in the release's source zip.
- Fan project, not affiliated with Bandai Namco, Shueisha, Toei Animation or any rights holder. No game data is included.
