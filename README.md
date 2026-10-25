# Dragon Ball Z: Budokai Tenkaichi 3 — R36S port

Budokai Tenkaichi 3, running natively on your handheld. Not an emulator: the game's code is compiled straight for
the device, with a renderer tuned for the little Mali-G31 GPU.

This port wouldn't exist without
[Tenkaichi3Decomp](https://github.com/z3xox/Tenkaichi3Decomp) by z3xox and contributors, who decompiled the game
and built the PC port. It also builds on [dfdx047's Android port](https://github.com/dfdx047/Tenkaichi3DecompAndroid).
Huge thanks to them.

No game files are included here. You'll need your own copy of the game. This is a fan project and has nothing to do
with Bandai Namco or the Dragon Ball rights holders (see [LEGAL.md](LEGAL.md)).

It should run on any 64-bit PortMaster handheld (aarch64, OpenGL ES 3, 1 GB RAM). I've tested it on the R36S
with ArkOS.

## Install

1. Extract `dbzbt3.zip` into your `ports/` folder.
2. Put your *Budokai Tenkaichi 3* USA disc image (`SLUS-21678`, `.iso`) in `ports/dbzbt3/assets/`
   ([how to get it](GETTING-GAME.md)).
   Want Italian, Spanish, German or French menus? Drop the European image (`SLES-54945`) in there too, then pick
   the language in the settings. It only adds the languages: the USA image is always needed. You can add it later as well.
3. Launch **DBZ Budokai Tenkaichi 3**. The first start copies the game's files, which needs about 4 GB of free
   space and takes 5 to 15 minutes. Once it's done, you can delete the `.iso`.

## Controls

| Button | What it does |
| --- | --- |
| SELECT (hold 2 s) | settings: resolution, effects, frame skipping, controls, quit |
| L3 (in fights) | spins the stick for you in aura, beam and rush clashes (on/off and speed in Controls) |
| START + SELECT | quit |

Everything else works just like on the PS2.

## Online

Rooms work. One player hosts, gets a code, and the other joins with it. You can even play against the PC version
(0.1.38.6). Quick match isn't available on this port yet: it needs support on the official server, and that's in
the works upstream.

## License

The game program (`dbzbt3/bt3.aarch64`) is AGPL-3.0, like Tenkaichi3Decomp. Its full source code is
`tenkaichi-r36-source-v1.0.zip` on the release page. The launcher and docs in this repo are MIT ([LICENSE](LICENSE)).
Credits are in [CREDITS.md](CREDITS.md) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).

Have fun!
