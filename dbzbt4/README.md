# Dragon Ball Z: Budokai Tenkaichi 4 (native, BT4 B14 Rev2)

Native port of BT4 Tag Team (BT4decomp, NauTaro), built on the BT3 decompilation (Tenkaichi3Decomp, z3xox).
Renderer: the PS Vita port's (Tenkaichi3Decomp-Vita, arielxflores), on OpenGL ES 3.
Port for handhelds by ImpressiveStay. Not an emulator. The game is not included.

## Install

1. Copy `dbzbt4/` and `DBZ Budokai Tenkaichi 4.sh` into `ports/`.
2. Put your own *BT4 B14 Rev2* disc image (`.iso`, LATINO or English) in `dbzbt4/assets/`.
   Both? Put both: the game asks which language to play.
3. Start the port. The first start copies the game's files (about 4 GB free space per language);
   the `.iso` can be deleted afterwards.

Works with PortMaster on ArkOS, ROCKNIX, muOS, Knulli, AmberELEC and the like
(aarch64, OpenGL ES 3 GPU: Mali-G31 or newer, 1 GB RAM).

## Online

1 vs 1, lobbies, spectators and Tag Team use BT4decomp's online service (the same rooms as the PC version,
same disc profile needed). Room codes by address and the port's own matchmaking Worker work as in the BT3 port.
Voice chat is not available (no microphone).

## Controls

| Button | Action |
| --- | --- |
| SELECT (hold 2 s) | settings (effects, frame skipping, sound, controls, online, quit) |
| L3 (in fights) | one full turn of the stick (clashes); can be turned off in Controls |
| START + SELECT | quit |

## Files

Saves in `saves/`, settings in `bt3_settings.txt`, the log in `log.txt`.
To install again: delete `gamedata/` and the `.iso.done` marker next to the disc image.

## Credits and licences

- Budokai Tenkaichi 4 (the modified Budokai Tenkaichi 3 game this port runs, B14 Rev2): **Team BT4 / TeamBT4 Projects**, https://teambt4.wixsite.com/teambt4projects/descarga
- BT4decomp (BT4 Tag Team decompilation, Tag Team, tournaments, spectators, voice, online services): **NauTaro**, https://github.com/NauTaro/DBZ-BT4-Tag-Team-Decomp, AGPL-3.0
- Tenkaichi3Decomp (BT3 decompilation and native runtime): **z3xox** and contributors, https://github.com/z3xox/Tenkaichi3Decomp, AGPL-3.0 and MIT
- Tenkaichi3Decomp-Vita (renderer): **arielxflores**, https://github.com/arielxflores/Tenkaichi3Decomp-Vita, AGPL-3.0
- Also credited by the Vita port: BT3-Decompiled's authors (the decompilation); Spike, developer of Dragon Ball Z: Budokai Tenkaichi 3; Rinnegatamante (vitaGL, vitaShaRK); bythos14 (SceShaccCgExt); GrapheneCt (CapUnlocker); the VitaSDK team
- Handheld port: **ImpressiveStay** (assisted by AI), AGPL-3.0
- Interface art: MarshallPunk, pluantoine (CC BY 4.0)
- Online play uses NauTaro's BT4decomp services; the same rooms as the PC version.
- Every licence text is in `licenses/`; `licenses/NOTICE.txt` says who wrote what. The source of this exact package is in the release's source zip.
- Fan project, not affiliated with Bandai Namco, Shueisha, Toei Animation or any rights holder. No game data is included.
- Team BT4: nothing of their mod is distributed with this port. The BT4 disc image (ISO) is a modified version of the Budokai Tenkaichi 3 game, created by Team BT4, and is not included; get it from their official site and supply your own copy. The port only reads it on the first start.
