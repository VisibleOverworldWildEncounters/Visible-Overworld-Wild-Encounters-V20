# Visible-Overworld-Wild-Encounters

* Visible Overworld Wild Encounters Version 19.1.0.2 for PEv19.1 - by derFischae (Credits if used please)

UPDATED TO VERSION 19.1.0.2 FOR POKEMON ESSENTIALS V19.1. This script is for Pokémon Essentials v19 and v19.1 (for short PEv19).

As in Pokemon Let's go Pikachu/Eevee or Pokemon Shild and Sword wild encounters pop up on the overworld, they move around and you can start the battle with them simply by moving to the pokemon. Clearly, you also can omit the battle by circling around them.


### NEW FEATURES
- Easy Install as Plugin
- Set movement of overworld pokemon depending on its properties
- set steps a pokemon remains on map before despawning depending on pokemon properties 
- Choose whether you can battle water pokemon while not surfing or not
- In water pokemon won't spawn above other tiles, which made them stuck or walk on ground
### UPSCALED FEATURES INCLUDED from PEv18:
- see the pokemon on the overworld before going into battle
- no forced battling against overworld encounters
- plays the pokemon cry while spawning
- Choose whether encounters occure on all terrains or only on the terrain of the player
- you can have instant wild battle and overworld spawning at the same time and set the propability of that by default and change it ingame and store it with a $game_variable
- In caves, pokemon don't spawn on impassable Rock-Tiles, which have the Tile-ID 4 
- You can check during the events @@OnWildPokemonCreate, @@OnStartBattle, ... if you are battling a spawned pokemon with the global variable $PokemonGlobal.battlingSpawnedPokemon
- You can check during the event @@OnWildPokemonCreate if the pokemon is created for spawning on the map or created for a different reason with the Global variable $PokemonGlobal.creatingSpawningPokemon
- If you want to add a procedure that modifies a pokemon only for spawning but not before battling then you can use the Event @@OnWildPokemonCreateForSpawning.
### ADDITIONAL FEATURES BY ADD-ONS:
- Additional Animations Add-On
  - manage different appear animations of overworld spawning encounters depending on encounter type and pokemon properties
  - Play animations while PokeEvent is visible on screen, such as a shiny animation
  - See also the animations by TrankerGolD for aggressive encounters, water encounters, and shiny encounters https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383

- Different Spawn And Normal Encounters (like in Pokemon Sword/Shield) Add-On
  - Introduces Overworld Encounter Types you can set in your encounters.txt PBS-file.
  - This allows you to define different encounters for overworld spawning and instant battling on the same map.
- Max Spawn Add-On
  - Define a maximal limit of spawned pokemon on the overworld at the same time.
  - After reaching that limit MAX_SPAWN no pokemon will spawn until another pokemon despawned.
- Additional Despawn Methods Add-On
  - Choose to remove PokeEvent distanced on screen from the player with REMOVE_DISTANCED
  - The distance (steps) is edited in DISTANCE_VANISH and DISTANCE_VANISH_SHINY
  - Remove by time chronometer with REMOVE_PROLONGED
  - Use your own overworld spawn chance in VISIBLE_ENCOUNTER_PROBABILITY
- Fixed Spawn Probability Add-On
  - Define your own overworld spawn chance in Percentage
  - Spawn chance becomes independent from the default PEv19.1 encounter chance calculator
- Variable Spawn/Normal Encounter Proportion During Game  
  - You can change the percentage between overworld spawning and normal encounters in story driven events during playthrough
  - in Percentage, from only normal encounters to only spawning encounters
- Remove Poke Events on load/save/transfer Add-On
  - Remove overworld encounters on load/save and on map transfer
- Overworld Lavender Town Ghosts Add-On
  - Shows ghost sprite for overworld encounters
  - requires Lavender Town Ghosts Plugin 
  - You need to put a graphic, named "ghost.png", in your "/Graphisc/Characters/" folder of your project. This graphic is not provided here, but maybe you can easily find some resource, for example search for "shiny missingNo [Ghost Form]".


### INSTALLATION
Installation as simple as it can be.
1. Add Graphics: Either get the resources from Gen 8 Project https://reliccastle.com/resources/670/
  and install the "Graphics/Characters" folder in your game file system.
  Or you place your own sprites for your pokemon/fakemon with the right names in your "\Graphics\Characters\Follower" folder and your shiny sprites in your "\Graphics\Characters\Follower shiny" folder. 
  The right name of sprites is:
    usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
    alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
    female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
2. Add Script: Follow this link https://github.com/VisibleOverworldWildEncounters/Visible-Overworld-Wild-Encounters and copy the folder "Visible Overworld Wild Encounters - Script" to your "/plugins/" folder.
3. Change Settings: Open the script file in the folder and change the parameters in the settings section therein as you like. Details descriptions about the parameters can be found there as well. 
4. Install Add-Ons (the other folders): There are a lot of Add-Ons and parameter settings for your personal optimal solution. So, Copy Add-Ons in your "/plugins/" folder and edit parameters in settings of that Add-Ons to your liking. Some Add-On and parameter combinations can produce lag, e.g. a high spawning rate without a spawning cap, or e.g. "NO_OF_CHOSEN_TILES=0" (or too high) when having other scripts like Pokemon Following.
5. If you use any other script that triggers on change of direction of the player, then either 
   - these scripts have to be loaded after this visible overworld wild encounter script, or
   - you have to use the bug fix for OnChangeDirection (See below).
6. Enjoy!


### THE BUG FIX FOR ONCHANGEDIRECTION
In Pokemon Essentials V18.1, it was introduced that normal wild encounter can encounter on turning the direction of your player.
These encounters are normal encounters by default. This behaviour remains in Pokemon Essentials V18 and V19.1.
The visible overworld wild encounter script simply clears everything on change of direction of the player.
This works perfectly well, if you don't want to use any other script that triggers on change direction in your game.
But if not, then you have to place all these scripts have to be loaded after the visible overworld wild encounters script (so the clearing will not effect these scripts).
Or you will have to use this fix:

Open the script editor and go to the visible overworld wild encounter script. Search for the following code snippet
```
          #########################################################
          #                                                       #
          #      0. PART: BUG FIX FOR ONCHANGEDIRECTION           #
          #                                                       #
          #########################################################

#===============================================================================
# (Bug Fix for Events.onChangeDirection)
#   - ChangeDirection will be considered as taking a step
#===============================================================================

Events.onChangeDirection.clear
# Notice that this will clear everything related to onChangeDirection
# (on PEv19.1 there is only one proc, so this entire script must be above
#  any other script by the community that uses it)

Events.onChangeDirection += proc {
  pbBattleOrSpawnOnStepTaken($PokemonGlobal.repel > 0) if !$game_temp.in_menu
}
```
and remove it. Then go to the script folder "/Data/Scripts/012_Overworld" and open "001_Overworld.rb" in your editor. Search for the following code snippet
```
# Start wild encounters while turning on the spot
Events.onChangeDirection += proc {
  repel_active = ($PokemonGlobal.repel > 0)
  pbBattleOnStepTaken(repel_active) if !$game_temp.in_menu
}
```
and 
- either remove that code (to remove that pokemon can encounter on changing the direction of your player)
- or replace it by the following code snippet (to replace normal wild encountering during direction changing by mixed overworld/instant encountering, prefered)
```
# Start wild mixed overworld/normal encounters while turning on the spot
Events.onChangeDirection += proc {
  next if !$game_temp.in_menu
  if pbBattleOrSpawnOnStepTaken($PokemonGlobal.repel > 0) 
    pbBattleOnStepTaken(repel_active) # STANDARD WILD BATTLE
  else
    pbSpawnOnStepTaken(repel_active)  # OVERWORLD ENCOUNTERS
  end
}
```
- or replace it by this following code snippet (to replace normal wild encountering during direction changing by purely overworld encountering).
```
# Start purely overworld encounters while turning on the spot
Events.onChangeDirection += proc {
  next if !$game_temp.in_menu
  pbSpawnOnStepTaken(repel_active) if !pbBattleOrSpawnOnStepTaken($PokemonGlobal.repel > 0) 
}
```

### CHANGELOG
NEW FEATURES FROM VERSION 19.1.0,1 FOR PEv19:
 - easy install as plugin
 - bug concerning roaming pokemon fixed
 - included an easy way to set the steps a pokemon remains on map before despawning depending on pokemon properties 
 - rearranged features of previous version as add-ons, including
    - trigger different appear animations depending on encounter type, shinyness
    - shiny animation while PokeEvent is visible on screen
    - stop more pokemon from spawning with the MAX_SPAWN parameter
    - choose wether remove distanced spawned pokemon or not with REMOVE_DISTANCED parameter
    - choose wether remove by time chronometer or not with REMOVE_PROLONGED
    - added to add your own overworld encounter chance with VISIBLE_ENCOUNTER_PROBABILITY

NEW FEATURES FROM VERSION 19.0.10 FOR PEv19:
 - fixed water pokemon spawning in platform above water tile
 - water pokemon won't appear in the border
 - choose wether battling water pokemon from ground or not with BATTLE_WATER_ON_GROUND parameter
 - stop more pokemon from spawning with the MAX_SPAWN parameter
 - choose wether remove distanced spawned pokemon or not with REMOVE_DISTANCED parameter
 - shiny animation while PokeEvent is visible on screen
 - choose wether remove by time chronometer or not with REMOVE_PROLONGED
 - added to add your own overworld encounter chance with VISIBLE_ENCOUNTER_PROBABILITY

NEW FEATURES FROM VERSION 19.0.9 FOR PEv19:
 - updated script to work with PEv19.1
 - used $PokemonTemp.encounterType to trigger different appear animations
 - added alternative stepcount before vanishining for shiny pokemon

NEW FEATURES FROM VERSION 18.0.8 FOR PEv18:
 - tiny bug fix for $PokemonTemp.encounterType

NEW FEATURES FROM VERSION 18.0.7 FOR PEv18:
 - removed a bug concerning changing the standard form when goining into battle

NEW FEATURES FROM VERSION 18.0.6 FOR PEv18:
  - (hopefully) removed a rare crash concerning character_sprites

NEW FEATURES FROM VERSION 2.0.5 FOR PEv18:
  - removed bug that makes all water encounter vanish

NEW FEATURES FROM VERSION 2.0.4 FOR PEv18:
  - encounters dont spawn on impassable tiles in caves

NEW FEATURES FROM VERSION 2.0.3 FOR PEv18:
  - poke radar works as usual

NEW FEATURES FROM VERSION 2.0.2 FOR PEv18:
  - added new global variable $PokemonGlobal.creatingSpawningPokemon to check during the event @@OnWildPokemonCreate if the pokemon is created for spawning on the map or created for a different reason

UPSCALED FEATURES FROM VERSION 2.0.1 FOR PEv17.2:
  - less lag
  - supports sprites for alternative forms of pokemon
  - supports sprites for female/male/genderless pokemon
  - bug fixes for roaming encounter and double battles
  - more options in settings
  - roaming encounters working correctly
  - more lag reduction 
  - included automatic spawning of pokemon, i.e. spawning without having to move the player
  - included vendilys rescue chain, i. e. if pokemon of the same species family spawn in a row and will be battled in a row, then you increase the chance of spawning
    an evolved pokemon of that species family. Link: https://www.pokecommunity.com/showthread.php?t=415524
  - removed bug occuring after fainting against wild overworld encounter
  - for script-developers, shortened the spawnPokeEvent method for better readablitiy
  - removed bugs from version 1.9
  - added shapes of overworld encounter for rescue chain users
  - supports spawning of alternate forms while chaining
  - if overworld sprites for alternative, female or shiny forms are missing,
    then the standard sprite will be displayed instead of an invisible event
  - bug fix for shiny encounters
  - respecting shiny state for normal encounters when using overworld and normal encounters at the same time
  - easier chaining concerning Vendilys Rescue chain, i.e. no more resetting of the chain when spawning of a pokemon of different family but when fighting with a pokemon of different family
  - Added new Event @@OnPokemonCreateForSpawning which only triggers on spawning
  - Added new global variable $PokemonGlobal.battlingSpawnedShiny to check if an active battle is against a spawned pokemon.
  - removed bug to make the new features in version 1.11 work
  - reorganised and thin out the code to organise code as add-ons
  - removed Vendilys Rescue Chain, Let's Go Shiny Hunting and automatic spawning as hard coded feature and provide it as Add-Ons instead
  - Now, using overworld and normal encounters at the same time is a standard feature
  - autospawning will not trigger instant battles anymore
  - removed a bug that came from reorganising the code in original code and add-ons concerning Let's go shiny hunting add-on

