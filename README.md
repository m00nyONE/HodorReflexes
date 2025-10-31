# HodorReflexes

[![Create ESOUI Release](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml/badge.svg?branch=release)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/release.yml)
[![Create Dev Release on Push](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml/badge.svg?branch=main)](https://github.com/m00nyONE/HodorReflexes/actions/workflows/dev-release.yml)

Github: https://github.com/m00nyONE/HodorReflexes/
Discord: https://discord.gg/8YpvXJhAyz

Hodor Reflexes allows you to view shared DPS and Ult data from group members.

Originally written by @andy.s, this is a complete rewrite and rebrand of the addon to use modern libraries and APIs.

Compatible with PC and Console versions of ESO.

# Install Guide
1. Download the required libraries (`LibAddonMenu-2.0`, `LibGroupCombatStats`, `LibGroupBroadcast`, `LibCombat`, `LibDebugLogger`, `LibCustomNames`, `LibCustomIcons`) and place them in the AddOns folder. (or just use Minion)
2. Install and enable the addon in the in-game add-ons list, ensuring all dependencies are up-to-date.
3. Join a group using HodorReflexes or a similar addon built upon LibGroupCombatStats to start viewing shared data.

# Usage
- Unlock and reposition UI elements via the addon settings or by typing `/hodor test` when not in a group.

# Features
### Ultimates
- Individual lists for the most used support ultimates in raids
- New "compact" list that shows all ultimates together ( each one can be individually turned on & off)
- New support for Slayer, Pillager and CryptCannon
- Display of ultimates from DPS players
- Calculation of how much benefit an activated ultimate set would bring to the group
- Individual counters & icons for Horn & Pillager to see if everyone is in range
- Cooldown timer for important raid buffs

### DPS
- DPS list
- Combat timer
- Group overview including burst damage of the last 10 seconds

### Hide Me
- New module to hide certain ultimates or DPS from other players' lists
- Simply choose what you want to hide in the settings. Everyone who also has that module enabled will then no longer see the hidden data.

### Pull Countdown
- Module for pull countdowns
- use /pull <seconds> to start a countdown
- Visual and audio notification when the countdown ends

### Readycheck
- Extended readycheck for the group. 
- See who has voted and who hasn't yet.

### Exit Instance
- Remove all group members from the instance with one click
- Confirmation dialog to prevent accidental or misuse

### Skill Lines
- Display of skill lines of all group members (not fully implemented yet)

### Settings
- Clear and easy-to-understand settings menu
- Only the most important and frequently used options are shown
- Advanced mode available to customize everything individually

### Extension System
- New system that can override existing functions (e.g. display of icons, names, and small gimmicks on certain days of the year)

### Developer friendly
- there are a lot of internal features exposed for other addon developers to use like creating custom lists or counters without a hassle.
- HodorReflexes modules are "examples" on how to use the internal API. everything inside there is documented.
- If there is thing that you are missing, let me know.

# Technical Details
- The addon relies on `LibGroupCombatStats` to view ultimate/DPS/HPS data among group members. If you use a different addon that also uses this library, you'll be able to see each other's data.
- It uses the ZoS Broadcast API, which replaces older hacky methods like MapPings for data sharing.