[SIZE="2"][B]IMPORTANT:[/B] You need LibCustomNames and LibCustomIcons now if you want to have names and icons displayed.[/SIZE]

## 2026.02.14 - @m00nyONE
- Valentines icons are now sticky and no longer random on every update.

## 2025.12.17 - @m00nyONE
- add configurator for console
- fix undefined global - Thanks Dack for reporting that :-)

## 2025.12.01 - @m00nyONE
- add options to switch fonts for all lists individually. You can now choose between the new bold font and the oldschool font.
- adding barrier to the compact List. Thanks to @LauritsS for the PullRequest :-)

## 2025.11.21 - @m00nyONE
- fix the dialogs crashing GamePadUI. Thanks to @m0r for fixing this :-)

## 2025.11.20 - @m00nyONE
- HOTFIX: removing LibCheck dialog for ALL Platforms until a reliable solution for displaying Dialogs without crashing console & gamepad UI is found

## 2025.11.17 - @m00nyONE
- fixed names getting cut off on ult lists when size is altered - Thanks to @SirHoppel for reporting that :-)

## 2025.11.16 - @m00nyONE
- fix accountWide & characterWide settings not being applied properly.
- slightly restructure menu. AdvancedSettings and AccountWide settings toggles now only show up in the main menu. Submenus do not have these toggles anymore to reduce confusion. They now enable/disable it for everything.
- hide module & extension selection under "advanced settings" because of multiple reports from players toggling these settings on and off in the hopes of deactivating a single list and then complaining that something is broken.
- fix a bug that could lead to a nil exception being thrown when the animation extension is disabled and the icon extension is enabled but user got an animated icon and no static one. ( first frame just did not load properly )

## 2025.11.11 - @m00nyONE
- hotfix for data not updating properly in some situations

## 2025.11.07 - @m00nyONE
- adding an option to hide the readycheck window and only display a chat message when a readycheck is started.
- add LibRadialMenu by M0R for console. Now you can finally use Exit Instance and Pull Countdowns on console too! :-)
- add an option to hide counters when the buff/cooldown is active
- counters can now display active buffs/cooldowns
- fix settings reset not working properly
- creating/updating in-code emmyLUA documentation.

## 2025.11.06 - @m00nyONE
- improve overall performance of the addon
- fixed the damage list header title not updating and being stuck in it's first state
- add chinese translation by @Lykeion :-) Thank you!
- fix configurator not loading when LCI is not installed. Thanks @NeBioNik for the PR (https://github.com/m00nyONE/HodorReflexes/pull/39) :-)

## 2025.11.04 - @m00nyONE
- added frensh translation. Thank you @Melicious :-)
- updated russian translation by @NeBioNik :-)
- Fix an issue where a Saxhleel player still being displayed in the compact list even tho the horn rows have been disabled. Thanks to @isiiimode for reporting that!
- Fix a display bug in the lists that could occur when you had turned a list on, do a test, turn the list off, end the test, and then join a group and turn the list on again. The list would show old data from the test instead of the current group data. This also lead to you not seeing any data when switching a list on that was previously off until updates arrive. - Thanks to @sheumais for pointing that out!
- Fix the pull countdown not using the settings properly
- improved "/hodor test" to now also support spaces in @names for console players.
- Adding options in the settings for hiding countdowns/cooldowns from the compact list. You need to enable advanced settings to see them as they are not commonly used.
- the default width for every list has been enlarged by 10px to compensate for new font.
- advanced settings are now colored in orange to make them more visible over normal settings.
- Allow player row highlight to be turned off in advanced settings for the DPS list.
- Disable dialogs on console - temporary - they will be reenabled in a future update.
- slight performance improvements.
- combined all language files to reduce the amount of files in the addon. We were already at the cap of BNET's 100 File limit :D
- added some localization strings that were missing. ( still a lot missing tho :D )

## 2025.11.01 - @m00nyONE
Day one patch:
- fixed locked UI when trying to move controls more than once per /reloadui. Now clearing all anchors before reanchoring.
- fixed an issue where the gamepad UI (PC & Console) gets buggy when optional depenencies are not installed. This was caused by displaying a dialog at load time instead of at runtime.
- fixed atro not getting tracked properly when casted
- fixed an error that can pop up when the IsUnitInCombat check returns false even tho you are in combat. Just ZoS Things :D
- fixed readme having a wrong link to the github page
- fixed saxhleel highlight not being updated if changed in horn list. Thanks to @STUDLETON for reporting that!
- use force icon instead of horn icon for saxhleel players in compact list. Thanks to @STUDLETON for that suggestion!
- fixed cryptCannon not being calculated properly in the compact list. Thanks to @sheumais for creating a PR for that :-)
- added RU translation by @NeBioNik :-) Thank you!

- adjusting dialogs to be delayed and use default language strings instead of hardcoded ones
- switch from logger:Info() to logger:Debug() in some parts of the addon.

## 2025.10.31 - @m00nyONE
HodorReflexes got a complete rewrite from scratch! All code has been replaced and modernized to current ESO API standards.
The old legacy version will not be updated anymore and will not receive any support in the future!

Important:
- Your saved variables will be reset to default on first start after updating to this version! There is no way around that because the addon functions completely different now.

Although I tried my best to keep everything as similar as possible to the old version, there are some changes that you need to be aware of:

New Features:
- New "compact list" that combines all special ultimates into a single list. It also adds support for Slayer, Pillager and CryptCannon. The numbers next to the percentage shows the gain in seconds or ult points your group gets when fired.
- New DPS summary can be enabled in the settings. It shows the group DPS and the DPS over the last 10 seconds. Configurable through the settings menu.
- "Only show in range" option for every list. Instead of removing the players entirely, it now just makes them transparent when they are out of range.
- Every List now has the option to show/hide the percentage and/or raw ult points separately.
- Every List now has the option to be visible "never", "always", "out of combat" or on "non boss fights" only.
- Saxhleel can now be highlighted in the horn list.
- You can now finaly hide your own ultimates from others lists by using the "Hide Me" option in the settings menu.
- The "misc ultimates" list does now have an option to include all special ults like Horn, Colossus, and Atro. This way you can have a single list for all ultimates if you want to.
- New CLI commands for easier access to certain functions. To get a list of all commands, type "/hodor" in chat.

Removed Features:
- Toxic mode has been removed to stay in line with ZoS Terms of Service.
- "Ult Now" got removed as almost nobody used that anyway. The computation for this feature was too expensive for the gain it provided. - maybe in the future i readd it if there is enough demand for it.
- selfish mode for all the buffs is not implemented yet. If there is enough demand for it, I will add it in a future update.

Noteworthy changes:
- This new version is PC and Console compatible. So they are finally all on the same page which makes developing and testing way easier.
- All initialization happens at runtime! If you enable/disable a module or extension in the settings, it will not even load anymore! This improves performance and memory footprint a lot.
- Updates to the lists only happen when necessary! No more constant updates every 0.8s that waste CPU cycles for nothing.
- Even tho it looks similar to the old version UI wise, everything has been redone from scratch. So there might be small differences here and there.
- "/hodor test" command now tests all functionality of HodorReflexes and updates every second to simulate real data changes.
- The menu is now way more sorted and structured. Finding options should be way easier now. Most of the stuff that is not needed for everyday use is hidden behind the "Advanced Settings" option now.
- HodorReflexes now logs with LibDebugLogger. This will help to find issues and bugs way easier in the future.
- Extensions now no longer provide essential functionality for modules to work. You can enable/disable extensions at will without breaking anything. They simply overwrite base functionality now and thus do not require extra checks for being enabled or not each time the lists update.
- There is a new listClass available now that internally handles updates and data management for lists. This should make it easier to add new lists in the future and can also be used by external addons to create their own lists and add functionality to Hodor without hooking into its guts.
- Internally everything is handled with events now. This makes it way more modular and easier to maintain in the future. That also means other addons can use these events to hook onto HodorReflexes without breaking anything. ( looking at you HodorRestyle :D )

Known Issues:
- sometimes there are glitches with the animation extension that cause icons to not animate properly. A reloadui fixes this. I haven't completely figured out why this happens yet.
- Localization is not finished yet. Only English and partially German is done. And because I'm not a native english speaker, there might be some grammar/spelling mistakes here and there. If you want to help with translations, feel free to open a PullRequest on github or message me on discord.
- The lists only update when new data is received from LibGroupCombatStats. If the data does not change, the lists do not update. This can lead to situations where the data is stale and not up to date. That's all good and intentional but i thought i might add it here so you are aware of it.
- The new summary feature for the DPS list is not always reliable. It depends on what the client can get from ESO API. So sometimes it might be off by a few percent. I will try to improve this in the future.

Looking Forward:
- There are some things i plan on adding in the future like a "HideMe" module to control what others can see from you.
- There is a theming engine planned to allow authors to create custom themes for HodorReflexes that can be shared with others without the need to create a new UI from scratch.
- More extensions to add more functionality to the existing modules.
- Support for Barrier.

Thanks:
- A very special thanks goes to @Solinur for giving me support during development and testing of this new version!
- Thanks to all the testers that grabbed the new version early from github and helped me out finding bugs and issues!
- Thank you @andy.s for creating HodorReflexes in the first place and allowing me to take over maintenance of this awesome addon!

For a list of all Changes, please check my github: https://github.com/m00nyONE/HodorReflexes/pull/24.

## 2025.08.16 - @m00nyONE
- fixed a bug where enabling/disabling of the readycheck module did not work
- bump API
- update dependencies to their newest versions
- removed an old unused texture that was still left from before the LCI & LCN update
- new documentation workflow

## 2025.08.02 - @m00nyONE
- remove legacy icon table
- Add Percentage calculation to "other ultimates"
- You can now also enable/disable the percentage/rawUlt numbers in the "other ultimates" list, like you can do with colos, horn and atro.
- reworked RU localization by @NeBioNik ! Thanks for that!

## 2025.07.25 - @m00nyONE
- The dependencies for LibCustomIcons and LibCustomNames are now optional!
- A new reminder will now pop up if you don't have LibCustomIcons and LibCustomNames installed. You can dismiss the popup forever if you wish to not install these libraries.
- Menu changes slightly when LCI & LCN are not installed to not show icon options.
- A lot of text, menu's and components have changed over the years and all language files except en & de are outdated. If you want to help me out with translation, feel free to create a PullRequest on github please or just message me on discord :-)

## 2025.07.20 - @m00nyONE
- MAJOR UPDATE !
- HodorReflexes goes lite by default! There are no icons in the addon itself anymore! Instead, I introduced two new dependencies: LibCustomNames and LibCustomIcons. They both need to be installed for HodorReflexes to work atm.
- Hodor will now only get updates when there are new features or fixes. Icon updates will be in LibCustomIcons. No more broken HodorReflexes installations after every update! *cheer*
- LibCustomNames and LibCustomIcons is open for contributions (like HodorReflexes has been for years now). If you know how to code, just open a Pull-Request with your new icon or the ones of your friends and you are good to go :-) If not, there is still the option to donate to let a teammember of HodorReflexes do it for you.
- This update breaks all addons that use the old hacky way of retrieving icons from HodorReflexes by peaking into the HodorReflexes.users table. All addons that used the API function from Hodor to retrieve icons are fine. All addons that added custom icons to HodorReflexes will not work anymore! Merge your stuff to LibCustomIcons please. 
- To all the Addon developers: migrate to LibCustomIcons if you want to continue using Hodorreflexes icons please. It's super easy and quickly done.
- Other addons can no longer add/edit/remove icons from Hodor or tamper with them in any way. If you want to add/edit/delete something, create a Pull-Request or ask for it. We do not want bad actors manipulating icons and names of others in a harmfull way ever again.
- There is currently a legacy wrapper for the old users[] and anim.users[] tables. This will be removed in a future update!
- if anyones icon or animation is missing because of the converting process from HodorReflexes to LibCustomIcons, message me on discord so i can have a look in the old files and restore your stuff :-)

## 2025.05.07 - @m00nyONE
- fixing an issue where the playerStats table was not exposed causing other addons like HodorRestyle to not work anymore - thanks to @B7TxSpeed
- hiding menu for the HRLite build - by @NeBioNik
- adding LibCustomIcons as an optional dependency - addon will follow soon - i hope you see where this is going :D

## 2025.05.05 - @m00nyONE
- fixing an issue on PTS that colossus and atronachs are not shown when players are not "real" necros or sorcs.

## 2025.04.22 - @m00nyONE
- adding HodorReflexes Lite version to Github releases ( Version without any icons ). Thanks to @NeBioNik
  - This version will NOT be available on ESOUI or Minion for now and MUST BE INSTALLED MANUALLY after each update. 
  - There is no support on this version as there are no automatic updates or fixes that get pushed to the enduser!
  - If you encounter incompatibility issues with other addons, you are on your own.
  - There can only be ONE version of HodorReflexes installed at the same time! It is not possible to "switch" between version in the Addon Menu.
- disable toxic mode for now to stay in line with ZoS Terms of Service

## 2025.04.11 - @m00nyONE
- add integrity check to github actions pipeline. Hopefully less Hotfixes for you now :-)

## 2025.04.09 - @m00nyONE
- HodorReflexes2.0 ALPHA release!!! - Backwards incompatible!
- Almost rewritten the whole codebase ( still a lot TODO )
- using new sharing system
- data now gets shared via LibGroupCombatStats and no longer by HodorReflexes itself
  - Instead of sending everything every 2 seconds, now data is only shared when it changed!
  - much higher resolution of Ult Points and all ultimates can now be shared together with their cost! No more client side estimating a cost of another members ultimate!
  - mapPings are GONE! you can uninstall LibDataShare now :-)
- Small UI improvements
- a lot of performance enhancements
- new UIs, Pillager, MA support will follow hopefully soon
- there might be some translation issues and menu entries that do not work properly - this will get fixed in the next update

If you encounter any problems chill :D
almost ALL of them can be fixed by either reinstalling LibGroupBroadcast or HodorReflexes

## 2025.04.08 - @m00nyONE
- HodorReflexes2.0 is almost ready :-)
- introducing 2 new dependencies: LibGroupBroadcast, LibGroupCombatStats

if you get the following error:

```
user:/AddOns/LibGroupBroadcast/HandlerManager.lua:34: Handler name 'GroupResources' has already been registered by 'LibGroupResources'.
stack traceback:
[C]: in function 'error'
user:/AddOns/LibGroupBroadcast/HandlerManager.lua:34: in function 'HandlerManager:RegisterHandler'
(tail call): ?
user:/AddOns/LibGroupBroadcast/LibGroupBroadcastGroupResources/StartUp.lua:8: in function '(main chunk)'
```

Do not click reinstall in Minion, it will not help.
Uninstall LibGroupBroadcast and then install it again after it got removed.
This will fix the issue!

## 2025.03.15 - @m00nyONE
- the next update of HodorReflexes will require 2 new dependencies: LibGroupBroadcast and LibGroupCombatStats

## 2025.03.09 - @m00nyONE
- just icons

## 2025.02.12 - @m00nyONE
- fixed an issue that prevents moving the UI elements

## 2025.02.11 - @m00nyONE
- improve compatibility with LibDataShare Legacy

## 2025.02.09 - @m00nyONE
- improving overall UI update performance
- improve integrity check
- adding an info on top of the changelog to remind everyone to leave minion open for at least 2min after updating to avoid data corruption

## 2025.01.23 - @m00nyONE
- merging some icons from @TenshiRaitoEso - thanks for contributing

## 2025.01.13 - @m00nyONE
- adding optional dependencies ( LibGroupBroadcast & LibGroupCombatSTats) which will be released in a few weeks

## 2024.12.15 - @m00nyONE
- Implementing "Listen Before Transmit" (LBT): Hodor now checks if other group members are using the add-on before sharing data. This helps reduce unnecessary pings and minimizes stress on the ESO API.
- update screen now shows your friends icons <3
- update the warning message from LibAddonMenu > version 32
- adding some in-code documentation
- add LC to mock zones

## 2024.12.10 - @m00nyONE
- finetune pipelines
- merge icon changes from @B7TxSpeed

## 2024.12.06 - @m00nyONE
- new build pipeline for HodorReflexes - it now builds inside github actions & pushes the final addon.zip to ESOUI
- this might get extended in the future for scheduled releases. You asked for smaller waiting times, now you maybe get them

## 2024.11.17 - @m00nyONE
- bump api to 101044
- deduplicate some icons

## 2024.10.12 - @m00nyONE
- move hide popup binding to share module where it belongs

## 2024.08.25 - @m00nyONE
- add keybind to close Hodor update popup. Steamdeck users now can close the window by binding it to a key. Closes: https://github.com/m00nyONE/HodorReflexes/issues/4
- bump api to 101042 101043

## 2024.07.08 - @m00nyONE
- fix "ult now" not accounting ult cost reduction - thanks to @kawamonkey
- fix horn beeing displayed when player is dead - thanks to @kawamonkey

## 2024.05.24 - @m00nyONE
- add integrity check to icon menu in the addon settings
- slightly rework integrity check
- add hide option for misc ultimates in combat. ( same options as for the dps list )
- adjust Horn symbol background anchor to CENTER instead of TOPLEFT - thanks to @Near717 for pointing that out - fixes: https://github.com/m00nyONE/HodorReflexes/issues/2

## 2024.04.23 - @m00nyONE
- add @seadotarley to the addon author/credit list
- icon update
- reminder: I'm always open for contributions and ideas: https://github.com/m00nyONE/HodorReflexes

## 2024.03.10 - @m00nyONE
- the 999k damage bug should be fixed ( at least it should happen way less frequently ) ... Sadly it's impossible to "really" fix this issue as it's about the precision of the map pings being inconsistent in the ESO API.
- icon update

## 2024.02.04 - @m00nyONE
- change versioning to YYYY.MM.DD for better readability
- reverting some changes from an unauthorized person who requested changes for "friends", but instead made fun of them by putting chinese swear words in their names by abusing the fact that I can not read chinese ...
  - You got banned mate ;-) Something like that is unacceptable 
  - From now on changes will be more strict and require ingame ID verfication by sending one Gold to @m00nyONE -- This ensures that the person is knowing that a change is in progress 
- icon update

## 1.14.1 - @m00nyONE
- icon update

## 1.14.0 - @m00nyONE
- new vote module by @BloodStainChild666 - no more pling-pling-pling when doing ready checks :-) Thank you

## 1.13.3 - @m00nyONE
- U41 API bump
- icon update

## 1.13.2 - @m00nyONE
- from now on there will only be fixes due to API changes and user requests for the foreseeable future. No new features anymore..
  the reason is stated here: https://discord.com/channels/1042112475451117649/1100194108049465426/1147511074426474527
- icon updates

## 1.13.1 - @m00nyONE
- fixed colos ultimate cost - This is fixed to 175 even if the pestilence colos is equipped. A fix on that will come in a future update. But who uses the other morph now anyways
- fixed some variable leaking into global space - thanks to @dack for pointing that out

## 1.13.0 - @m00nyONE
- finalizing integrity check! you can try it with "/hodor integrity" - looks kinda funny tbo
- bump to API version 101039 ( U39 )
- adjustments for exiting instances - ready for update 39

## 1.12.4 - @m00nyONE

Because of many questions about missing icons, i added a new functionality to Hodor in 1.12.4 that will now go into Beta stage.
You can now perform an integrity check to let hodor load and scan all icons. You can do this by typing ```/hodor integrity``` into chat.
Don't be scared if it lags a lot :D it needs to load ALL icons and unload them again. The chat output should look something like this:
```
starting integritycheck
icons to scan: 4353
failed: 0
```
if *failed *is greater than 0, you should consider closing the game and reinstalling Hodor while the game is closed :-)

**IMPORTANT!**: you HAVE TO RELOAD THE UI AFTERWARDS! ```/reloadui```
Otherwise, the iconcontrols do not get unloaded. blame ZoS for this pls

- fixed a few missing old icons
- icon pack update

## 1.12.3 - @m00nyONE
- add integrity check (unfinished!!!!) /hodor integrity
- regular icon pack update

## 1.12.2 - @m00nyONE
- updates to minimum donation amounts for static and animated icons. Static is now 7M and animated is now 10M. For transparency reasons i posted an explanation in the HodorReflexes Discord here: https://discord.com/channels/1042112475451117649/1100194108049465426/1125051223658205214

## 1.12.1 - @m00nyONE
- icon updates

## 1.12.0 - @m00nyONE
- adding atronach list
- allow atronach sharing
- adding cost reduction calculation ( 15% for sorc and 5% for templar ) - there is no way to check if the passives are active. This is just an assumption
- fixed a bug that caused wrong percentage calculation on sorcs and templars. (thanks to @sheriffholmes for reporting and analyzing the issue)

## 1.11.0 - @m00nyONE

This Version will be incompatible with ALL versions prior to 1.11.0 ! So please tell your friends to update :-)

If something is displayed wrong or does not work, than its most likely that you or other members in your group haven't updated to 1.11.0 !

Version 1.10.0 was the first step in introducing Sharing V2 that allows for more Ultimates to be shared than only Horn and Colossus.
Up until this point, all Ultimate sharing was done by sending actual percentages (0% - 200%) of you ult to other players. That's the way Hodor worked in the past.

From now on, Hodor will differenciate between "special ults" and "other ults".
- "Special ults" are ultimates that are explicitly coded in Hodor like Horn and Colossus ( Barrier & Atro too in the future ).
- "Other ults" are all ultimates that are not directly tracked and don't have a special ult type that is sent to others. Examples are Incap, Shooting Star, Destro, Ballista and so on.

The sharing space is very limited and the Sharing V2 only allows for 8 unique "special ults" to be shared. everything else will just be "Other ults".

In 1.11.0 in addition to the Percentage display, that you are all used to, there now will be the raw ult points (0-500) next to it. This allows your raidlead to call your pillager/barrier/MA/SAX/whatever ult when a specific number of points is reached to increase their effectiveness. Of course you can disable showing the raw ult number in the settings.

You now also finally have the option to share every ultimate you want by enabling the "Share other Ultimates" option in the menu. It will show everyone how much ulti points you currently have and does only do so if you have no "special ults" slotted.
These "other ults" will only be displayed with the raw ulti points you have because there is no way to calculate the percentage of an ultimate when you don't which one it is.

New lists for new "special ults" like Barrier and Atro will follow soon in a future update. After i implemented an ult type for them, there will be support for percentages too. For now you can just share them as a raw value. But i mean, your RL should know what sets you are wearing anyway right? 😄

A special thanks to @BloodStainChild666 and @seadotarley for the long testing periods :D

### Changelist:
- changed sharing to points instead of percentages
- updated menu to reflect changes
- adding new "Ultimates" window that allows showing and sharing of all ultimates your heart desires
- adding option to show percentage and raw ult points for every window separately

## 1.10.0 - @m00nyONE
- enable V2 sharing for everyone & delete old V1 sharing. Adding new ultimates to share will begin in the next release
- raise required LibDataShare version to 3 to ensure to fix incompatibility issues introduced with the with new sharing system
- as requested, allow players to disable the outdated LibAddonMenu2.0 dependency warning in the settings menu. There will be no support if this setting is turned on.
- added /hodor version
- added /hodor isIncompatibleDependencyWarningDisabled
- added /hodor isIncompatibleDependencyWarningTriggered
- add README.md for the git repository
- necrom API bump
- add Sanity's Edge to mock zones
- add arcanist Christmas class icon

## 1.9.9-1 @m00nyONE
- fixed an issue that would not allow installation via Minion because the zip file was the root directory and did not contain the folder "HodorReflexes"

## 1.9.9 - @m00nyONE
- Because of the upcoming release of HodorReflexes 1.10.0 on 07. May 2023, this version ( 1.9.9 ) will include a timer that auto enables V2 sharing on 30. April 2023 for everyone. This ensures 1.9.9 & 1.10.0 use the same sharing mechanism and will work together. This should give everyone enough wiggle room to make the update to 1.10.0 without losing compatibility.
- enable dependency warning for everyone that warns the user when outdated embedded versions of LibAddonMenu are detected ( just remove this dumb shit pls. Hodor is not the only addon that has issues with these kinds of outdated addons )

## 1.9.8 - @m00nyONE
- testing phase for new encode & decode functions
- adding BETA section to the Hodor menu
- option to enable/disable V2 sharing

## 1.9.7 - @m00nyONE
- implementing separate encode & decode functions for sharing
- getting ready for Hodor 1.10.0 with more ults & improved sharing

## 1.9.6 - @m00nyONE
- api bump U37
- restoring missing files

## 1.9.5 - @m00nyONE
- icon update

## 1.9.4 - @m00nyONE
- add menu to control events - will be expanded later if needed. currently you can only enable/disable them all together.
- add valentine event ( replaces class icons of players without a custom icon with randomly colored hearts & other valentine's day related stuff <3 )
- folder & file refactoring

## 1.9.3 - @m00nyONE
- deduplication

## 1.9.2 - @m00nyONE
- adding missing mock zones
- update german translation

## 1.9.1 - @m00nyONE
- deduplicate some files
- add april fools event ( you will see what it does )

## 1.9.0 - @m00nyONE
- adding event Module which is also extensible for future use
- adding Christmas event ( puts small Christmas hats over the class icons of players without custom icon )
- Christmas icon update 23.12.2022

## 1.8.48 - @m00nyONE
- nothing special

## 1.8.47 - @m00nyONE
- fix damaged files in zip that caused some icons to not be included anymore even though they showed up as files in the directory's

## 1.8.46 - @m00nyONE
- adding zh (simple chinese) translation - thanks to @Max_Darav & @Blessing-quan

## 1.8.45 - @m00nyONE
- TODO update
- adding ticket system for icon requests for better organization

## 1.8.44 - @m00nyONE
- nothing special
- 
## 1.8.43 - @m00nyONE
- adding TODO.md list

## 1.8.42 - @m00nyONE
- nothing special

## 1.8.41 -@m00nyONE
- nothing special

## 1.8.40 - @m00nyONE
- small fix for an infinite eventloop ( thanks to @Ik0 )

## 1.8.39 - @m00nyONE
- API Bump to U36 (Firesong)

# MAINTAINER SWITCH to @m00nyONE
 - new update intervals ( once very 2 weeks from now on )

## 1.8.38
- nothing special

## 1.8.36
- Updated french translation (thanks to @XXXspartiateXXX).

## 1.8.35
- Icon pack update.

## 1.8.34
- High Isle API bump and new icons (as is tradition).

## 1.8.33
- Added support for Turning Tide and Nazaray item sets.

## 1.8.32
- Removed some icons to avoid possible sanctions.

## 1.8.31
- 2022 winter icon pack update.

## 1.8.30
- API bump for Ascending Tide DLC.
- Added a new dependency [URL="https://www.esoui.com/downloads/info3297-LibDataShare.html"]LibDataShare[/URL] to allow other addon authors share small amounts of data in a more convenient way rather than using the very limited Hodor Reflexes' internal function SendCustomData (it still works, though). Check the library's page for more details. This change shouldn't conflict with older Hodor versions, but if you run into any issue, you can rollback and let me know about it.

## 1.8.29
- Updated the default Donation mail text to better indicate that it's a donation, not a payment for any in-game on non-game item.
- Increased the minimum donation amount (gold only) to get a personal icon. Two main reasons for this are: 1) prolonged "transitory inflation" on both PC servers (3mil gold is not the same as last time I set this number :/); 2) While technically there is no limit to the number of icons in the addon, there is still a limit to my physical abilities to add new and update old icons, which I do in my free time. Unfortunately every icon and custom name has to be checked for quality and to be made sure they don't break TOS. Hopefully this measure can curb the demand a bit and keep icons nice and unique.

## 1.8.28
- Added an option to hide damage list during combat (or just boss fights) for easily distracted dps monkeys.

## 1.8.27
- Removed LibMapPing dependency to avoid some possible random issues related to active instance resets and pings not tracked properly.
- Added support for Kynmarcher's Cruelty set (new major vulnerability source).

## 1.8.26
- Fixed the issue of old data not being hidden after removing players from group due to sneaky ESO API changes.

## 1.8.25
- Hotfix for new LibMapPing version, which also requires LibDebugLogger now, so make sure you have both libs.

## 1.8.24
- API version bump for Deadlands DLC.
- Icon pack update 10/29/2021.

## 1.8.23
- Updated spanish translation by @loneloba.

## 1.8.22
- Icon pack update 9/20/2021.

## 1.8.21
- Optimized a bunch of old icons and greatly improved the quality of catJAM animation (arguably the most important change so far).

## 1.8.20
- Keybind to toggle DPS sharing is back.

## 1.8.19
- Added a setting to configure timers' opacity when they reach 0.0 seconds (Hodor Reflexes - Style -> War Horn -> Expired timer opacity). This setting applies to all timers and icons in the dps/ult lists.
- Additionally, these timers blink now when their respective buffs run out ("Blinking timers" checkbox right under the experied timer setting).

## 1.8.18
- Added Saxhleel Champion set support (experimental and still testing). You can choose to share the ultimate with the highest cost or simply 250 points (here is the tricky part, because everybody might have different preference when to send "100%" to optimize Major Force uptime from Saxhleel, but these are the only two options for now). This setting replaced "Share Ultimate" (War Horn) checkbox and made it a dropdown.

## 1.8.17
- Removed some outdated files from the addon folder, reworked README in the Icon settings and added a (hopefully) comprehensive guide on how to get a custom icon in the addon.
- Increased required donations to get a custom icon by 1mil, because it's getting more time consuming than intended with 1000+ icons around, especially during hot summer days ;)

## 1.8.16
- UI error.

## 1.8.15
- Changed ultimate % calculation for the [100..200]% range. Now 200% means a player has 500 ultimate points regardless of his ultimate cost. This is mainly done to solve an issue when vampires could never reach 200% because of their higher ultimate cost, so now the race between players with different ultimate costs should be more fair :)

## 1.8.14
- Added separated countdowns for War Horn and Major Force to handle the new Saxhleel Champion set. Replaced text labels with abilities' icons to be able to fit both countdowns. Text colors can be changed in Hodor Reflexes - Style menu.

## 1.8.13
- API bump for Blackwood and LibCombat version update.
- Clarified the error message for a missing icon. You also need to restart the game after reinstalling the addon (I guess it wasn't obvious enough).

## 1.8.12
- Added current player icon to the "addon updated" window if he has one.
- Added additional check if player icon is successfully loaded and chat error message if it's not (Minion bugs won't stop giving me extra work, huh).

## 1.8.11
- Added italian translation. Grazie mille, @Dusty_82.

## 1.8.10
- API version bump for Flames of Ambition.
- Improved compatibility with Bandits User Interface, so it shouldn't occasionally interfere with random DPS numbers.

## 1.8.9
- Reduced countdowns' update time to 100ms for smoother experience.

## 1.8.8
- The addon now won't bother you with horn and colossus notifications during duels, if you are in a group.
- Increased gold prices for icons to bring them in line with inflated market prices for items and crowns. Plus, I want to actually spend more time improving my addons than managing icon requests. Thanks for your understanding and everyone who has supported me so far :)

## 1.8.7
- Added animation for countdowns to make them more noticeable (can be disabled in Style menu).
- You will now see a window with 5 icons right after installing/updating the addon to (almost) make sure all addon files have been downloaded via Minion (which drives me crazy). If you don't see any of them, then download again.

## 1.8.6
- Updated spanish translation (thanks to @loneloba).
- All controls are not movable by default anymore to prevent random change of position when clicked. Use "UI Locked" setting to unlock them.

## 1.8.5
- Updated LibAddonMenu and LibCombat required versions, make sure to have them both updated.
- Changed Donate button in the addon settings to automatically fill the mail with my @name, your Discord and some sample text. "Visit Website" now leads to this page instead.

## 1.8.4
- Added missing group menu buttons into Gamepad Mode.
- Added an option to disable mocking hints for sensitive souls.

## 1.8.3
- Adjusted Icon Preview to match the width of DPS list, so it's easier to figure out if a long name is going to be cut off.

## 1.8.2
- Added "Exit Instance Immediately" hotkey, which doesn't require the group window to be open to work. Also it's possible to disable confirmation dialog in addons settings -> Hodor Reflexes -> Confirm Instance Exit (doesn't affect the default button).

## 1.8.1
- Major Force is back.

## 1.8.0
- Updated Colossus duration to 12s. Timer updates every hit.
- Added a hotkey for group leaders to port everyone out of the current instance immediately. By default it asks for confirmation on both sides, which can be disabled in settings (Confirm Instance Exit), if you trust your group leader. Note: ZOS added a button "Leave Instance" in the group window to port yourself out, if you want to do it just yourself.
- Moved Icon and Style settings into Account Wide Settings. It means you don't need to setup the look of your ult/dps lists on each character separately anymore. But it will ignore your current settings, if you don't have Account Wide Settings enabled (so need to configure them again, sorry).
- Changed the way data is encoded (ultimate and dps numbers) to potentially fix conflicts with other addons once and for all (no more weird numbers in HoF, hopefully). It means this addon version is incompatible with all previous versions, so tell everyone to update!

## 1.7.12
- Reworked icon preview in the addon settings. Added gradient generator and made it possible to make changes directly to LUA code. The preview doesn't affect dps/ult lists anymore (it was too confusing for many people who already had icons), but you can just copy the LUA code into any .lua file inside HodorReflexes/users directory to make it work.

## 1.7.11
- Reworked ready check countdown. Now they are two separate things. It means you can start a countdown without initiating a ready check (only if you are the group leader). There are multiple ways to do it: bind a key, from the group window, from the chat box (/pull 5), from the addon settings (Vote menu). In the Vote menu you can also select default countdown duration (from 3 to 10 seconds, everything out of this range will be ignored). IMPORTANT: all group members must have the latest addon version to see the countdown!
- Updated french translation (thanks to @Floliroy).

## 1.7.10
- Restructured icons folder in attempt to fix an occasional bug when Minion doesn't download some subfolders. Made paths shorter, so it also reduced config files a little.
- Removed keybinds to Toggle Horn / Colossus share, since they have been obsolete (ultimates are automatically shared when they are slotted).
- API bump for PTS.

## 1.7.9
- Removed fractions from total dps numbers to free one bit of data for future needs and to make more space for player names.
- Improved death recap hints in trials.
- LibCombat version update.

## 1.7.8
- Updated russian and japanese language translations.
- The addon has become slightly more toxic.

## 1.7.7
- Added an option to hide players' map pings on the world map and compass (Hodor Reflexes - Style menu). They are hidden by default, since they are pretty annoying and useless for players anyway when using this addon.
- Reduced the length of some strings in the french translation.
- Added DPS debuff for those who are using CannaReflexes addon. Please, consider supporting the author of the original addon if you want other people to see your icon ;)
- Increased the price for a custom static icon up to 1mil gold for multiple reasons (and greed is none of them):
- - There are almost 1000 icons in the addon (which doesn't affect performance since they are loaded only when their owners are in your group) and I think it's more than enough already.
- - Although most people who requested icons for their friends had good intentions, some of them did it to "prank" their friends. I don't want the addon to become a tool to troll other people, but I also don't want to remove the ability to gift other people custom icons. So maybe a higher price will make jokers think twice ;)
- - The overall quality of icons is getting a bit worse (at least in my opinion). I think nobody likes to see poorly designed images and colored names, so I expect people to choose icons more carefully now that they are more expensive (or maybe I'm being naive).

## 1.7.6
- API bump for Stonethorn.
- Updated dependencies' versions (the latest version of LibAddonMenu fixes the issue with invisible russian fonts in the addon settings).

## 1.7.5
- Added Japanese translation (thanks to @naechan)

## 1.7.4
- The addon is now automatically disabled in PvP zones. You can enable it again in the settings.

## 1.7.3
- Fixed a small display bug caused by long user names.
- Fixed some errors in german translation (by Freebaer).

## 1.7.2
- Added German translation (thanks to muh)
- Added French translation (thanks to Castel)
- Added Spanish translation (thanks to MuscleGeek502)
- Optimized damage list for easier access from other addons.

## 1.7.1
- Added multi-language support. Currently the addon is only translated to russian, but if anyone who is reading this wants to translate it to another language, then use lang/new.lua file as a template. From my side I can offer a free icon in the addon :)

## 1.7.0
- Updated LibCombat required version. The latest version should fix "stuck" dps on Nahviintaas for portal runners.
- Removed Harrowstorm API version.

## 1.6.9
- Fixed a bug when data stopped sharing after changing a subzone.

## 1.6.8
- Removed LibGPS dependency (hence LibDebugLogger and LibChatMessage too). Now the addon won't send and process data pings while the world map is open, but it "should not" be an issue, so it's an experimental change to address recent issues with LibGPS and conflicts with other addons containing an old version of it.

## 1.6.7
- Updated the required libraries' versions. Make sure to have the latest versions of LibCombat and LibGPS and their dependencies.
- "Use custom icon" and "Use custom name" addon options are now automatically disabled whenever the addon is updated to avoid confusion when people don't see their newly added icons.

## 1.6.6
- API bump for Greymoor.
- Auto disable Piece of Candy data sharing when Hodor Reflexes is enabled.

## 1.6.5
- Added a countdown for War Horn/Major Force similar to the colossus countdown. By default it notifies you to use a horn if you have it ready, but it can be changed to major force and also to show a notification if there is any horn ready in the group (useful for raid leaders).

## 1.6.4
- Don't send too small (zero) dps.

## 1.6.3
- Added the check for currently slotted ultimates. War Horn and Colossus won't be shared if they are not slotted.

## 1.6.2
- Updated dependencies' versions.

## 1.6.1
- Added "Hodor Reflexes - Style" menu in Settings -> Addons. You can change damage numbers font and some colors there for now.

## 1.6.0
- Reworked the sharing mechanism (now Vvardenfell map is used for pings, because it allows to transfer more data). Therefore this version is incompatible with previous versions and all group members must update.
- Restyled lists, added both Boss DPS and Total DPS to the damage list. No more people with different types of damage!

## 1.5.5
- Restyled Damage List.
- Replaced name highlight with row highlight. The reason for this is that many players have custom name colors, so it's hard to actually see yourself in the damage list sometimes. You still can color your name in the Hodor Reflexes - Icons menu.

## 1.5.4.
- API Bump for Harrowstorm DLC.
- Removed LibCombat from the addon, since it's a standalone library now.
- Updated required libraries versions. Make sure to have all needed libraries installed and updated.

## 1.5.3.
- Updated "Hodor Reflexes - Icons" menu.

## 1.5.2.
- Added an option to disable only animated icons, but keep normal icons.

## 1.5.1.
- Added a new option "Never" for Colossus Priority, which will always send 99% instead of 100%+

## 1.5.0.
- Colossus timer now shows the remaining duration of Major Vulnerability Invulnerability (yes, this is how the immune effect is called in game :D) on bosses and only on bosses. There are 2 reasons for it: 1) mobs have 20s immunity to major vulnerability and most likely will die before the immunity ends; 2) during boss fights someone can drop a colossus on adds, but the main priority is to keep maximum uptime on bosses. There is one exception though: any combat in a house is considered a boss fight.
- LibCombat update.

## 1.4.12.
- Fixed an issue when you couldn't preview a new custom icon if you already have an icon in the addon.

## 1.4.11.
- War Horn icon can now be resized with mousewheel.
- Disabled RuESO double NPC names when the addon is enabled, because it breaks CMX boss fight detection.
- LibCombat update.
- API bump for Dragonhold.

## 1.4.10.
- Added combat time to DPS list.
- Horn icon now always shows when your horn is ready, but it has yellow border instead of green, if you are not first in the horns list. Don't forget to announce your horn in this case to avoid double horn!
- Changed Boss DPS formula to match Combat Metrics. Now you will start Nahviintaas fight with much bigger numbers!

## 1.4.9.
- Changed the distance calculation formula introduced in the previous version for a faster and more precise one (thanks to g4rr3t).

## 1.4.8.
- Added a notification for players who share war horn. First player in the horns list will see an icon with a number of players in his horn range when his ultimate is ready and major force is not active. Also if all DDs are in the horn range, the icon will turn green. No more wasted horns when you were 22 meters away instead of 20!

## 1.4.7.
- Ready Check duration is now 10s and extended by 5s after each positive vote to prevent situations when people are afk and can't vote (they need to have this addon enabled to automatically decline).

## 1.4.6.
- Removed LibStub from dependencies.

## 1.4.5.
- Account wide settings are disabled by default now.
- You don't need to unlock UI to move lists anymore while you are in a group.
- All timers are updating every 0.2s instead of 0.1s and slightly more precise.
- Your ultimate cost is now calculated only when you enter combat or reload UI. So if you are switching sets which affect the cost, your ultimate % won't be updated instantly.

## 1.4.4.
- Removed "Send Rate" setting. It's adjusted automatically now.
- Ultimates and Damage lists are now updated separately (not within the same game frame). The update frequency remained the same.
- Reworked the testing feature. It can be only used outside a group now. Type in chat: "/hodor.share test" to run/stop it.
- Code optimization.

## 1.4.3.
- Fixed an error caused by PerfectPixel addon when reloading UI from the icons panel.

## 1.4.2.
- Fixed an issue when you could not see Total or Boss DPS in Asylum Sanctorium while fighting side bosses.
- Ready Check automatically stops after 15 seconds if somebody hasn't voted.

## 1.4.1.
- Fixed an issue when you could have too many Countdown buttons in the group window.

## 1.4.0.
- Added module "Vote". It improves default ready check by showing who is ready and who is not if all group members have Hodor Reflexes enabled.

## 1.3.8.
- Improved support for animated icons.
- Increased icons sizes in the lists by 2px.

## 1.3.7.
- Fixed a conflict with Bandits Gear Manager.

## 1.3.6.
- Added support for animated icons.

## 1.3.5.
- Combat Metrics is not required anymore to share DPS. If it's disabled, then Hodor Reflexes will use the same library as Combat Metrics to calculate DPS, so numbers will remain the same.

## 1.3.4.
- Fixed conflicts with some other ultimate/dps sharing addons.

## 1.3.3.
- API bump for Scalebreaker.
- Added comprehensive instructions on how to make a custom icon in the addon settings (Hodor Reflexes - Icons).
- Custom colors are now visible in all lists (dps/horn/colossus), but also made it possible to disable them in the addon settings (Hodor Reflexes - Icons).

## 1.3.2.
- Added keybindings to toggle horn/damage/colossus sharing. You can assign keys in Controls -> Hodor Reflexes.

## 1.3.1.
NOTE: This version is not fully compatible with previous versions, so tell your friends to update this addon too!
- Changed colossus icon to a much more noticeable text countdown. You can adjust its color and text, but not the size, because it's supposed to be pretty visibile :p
- Colossus list now updates immediately when somebody uses a colossus.
- Necromancer tanks now have priority in the colossus list, because they are gaining ultimate faster. If a necro tank gets 100% ultimate, then he will send 201% instead to always appear on top of the list. It can be changed back to normal in the addon settings.
- Made some changes to the setting that removed necros from the colossus list when they were out of group support range. Now it's slightly smarter. E.g. on the side bosses in Sunspire all people are considered to be in support range even if they are on another side of boss room.
- Made active War Horn text more colorful.

## 1.2.0.
NOTE: This version is not fully compatible with previous versions, so tell your friends to update this addon too!
- Added Colossus ultimate share (you need to enable it in settings).
- Added an option to switch between account wide settings and character settings.
- Added an option to disable custom icons.
- Restructured addon settings for easier navigation.

## 1.1.11.
- API bump for Elsweyr.
- Set default damage type for Sunspire to "Total DPS".

## 1.1.10.
- Added colors for damage types, so you can see if someone in the group is sharing a different type from yours (green = boss dps, yellow = total dps).
- The addon doesn't take damage from Combat Metrics history anymore when players are out of combat. No more loading a good parse and sharing it ;)
- When a player enters combat, his damage in the list will be reset until he does "new" damage.

## 1.1.9.
- Added an option to update war horn duration when any group member receives the buff. By default it shows the remaining horn duration only on you.

## 1.1.7.
- Decreased refresh rate of UI elements (can possibly help to players with a lot of stuff on their screens).
- Added a setting to customize how often you will send data to other players. I recommend to keep low values for healers/tanks (2000-3000ms) and higher values for DDs (3000ms should be optimal), if you believe that too frequent pings affect game performance.

## 1.1.5.
- The ultimates list now shows the remaining duration of major force / war horn. You can disable it in settings (enabled by default).

## 1.1.4.
- Players will send Total DPS if they are inside a house (for raid dummy tests).

## 1.1.2.
- Added an option to disable the addon from the addon settings.
- Added an option to choose what type of dps to share on bosses (single or total). It is set to "Auto" by default. In trials like AS, CR and BRP the addon will send AoE dps on bosses, and in other trials it will send boss dps only.
- Changed dps on trash to total damage done (in millions), because in many situations dps on trash is irrelevant. Some players can start doing damage later and get bigger numbers, while their total damage done will be lower.
- The title of the damage list now says what type of damage players shared (if everyone has the same damage type). If players have different type of damage, then the title will be just "Damage:".

## 1.1.1.
- Fixed class icons for non-english clients.

## 1.1.0. Initial release.