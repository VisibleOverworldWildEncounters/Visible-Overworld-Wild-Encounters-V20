# Visible-Overworld-Wild-Encounters

* Visible Overworld Wild Encounters Version 19.1.0.1 for PEv19.1 - by derFischae (Credits if used please)

UPDATED TO VERSION 19.1.0.1 FOR POKEMON ESSENTIALS V19.1. This script is for Pokémon Essentials v19 and v19.1 (for short PEv19).

As in Pokemon Let's go Pikachu/Eevee or Pokemon Shild and Sword wild encounters pop up on the overworld, they move around and you can start the battle with them simply by moving to the pokemon. Clearly, you also can omit the battle by circling around them.


### FEATURES
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
  - Shows ghost sprite for overworld encounters, needs Lavender Town Ghosts Plugin 

### INSTALLATION
Installation as simple as it can be.
1. Add Graphics: Either get the resources from Gen 8 Project https://reliccastle.com/resources/670/
  and install the "Graphics/Characters" folder in your game file system.
  Or you place your own sprites for your pokemon/fakemon with the right names in your "\Graphics\Characters\Follower" folder and your shiny sprites in your "\Graphics\Characters\Follower shiny" folder. 
  The right name of sprites is:
    usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
    alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
    female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
2. Add Script: Copy the folder "Visible Overworld Wild Encounters - Script" in your "/plugins/" folder.
3. Change Settings: Open the script file in the folder and change the parameters in the settings section therein as you like. Details descriptions about the parameters can be found there as well. 
4. Install Add-Ons (the other folders): There are a lot of Add-Ons and parameter settings for your personal optimal solution. So, Copy Add-Ons in your "/plugins/" folder and edit parameters in settings of that Add-Ons to your liking. Some Add-On and parameter combinations can produce lag, e.g. a high spawning rate without a spawning cap, or e.g. "NO_OF_CHOSEN_TILES=0" (or too high) when having other scripts like Pokemon Following.
5. If you use any other script that triggers on change of direction of the player, then either 
   - these scripts have to be below this visible overworld wild encounter script, or
   - you have to use the bug fix for OnChangeDirection (See below).
6. Enjoy!


### THE BUG FIX FOR ONCHANGEDIRECTION
In Pokemon Essentials V18.1, it was introduced that normal wild encounter can encounter on turning the direction of your player.
These encounters are normal encounters by default. This behaviour remains in Pokemon Essentials V18 and V19.1.
The visible overworld wild encounter script simply clears everything on change of direction of the player.
This works perfectly well, if you don't want to use any other script that triggers on change direction in your game.
But if not, then you have to place all these scripts below the visible overworld wild encounter script (so the clearing will not effect these scripts).
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
- either remove that code (to remove that pokemon can encounter on changing the direction of your player), or
- replace it by this code snippet 
```
# Start wild overworld/mixed encounters while turning on the spot
Events.onChangeDirection += proc {
  pbBattleOrSpawnOnStepTaken($PokemonGlobal.repel > 0) if !$game_temp.in_menu
}
```
to replace normal wild encountering during direction changing by overworld/mixed encountering (prefered).

### ADD-ONS AND ADDITIONAL RESOURCES FOR THIS SCRIPT:

