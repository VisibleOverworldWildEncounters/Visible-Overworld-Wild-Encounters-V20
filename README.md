# Visible-Overworld-Wild-Encounters

* Visible Overworld Wild Encounters Version 20.0.0.3 for PEv20 - by derFischae (Credits if used please)

This script is for Pokémon Essentials v20 and v20.1 (for short PEv20). UPDATED TO VERSION 20.0.0.2 FOR PEv20.

As in Pokemon Let's go Pikachu/Eevee or Pokemon Shild and Sword wild encounters pop up on the overworld, they move around and you can start the battle with them simply by moving to the pokemon. Clearly, you also can omit the battle by circling around them.


### FEATURES
- Easy Install as Plugin
- see the pokemon on the overworld before going into battle
- no forced battling against overworld encounters
- Supports individual sprites for shiny, female and alternative forms
- plays the pokemon cry while spawning
- Overworld pokemon will despawn after some steps
- you can have instant wild battle and overworld spawning at the same time and set the propability of that in percentage
- In caves, pokemon don't spawn on impassable Rock-Tiles, which have the Tile-ID 4 
- In water, pokemon won't spawn above other tiles, which made them stuck or walk on ground
- See "advanced features" and "additional features by add-ons" below for more (e.g. additional animations...)

### INSTALLATION
Installation as simple as it can be.
1. Add Graphics: Either get the resources from Gen 8 Project https://reliccastle.com/resources/670/
  and install the "Graphics/Characters" folder in your game file system.
  Or you place your own sprites for your pokemon/fakemon with the right names in your "\Graphics\Characters\Follower" folder and your shiny sprites in your "\Graphics\Characters\Follower shiny" folder. 
  The right name of sprites is:
    usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
    alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
    female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
2. Add Script: Follow this link https://github.com/VisibleOverworldWildEncounters/V20 and copy the folder "Visible Overworld Wild Encounters - Script" to your "/plugins/" folder.
3. Change Settings: Open the script file in the folder and change the parameters in the settings section therein as you like. Details descriptions about the parameters can be found there as well. 
4. Install Add-Ons (the other folders): There are a lot of Add-Ons and parameter settings for your personal optimal solution. So, Copy Add-Ons in your "/plugins/" folder and edit parameters in settings of that Add-Ons to your liking. Some Add-On and parameter combinations can produce lag, e.g. a high spawning rate without a spawning cap, or e.g. "NO_OF_CHOSEN_TILES=0" (or too high) when having other scripts like Pokemon Following.
5. Enjoy!

### HELP AND MORE 
If you need help, found a bug or search for more modifications then go to https://www.pokecommunity.com/showthread.php?t=429019

### ADVANCED FEATURES
- Set the size of the area around the player where pokemon can spawn
- Choose whether encounters occure on all terrains or only on the terrain of the player
- Allow or forbid water pokemon to spawn on border
- Set movement of overworld pokemon depending on its properties
- Choose whether you can battle water pokemon while not surfing or not
- set steps a pokemon remains on map before despawning depending on pokemon properties 
- You can check during the events :on_wild_species_chosen, :on_wild_pokemon_created, :on_calling_wild_battle ... if you are battling a spawned pokemon with the global variable $PokemonGlobal.battlingSpawnedPokemon
- You can check during the events :on_wild_species_chosen and :on_wild_pokemon_created if the pokemon is created for spawning on the map or created for a different reason with the Global variable $PokemonGlobal.creatingSpawningPokemon
- If you want to add a procedure that modifies a pokemon only for spawning but not before battling then you can use the Event :on_wild_pokemon_created_for_spawning
### ADDITIONAL FEATURES BY ADD-ONS
- Additional Animations Add-On
  - manage different appear animations of overworld spawning encounters depending on encounter type and pokemon properties
  - Play animations while PokeEvent is visible on screen, such as a shiny animation
  - See also the animations by TrankerGolD for aggressive encounters, water encounters, and shiny encounters https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383
- Aggressive Encounters Add-On
  - introduces aggressive encounters, which are pokemon that chase the player after spawning
  - aggressive encounters may only start to chase if the player comes them to close
  - set the move speed, move frequency and move type of aggressive pokemon
  - aggressive ecounters are restricted to player movements
  - add animations to aggressive encounters. See Additional Animations -Add On and TrankerGolD's animations for aggressive encounters at https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383 to include spawning animations in your game
- Different Spawn And Normal Encounters (like in Pokemon Sword/Shield) Add-On
  - Introduces Overworld Encounter Types you can set in your encounters.txt PBS-file.
  - This allows you to define different encounters for overworld spawning and instant battling on the same map.
- Reroll Spawn Tile Add-On
  - stabilizes the probability of spawning on maps with low grass by choosing another tile if the previous random chosen one does not allow spawning  
  - set the maximal number of tiles chosen for spawning in parameter NO_OF_CHOSEN_TILES
  - be careful, it might produce lag with other scripts
- Max Spawn Add-On
  - Define a maximal limit of spawned pokemon on the overworld at the same time.
  - After reaching that limit MAX_SPAWN no pokemon will spawn until another pokemon despawned.
- Additional Despawn Methods Add-On
  - Choose to remove PokeEvent distanced on screen from the player with REMOVE_DISTANCED
  - The distance (steps) is edited in DISTANCE_VANISH and DISTANCE_VANISH_SHINY
  - Remove by time chronometer with REMOVE_PROLONGED
  - Use your own overworld spawn chance in VISIBLE_ENCOUNTER_PROBABILITY
- Own Minimum Spawn Chance Add-On
  - The Spawn probability of the first encounter and later ones are similar.
  - Spawning does not interact with the encounter chance for normal encounters.
  - Increase the average spawning time of pokemon by setting MAX_ENCOUNTER_REDUCED larger than zero in the settings section of this script
- Fixed Spawn Probability Add-On
  - Define your own overworld spawn chance in Percentage
  - Spawn chance becomes independent from the default PEv20 encounter chance calculator
- Variable Spawn/Normal Encounter Proportion During Game Add-On
  - let's you change the percentage between overworld spawning pokemon and normal encounters during playthrough
  - You can get and change the current instant battle probability by using getInstantChance and setInstantChance(value) in an event on the map.
- Automatic Spawning Add-On
  - Choose whether pokemon spawn automatically or only while moving the player
  - Set the speed of automatic spawning
- Randomized Spawning Add-On
  - It will randomize overworld encounters
- Ditto Transform Add-On
  - Like in Pokemon Go, transformable Pokemon such as Ditto get the overworld appearence of different species
  - Choose in settings if completely random, set by a list of candidates or set by the map encounters
- Remove Poke Events on load/save/transfer Add-On
  - Remove overworld encounters on load/save and on map transfer
- Overworld Lavender Town Ghosts Add-On
  - Shows ghost sprite for overworld encounters
  - requires Lavender Town Ghosts Plugin 
  - You need to put a graphic, named "ghost.png", in your "/Graphics/Characters/" folder of your project. This graphic is not provided here, but maybe you can easily find some resource, for example search for "shiny missingNo [Ghost Form]".

### CHANGELOG
NEW FEATURES FROM VERSION 20.0.0.3 FOR PEv20:
 - removed bug concerning battling water encounters from shore in PEv20

NEW FEATURES FROM VERSION 20.0.0.2 FOR PEv20:
 - removed bug concerning renaming $MapFactory in PEv20

NEW FEATURES FROM VERSION 20.0.0.1 FOR PEv20:
 - updated v19.1.0.4 to make it compatible with PEv20

NEW FEATURES FROM VERSION 19.1.0.4 FOR PEv19:
 - rearranged aggressive encounters as an Add On

NEW FEATURES FROM VERSION 19.1.0.1 FOR PEv19:
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
  - included vendilys rescue chain, i. e. if pokemon of the same species family spawn in a row and will be battled in a row, then you increase the chance of spawning an evolved pokemon of that species family. Link: https://www.pokecommunity.com/showthread.php?t=415524
  - removed bug occuring after fainting against wild overworld encounter
  - for script-developers, shortened the spawnPokeEvent method for better readablitiy
  - removed bugs from version 1.9
  - added shapes of overworld encounter for rescue chain users
  - supports spawning of alternate forms while chaining
  - if overworld sprites for alternative, female or shiny forms are missing, then the standard sprite will be displayed instead of an invisible event
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
