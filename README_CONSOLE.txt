# HodorReflexes

Discord: https://discord.gg/8YpvXJhAyz
Github: https://m00nyone.github.io/HodorReflexes/

Hodor Reflexes allows you to view shared DPS and Ult data from group members.
Originally written by @andy.s, this is a complete rewrite and rebrand of the addon to use modern libraries and APIs.

To reposition the lists you need to go in the addon settings.

How does this addon work?:
- it uses LibGroupCombatStats to get it's data. LibGroupCombatStats shares the ultimate/dps/hps data with your group members. It uses ZoS new Broadcast API introduced in U45 which replaces the old hacky way of sending MapPings back and forth between group members to share small amounts of data.
