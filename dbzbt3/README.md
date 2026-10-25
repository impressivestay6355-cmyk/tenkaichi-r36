# Dragon Ball Z: Budokai Tenkaichi 3 (native)

Native port built on the BT3 decompilation (Tenkaichi3Decomp, z3xox; Android port, dfdx047).
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
| SELECT (hold 2 s) | settings (resolution, effects, frame skipping, controls, quit) |
| L3 (in fights) | one full turn of the stick (aura, beam and rush clashes); can be turned off in Controls |
| START + SELECT | quit |

## Files

Saves in `saves/`, settings in `bt3_settings.txt`, the log in `log.txt`.
