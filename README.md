# Dragon Ball Z: Budokai Tenkaichi 3 and 4 for Retro Handhelds

Native ports of **Budokai Tenkaichi 3** (USA, `SLUS-21678`) and **Budokai Tenkaichi 4 Tag Team** (B14 Rev2, Spanish or English) for
PortMaster handhelds (R36S, and devices compatible with Portmaster,aarch64, OpenGL ES 3). They run the games' own code
compiled for the handheld; they are not emulators. **No game data is included**: you need your own disc images.

| Folder | Port | Built on |
|---|---|---|
| [`dbzbt3/`](dbzbt3) | Budokai Tenkaichi 3 | [Tenkaichi3Decomp](https://github.com/z3xox/Tenkaichi3Decomp) (z3xox) + [Tenkaichi3Decomp-Vita](https://github.com/arielxflores/Tenkaichi3Decomp-Vita) renderer (arielxflores) |
| [`dbzbt4/`](dbzbt4) | Budokai Tenkaichi 4 (mod by [Team BT4](https://teambt4.wixsite.com/teambt4projects)) | [BT4decomp](https://github.com/NauTaro/DBZ-BT4-Tag-Team-Decomp) (NauTaro), itself built on Tenkaichi3Decomp |

## Releases

Each release has four files:

| File | What it is |
|---|---|
| `dbzbt3.zip` | BT3 port |
| `dbzbt4.zip` | BT4 port |
| `dbz-bt3-r36s-source.zip` | Complete corresponding source of the BT3 package |
| `dbz-bt4-r36s-source.zip` | Complete corresponding source of the BT4 package |

## Install

1. Extract the port's zip and copy its folder (`dbzbt3/` or `dbzbt4/`) and its `.sh` launcher into the handheld's `ports/` folder.
2. Put your own disc image (`.iso`) in `dbzbt3/assets/` or `dbzbt4/assets/` (BT4: both languages are allowed; the game asks which one to play).
3. Start the port. The first start copies the game's files (about 4 GB free space per language, 5 to 15 minutes). The `.iso` can be deleted afterwards.

Controls: hold SELECT for 2 s for the settings, L3 in fights turns the stick one full turn for clashes (can be switched off), START + SELECT quits.

## Online

- **BT3**: 1 vs 1 through room codes, using the port's own matchmaking Worker (`port/matchmaking` in the BT3 source zip) or direct addresses.
- **BT4**: 1 vs 1, lobbies, spectators and Tag Team use **NauTaro's BT4decomp online services** (Supabase signaling and the Tag Team Worker; their
  source is in `supabase/` and `cloudflare/` in the BT4 source zip), so a handheld joins the same rooms as the PC version with the same
  disc profile. 1 vs 1 room codes can also use the port's own Worker (`port/matchmaking` in the BT4 source zip). Voice chat is not available (no microphone).

## Building

The full source of each port is in its source zip on the release page: see `docs/` and `port/tools/r36s.py` inside.

## Credits

See [NOTICE.md](NOTICE.md) for who wrote what and under which licence, and [THIRD_PARTY.md](THIRD_PARTY.md) for the libraries.

- Tenkaichi3Decomp: **z3xox** and contributors
- Also in Tenkaichi3Decomp: **RexxColder** (OpenGL renderer, custom stages and songs), **dfdx047** (Tenkaichi3DecompAndroid), **JosephLlacchua** (in-game update download)
- Tenkaichi3Decomp-Vita (renderer): **arielxflores**, [repository](https://github.com/arielxflores/Tenkaichi3Decomp-Vita)
- Also credited by the Vita port: BT3-Decompiled's authors (the decompilation); Spike, developer of Dragon Ball Z: Budokai Tenkaichi 3; Rinnegatamante (vitaGL, vitaShaRK); bythos14 (SceShaccCgExt); GrapheneCt (CapUnlocker); the VitaSDK team
- Budokai Tenkaichi 4 (the modified Budokai Tenkaichi 3 game this port runs, B14 Rev2): **Team BT4 / TeamBT4 Projects**, [official site](https://teambt4.wixsite.com/teambt4projects)
- BT4decomp (BT4 decompilation, Tag Team, tournaments, spectators, voice, online services): **NauTaro**, [repository](https://github.com/NauTaro/DBZ-BT4-Tag-Team-Decomp)
- Handheld (R36S) port: **ImpressiveStay** (assisted by AI)

## Links

- **Team BT4 (BT4 game):** [official site](https://teambt4.wixsite.com/teambt4projects)
- **BT4decomp (NauTaro):** [repository](https://github.com/NauTaro/DBZ-BT4-Tag-Team-Decomp)
- **Tenkaichi3Decomp (z3xox):** [repository](https://github.com/z3xox/Tenkaichi3Decomp)
- **Tenkaichi3Decomp-Vita (arielxflores):** [repository](https://github.com/arielxflores/Tenkaichi3Decomp-Vita)

## Support

If you enjoy these ports and want to support their development, you can do so on [Ko-fi](https://ko-fi.com/impressivestay63).

## Licence

Source code: **AGPL-3.0** ([LICENSE](LICENSE)) and, for the parts of Tenkaichi3Decomp released under it, **MIT** ([LICENSE-MIT](LICENSE-MIT)).
Bundled libraries keep their own licences: every text is in [`dbzbt3/licenses`](dbzbt3/licenses) and [`dbzbt4/licenses`](dbzbt4/licenses), and in `licenses-all/` inside each source zip.

## Disclaimer

Fan project, not affiliated with or endorsed by Bandai Namco, Shueisha, Toei Animation, Akira Toriyama or any rights holder.
*Dragon Ball* and its characters are the property of their owners. The games' code and data belong to their rights holders;
this repository contains **no** game data, disc images or BIOS files.

**Team BT4:** nothing of Team BT4's Budokai Tenkaichi 4 mod is distributed here. The BT4 disc image (ISO) is a modified version of the Budokai Tenkaichi 3 game, created by Team BT4, and is not included: you need your own copy. The port only reads your own copy on the first start.
