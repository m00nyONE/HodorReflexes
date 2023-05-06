# HodorReflexes

Hodor Reflexes allows you to share DPS, War Horn & Colossus status and some other data with group members.

Install guide:

1. Download the following libraries and put them into your AddOns folder (or just use Minion): `LibAddonMenu-2.0`, `LibCombat`, `LibDataShare`. Most likely you already have the first two.
2. Install this addon, make sure it's enabled and all dependencies are up-to-date in the in-game add-ons list.
3. Go to the addon settings and enable Damage/War Horn/Colossus sharing. To show group damage list and ultimates you also need to enable "Show Damage", "Show War Horns" and "Show Colossuses".
4. Once you've joined a group, you'll start sharing your ultimate/dps.

To reposition the lists you need to unlock UI in the addon settings.

Q&A:

1. How does this addon work?
   - It shares data via map pings every ~2 seconds. The amount of data that can be shared via 1 ping is very limited, so if you wonder if I could add more data to share, then my answer is probably no (not with this addon). And obviously all group members need to have the addon enabled to see everyone's ultimate/dps.

2. Does it conflict with Raid Notifier or other addons?
   - While the addon is enabled, it will try to automatically disable data sharing in the following addons: Raid Notifier, Bandits UI, Group Damage Share, Taos Group Tools, FTC. Any other addons that share ultimate/damage will conflict with Hodor Reflexes and increase the chances of getting kicked from the server.