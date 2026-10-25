# Getting the game

*Dragon Ball Z: Budokai Tenkaichi 3* is a commercial PS2 game. Make a disc image (`.iso`) from your own original
disc, for example with ImgBurn (Windows) or `dd` (Linux):

```sh
dd if=/dev/sr0 of=bt3.iso bs=2048 status=progress
```

This project does not host or link to disc images.

- Use the **USA** release, `SLUS-21678`. The installer checks it.
- `.iso` only (not `.chd`, `.cso` or `.7z`: convert them back to `.iso` first).
- A modified image (a translation, a mod) installs too: its data is used, its changes to the game's program code
  are not.

Put the `.iso` in `ports/dbzbt3/assets/` and start the port.

## Optional: the European disc

A dump of your own European disc (*Budokai Tenkaichi 3*, `SLES-54945`) next to the USA one adds the European
languages: about 60 files are copied from it at the next start. The USA disc is still needed.
