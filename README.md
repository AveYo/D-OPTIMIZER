## ARCANA HOTKEYS II for Dota 2 - AVEYO's D-OPTIMIZER V3 (cc)
### SPACE Modifier, QuickCast Enhancements, Multiple Chatwheels, Camera Actions, Panorama Keys
### [Also available on Dota 2 Guides](http://steamcommunity.com/sharedfiles/filedetails/?id=408986743)  
![Arcana Hotkeys](https://cloud.githubusercontent.com/assets/12874843/19415619/1b6efa54-937e-11e6-9412-e74485c4f965.png)

## WHAT IS THIS:  
It's an addon - like a custom game, it uses it's own vpk, that contains just one panorama keys cfg, one dota keys cfg, one help-page xml and one help-page css callable from the panorama keys cfg.  
To make it really easy to switch on/off and also to be compatible with other languages, it uses the dota_lv as it's base folder. 
Adjusted panorama language settings for the various GUI changes are dropped there too. 
Adding/removing -lv launch option enables/disables it.  

## WHAT'S NEW:
- still 100% in GUI, not needing manual edit of cfg files
- distinct QuickCast (made primary) and Cast keys supported
- removed alien concepts like CastControl and QuickLearn-once (so SPACE + Ability/Item does directly Cast by default)
- more SPACE+ actions, even if there are 12 less usable keys now (by hardcoding chatwheel builder to keypad)
- reorganized toggles and camera control keys (added follow courier, then return to hero action)
- legacy keys still supported
- patch lowviolence particles - "alien blood"	(only the m_hLowViolenceDef = * line is removed)
- added a fast fix for the older, still functional bot matches page
- redesigned help page (F10) - Panorama dynamic layout: mastered :D

## HOW TO INSTALL:  
If you are on Windows, the batch file is recommended for hassle-free installation. Plus it's 100-times smaller.  
Doing it manually is not too difficult either, only two steps required:  
- [ ] add Dota 2 Launch Option: -LV
- [ ] unpack and copy the zip file content to your steamapps folder where Dota 2 is installed  

**\steamapps\common\dota 2 beta\game\dota_lv\** should now contain _pak01_dir.vpk_ and the _panorama_ subfolder with the language files.  
_This probably works on Linux and Mac too..._

---

**Important notice to Valve:** most definitely rhetorical  
 Instead of killing legit scripts that bring mostly ergonomic features, why not hunt down actual, reactive cheats from the Ensage family instead - it's been years! Just follow the money...  
 You've killed autoexec.cfg months ago, and still haven't delivered on GUI alternatives for many features that users have developed and got used to over the years.  
 But why do that in the first place?! How hard is to parse a +/- alias and just block multiple distinct abilities+items? Armlet toggling? it should have been nerfed years ago on the backend.  

**Important notice to Modders:** while this is not strictly VAC-safe,  
 it should be as long as there are no multiple {**distinct**} abilities/items per {**single**} hotkey.  
 Auto-Invoke, blink-call/duel, and any other ability and/or item combo scripts will always be illegal!  
 Please refrain from adding any of that!  
 D-OPTIMIZER does not condone cheating in any way so don't even ask about it!
