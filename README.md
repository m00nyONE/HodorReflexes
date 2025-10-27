# HodorReflexes

[![Create ESOUI Release](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml/badge.svg?branch=release)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml)
[![Create Dev Release on Push](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml/badge.svg?branch=main)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml)

https://m00nyone.github.io/HodorReflexes/

Hodor Reflexes allows you to view shared DPS and Ult data from group members.

Originally written by @andy.s, this is a complete rewrite and rebrand of the addon to use modern libraries and APIs.

# Install Guide
1. Download the required libraries (`LibAddonMenu-2.0`, `LibGroupCombatStats`, `LibGroupBroadcast`, `LibCombat`, `LibDebugLogger`, `LibCustomNames`, `LibCustomIcons`) and place them in the AddOns folder. (or just use Minion)
2. Install and enable the addon in the in-game add-ons list, ensuring all dependencies are up-to-date.
3. Join a group using HodorReflexes or a similar addon built upon LibGroupCombatStats to start viewing shared data.


# Usage
- Unlock and reposition UI elements via the addon settings or by typing `/hodor test` when not in a group.

# Technical Details
- The addon relies on `LibGroupCombatStats` to view ultimate/DPS/HPS data among group members. If you use a different addon that also uses this library, you'll be able to see each other's data.
- It uses the ZoS Broadcast API, which replaces older hacky methods like MapPings for data sharing.