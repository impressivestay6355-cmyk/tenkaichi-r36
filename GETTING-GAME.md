# Getting the game files

This project does not host or link to disc images, and includes no game data. You need your own copy.

## BT3 (`dbzbt3`)

- Make a disc image (`.iso`) from your own original *Dragon Ball Z: Budokai Tenkaichi 3* disc, **USA release (SLUS-21678)**. The installer checks for it.
- `.iso` only: `.chd`, `.cso` or `.7z` must be converted back to `.iso` first.
- Put the file in `ports/dbzbt3/assets/` and start the port. The first start copies the game's files (about 4 GB free space, 5 to 15 minutes); the `.iso` can be deleted afterwards.
- Optional: a dump of your own European disc (SLES-54945) adds European languages; the USA disc is still required.

## BT4 (`dbzbt4`)

- *Budokai Tenkaichi 4* (B14 Rev2) is a modified version of the Budokai Tenkaichi 3 game made by **Team BT4**: you need your own copy of the disc image (Spanish LATINO or English). It is not included and not linked here.
- Put the `.iso` in `ports/dbzbt4/assets/`. Both languages are allowed: put both and the game asks which one to play.
- The first start copies the game's files (about 4 GB per language); the `.iso` can be deleted afterwards.

## Making an image of your own disc

- Windows: ImgBurn ("Create image file from disc").
- Linux: `dd if=/dev/sr0 of=game.iso bs=2048 status=progress`
