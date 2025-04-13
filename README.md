# HodorReflexes

[![Create ESOUI Release](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml/badge.svg)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml)
[![Create Dev Release on Push](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml/badge.svg?branch=main)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml)

https://m00nyone.github.io/HodorReflexes/

Hodor Reflexes allows you to view shared DPS and Ult data from group members.

Install guide:

1. Download the following libraries and put them into your AddOns folder (or just use Minion): `LibAddonMenu-2.0`, `LibGroupCombatStats`, `LibCombat`. Most likely you already have them installed.
2. Install this addon, make sure it's enabled and all dependencies are up-to-date in the in-game add-ons list.
3. Once you've joined a group that also uses HodorReflexes, you'll start seeing ultimate/dps data.

To reposition the lists you need to unlock UI in the addon settings.

Q&A:

1. How does this addon work?
   - it uses LibGroupCombatStats to get it's data. LibGroupCombatStats shares the ultimate/dps/hps data with your group members. It uses ZoS new Broadcast API introduced in U45 which replaces the old hacky way of sending MapPings back and forth between group members to share small amounts of data.

2. Does it conflict with Raid Notifier or other addons?
   - no
