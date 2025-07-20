[B]Hodor Reflexes[/B] Hodor Reflexes allows you to view shared DPS and Ult data from group members.

[SIZE="4"]Install guide:[/SIZE]

1. Download the following libraries and put them into your AddOns folder (or just use Minion): [URL="https://www.esoui.com/downloads/info7-LibAddonMenu.html"]LibAddonMenu-2.0[/URL], [URL="https://www.esoui.com/downloads/info4024-LibGroupCombatStats.html"]LibGroupCombatStats[/URL],
[URL=https://www.esoui.com/downloads/info1337-LibGroupBroadcastformerlyLibGroupSocket.html]LibGroupBroadcast[/URL], [URL="https://www.esoui.com/downloads/info2528-LibCombat.html"]LibCombat[/URL], [URL="https://www.esoui.com/downloads/info4161-LibCustomIcons.html"]LibCustomIcons[/URL], [URL="https://www.esoui.com/downloads/fileinfo.php?id=4155#info"]LibCustomNames[/URL].
Most likely you already have most of them installed.
2. Install this addon, make sure it's enabled and all dependencies are up-to-date in the in-game add-ons list.
3. Once you've joined a group that also uses HodorReflexes, you'll start seeing ultimate/dps data.

To reposition the lists you need to unlock UI in the addon settings.

[B]Q&A:[/B]
1. How can I get a custom name / icon like on the screenshots?
- Click "Donate!" above.

2. How does this addon work?
- it uses LibGroupCombatStats to get it's data. LibGroupCombatStats shares the ultimate/dps/hps data with your group members. It uses ZoS new Broadcast API introduced in U45 which replaces the old hacky way of sending MapPings back and forth between group members to share small amounts of data.

3. Does it conflict with Raid Notifier or other addons?
- no