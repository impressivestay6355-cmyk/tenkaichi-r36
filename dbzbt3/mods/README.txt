Script mods.

Each mod is a folder here with a file mod.lua in it (a Lua script): mods/<name>/mod.lua. A mod can draw over the
game's picture, read the fight (health, ki, positions) and change how the fight camera is shown. It cannot change a
fight, read or write files or reach the network, so mods can be used in an online match.

In the game, the Mods tab of the settings lists them: switch each on or off, change its settings, see why one stopped, and load them
all again after adding or changing one. Your choices are kept in bt3_mods.txt. A mod starts switched off.

The ones that come with the game: modern_camera (inertia, tilt, hit
reactions, distance, height and zoom), modern_look (anime shading, rim light, colours, ambient shadows), skill_list
(your moves and their buttons while you hold charge), and two small examples to start from (example_hud,
example_camera).
