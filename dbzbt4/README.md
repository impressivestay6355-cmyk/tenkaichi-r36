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
