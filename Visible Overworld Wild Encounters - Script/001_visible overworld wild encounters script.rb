 #====================================================================#
  #                                                                    #
  #   Visible Overworld Wild Encounters V20.0.0.4 for PEv20 and PEv21  #
  #                         - by derFischae (Credits if used please)   #
  #                                                                    #
  #====================================================================#

# This script is for Pokémon Essentials v20, v20.1, v21 and v21.1 (for short PEv20 and PEv21). UPDATED TO VERSION 20.0.0.4.

# As in Pokemon Let's go Pikachu/Eevee or Pokemon Shield and Sword wild encounters
# pop up on the overworld, they move around and you can start the battle with
# them simply by moving to the pokemon. Clearly, you also can omit the battle
# by circling around them.


#===============================================================================
#            FEATURES
#===============================================================================

#  [*] Easy Install as Plugin
#  [*] see the pokemon on the overworld before going into battle
#  [*] no forced battling against overworld encounters
#  [*] Supports individual sprites for shiny, female and alternative forms
#  [*] plays the pokemon cry while spawning
#  [*] Overworld pokemon will despawn after some steps
#  [*] you can have instant wild battle and overworld spawning at the same time and set the propability of that in percentage
#  [*] In caves, pokemon don't spawn on impassable Rock-Tiles, which have the Tile-ID 4 
#  [*] In water, pokemon won't spawn above other tiles, which made them stuck or walk on ground
#  [*] See "advanced features" and "additional features by add-ons" below for more (e.g. additional animations...)

# ADVANCED FEATURES [/b]
#  [*] Set the size of the area around the player where pokemon can spawn
#  [*] Choose whether encounters occure on all terrains or only on the terrain of the player
#  [*] Allow or forbid water pokemon to spawn on border
#  [*] Set movement of overworld pokemon depending on its properties
#  [*] Choose whether you can battle water pokemon while not surfing or not
#  [*] set steps a pokemon remains on map before despawning depending on pokemon properties 
#  [*] You can check during the events :on_wild_species_chosen, :on_wild_pokemon_created, :on_calling_wild_battle ... if you are battling a spawned pokemon with the global variable $PokemonGlobal.battlingSpawnedPokemon
#  [*] You can check during the events :on_wild_species_chosen and :on_wild_pokemon_created if the pokemon is created for spawning on the map or created for a different reason with the Global variable $PokemonGlobal.creatingSpawningPokemon
#  [*] If you want to add a procedure that modifies a pokemon only for spawning but not before battling then you can use the Event :on_wild_pokemon_created_for_spawning

# ADDITIONAL FEATURES BY ADD-ONS (for PEv19, might be outdated, but feel free to test):
#  [*] Aggressive Encounters Add-On
#    [*] introduces aggressive encounters, which are pokemon that chase the player after spawning
#    [*] aggressive encounters may only start to chase if the player comes them to close
#    [*] set the move speed, move frequency and move type of aggressive pokemon
#    [*] aggressive ecounters are restricted to player movements
#    [*] add animations to aggressive encounters. See Additional Animations -Add On and TrankerGolD's animations for aggressive encounters
#        at https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383 to include spawning animations in your game
#  [*] Additional Animations Add-On
#    [*] manage different appear animations of overworld spawning encounters depending on encounter type and pokemon properties
#    [*] Play animations while PokeEvent is visible on screen, such as a shiny animation
#    [*] See also the animations by TrankerGolD for aggressive encounters, water encounters, and shiny encounters https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383
#  [*] Different Spawn And Normal Encounters (like in Pokemon Sword/Shield) Add-On
#    [*] Introduces Overworld Encounter Types you can set in your encounters.txt PBS-file.
#    [*] This allows you to define different encounters for overworld spawning and instant battling on the same map.
#  [*] Restrict Movement Add-On
#    [*] Overworld spawned Grass/Water/Sand/etc encounters move only on Grass/Water/Sand tiles and not leave there terrain
#    [*] You can activate and deactivate the restriction by setting the parameter RESTRICT_MOVEMENT in the settings section of this add-on
#  [*] Max Spawn Add-On
#    [*] Define a maximal limit of spawned pokemon on the overworld at the same time.
#    [*] After reaching that limit MAX_SPAWN no pokemon will spawn until another pokemon despawned.
#  [*] Additional Despawn Methods Add-On
#    [*] Choose to remove PokeEvent distanced on screen from the player with REMOVE_DISTANCED
#    [*] The distance (steps) is edited in DISTANCE_VANISH and DISTANCE_VANISH_SHINY
#    [*] Remove by time chronometer with REMOVE_PROLONGED
#    [*] Use your own overworld spawn chance in VISIBLE_ENCOUNTER_PROBABILITY
# [*] Own Minimum Spawn Chance
#    [*] The Spawn probability of the first encounter and later ones are similar.
#    [*] Spawning does not interact with the encounter chance for normal encounters.
#    [*] Increase the average spawning time of pokemon by setting MAX_ENCOUNTER_REDUCED larger than zero in the settings section of this script
#  [*] Fixed Spawn Probability Add-On
#    [*] Define your own overworld spawn chance in Percentage
#    [*] Spawn chance becomes independent from the default PEv19.1 encounter chance calculator
#  [*] Variable Spawn/Normal Encounter Proportion During Game  
#    [*] You can change the percentage between overworld spawning and normal encounters in story driven events during playthrough
#    [*] in Percentage, from only normal encounters to only spawning encounters
#  [*] Automatic Spawning Add-On
#    [*] Choose whether pokemon spawn automatically or only while moving the player
#    [*] Set the speed of automatic spawning
#  [*] Randomized Spawning Add-On
#    [*] It will randomize overworld encounters
#  [*] Ditto Transform Add-On
#    [*] Like in Pokemon Go, transformable Pokemon such as Ditto get the overworld appearence of different species
#    [*] Choose in settings if completely random, set by a list of candidates or set by the map encounters
#  [*] Remove Poke Events on load/save/transfer Add-On
#    [*] Remove overworld encounters on load/save and on map transfer
#  [*] Overworld Lavender Town Ghosts Add-On
#    [*] Shows ghost sprite for overworld encounters
#    [*] requires Lavender Town Ghosts Plugin 
#    [*] You need to put a graphic, named "ghost.png", in your "/Graphisc/Characters/" folder of your project. This graphic is not provided here, but maybe you can easily find some resource, for example search for "shiny missingNo [Ghost Form]".


#===============================================================================
#            INSTALLATION
#===============================================================================

# Installation as simple as it can be.
# [1] Add Graphics: Either get the resources from Gen 8 Project https://reliccastle.com/resources/670/
#  and install the "Graphics/Characters" folder in your game file system.
#  Or you place your own sprites for your pokemon/fakemon with the right names in your "\Graphics\Characters\Follower" folder and your shiny sprites in your "\Graphics\Characters\Follower shiny" folder. 
#  The right name of sprites is:
#    usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
#    alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
#    female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
# [2] Add Script: Follow this link https://github.com/VisibleOverworldWildEncounters/V20 and copy the folder "Visible Overworld Wild Encounters - Script" to your "/plugins/" folder.
# [3] [optional] Change Settings: Open the script file in the folder and change the parameters in the settings section therein as you like. Details descriptions about the parameters can be found there as well. 
# [4] [optional] Install Add-Ons (the folders under "/optional/" in the github repository): There are a lot of Add-Ons and parameter settings for your personal optimal solution. So, Copy Add-Ons in your "/plugins/" folder and edit parameters in settings of that Add-Ons to your liking. Some Add-Ons are incompatible to each other and some Add-On and parameter combinations can produce lag, e.g. a high spawning rate without a spawning cap, or e.g. "NO_OF_CHOSEN_TILES=0" (or too high) when having other scripts like Pokemon Following. So, do not simply include all folders.
# [5] Enjoy!

#===============================================================================
#             HELP AND MORE
#===============================================================================

# If you need help, found a bug or search for more modifications then go to
# https://www.pokecommunity.com/showthread.php?t=429019


#===============================================================================
#             CHANGELOG
#===============================================================================

# NEW FEATURES FROM VERSION 20.0.0.4 FOR PEv20:
# - new add on to restrict movement of spawned pokemon to there starting terrain. I.e. grass encounters stay on grass.
# NEW FEATURES FROM VERSION 20.0.0.3 FOR PEv20:
#  - removed bug concerning battling water encounters from shore in PEv20
# NEW FEATURES FROM VERSION 20.0.0.2 FOR PEv20:
#  - removed bug concerning renaming $MapFactory in PEv20
# NEW FEATURES FROM VERSION 20.0.0.1 FOR PEv20:
#  - updated version 19.1.0.4 to make it compatible with PEv20
# NEW FEATURES FROM VERSION 19.1.0.4 FOR PEv19:
#  - rearranged aggressive encounters as an Add On
# NEW FEATURES FROM VERSION 19.1.0.1 FOR PEv19:
#  - bug fix concerning roaming pokemon
#  - included an easy way to set the steps a pokemon remains on map before despawning depending on pokemon properties 
#  - rearranged features of previous version as add-ons, including
#     - trigger different appear animations depending on encounter type, shinyness
#     - shiny animation while PokeEvent is visible on screen
#     - stop more pokemon from spawning with the MAX_SPAWN parameter
#     - choose wether remove distanced spawned pokemon or not with REMOVE_DISTANCED parameter
#     - choose wether remove by time chronometer or not with REMOVE_PROLONGED
#     - added to add your own overworld encounter chance with VISIBLE_ENCOUNTER_PROBABILITY
# NEW FEATURES FROM VERSION 19.0.10 FOR PEv19:
#  - fixed water pokemon spawning in platform above water tile
#  - water pokemon won't appear in the border
#  - choose wether battling water pokemon from ground or not with BATTLE_WATER_ONGROUND parameter
#  - stop more pokemon from spawning with the MAX_SPAWN parameter
#  - choose wether remove distanced spawned pokemon or not with REMOVE_DISTANCED parameter
#  - shiny animation while PokeEvent is visible on screen
#  - choose wether remove by time chronometer or not with REMOVE_PROLONGED
#  - added to add your own chance with VISIBLE_ENCOUNTER_PROBABILITY
#  - aggressive encounters restricted to player movements
# NEW FEATURES FROM VERSION 19.0.9 FOR PEv19:
#  - updated script to work with PEv19.1
#  - used $game_temp.encounter_type to trigger diferent appear animations
#  - added alternative stepcount before vanishining for shiny pokemon
# NEW FEATURES FROM VERSION 18.0.8 FOR PEv18:
#  - tiny bug fix for $game_temp.encounter_type
# NEW FEATURES FROM VERSION 18.0.7 FOR PEv18:
#  - removed a bug concerning changing the standard form when goining into battle
# NEW FEATURES FROM VERSION 18.0.6 FOR PEv18:
#   - (hopefully) removed a rare crash concerning character_sprites
# NEW FEATURES FROM VERSION 2.0.5 FOR PEv18:
#   - removed bug that makes all water encounter vanish
# NEW FEATURES FROM VERSION 2.0.4 FOR PEv18:
#   - encounters dont spawn on impassable tiles in caves
# NEW FEATURES FROM VERSION 2.0.3 FOR PEv18:
#   - poke radar works as usual
# NEW FEATURES FROM VERSION 2.0.2 FOR PEv18:
#   - added new global variable $PokemonGlobal.creatingSpawningPokemon to check during the event @@OnWildPokemonCreate if the pokemon is created for spawning on the map or created for a different reason
# UPSCALED FEATURES FROM VERSION 2.0.1 FOR PEv17.2:
#   - less lag
#   - supports sprites for alternative forms of pokemon
#   - supports sprites for female/male/genderless pokemon
#   - bug fixes for roaming encounter and double battles
#   - more options in settings
#   - roaming encounters working correctly
#   - more lag reduction 
#   - included automatic spawning of pokemon, i.e. spawning without having to move the player
#   - included vendilys rescue chain, i. e. if pokemon of the same species family spawn in a row and will be battled in a row, then you increase the chance of spawning
#     an evolved pokemon of that species family. Link: https://www.pokecommunity.com/showthread.php?t=415524
#   - removed bug occuring after fainting against wild overworld encounter
#   - for script-developers, shortened the spawnPokeEvent method for better readablitiy
#   - removed bugs from version 1.9
#   - added shapes of overworld encounter for rescue chain users
#   - supports spawning of alternate forms while chaining
#   - if overworld sprites for alternative, female or shiny forms are missing,
#     then the standard sprite will be displayed instead of an invisible event
#   - bug fix for shiny encounters
#   - respecting shiny state for normal encounters when using overworld and normal encounters at the same time
#   - easier chaining concerning Vendilys Rescue chain, i.e. no more resetting of the chain when spawning of a pokemon of different family but when fighting with a pokemon of different family
#   - Added new Event @@OnPokemonCreateForSpawning which only triggers on spawning
#   - Added new global variable $PokemonGlobal.battlingSpawnedShiny to check if an active battle is against a spawned pokemon.
#   - removed bug to make the new features in version 1.11 work
#   - reorganised and thin out the code to organise code as add-ons
#   - removed Vendilys Rescue Chain, Let's Go Shiny Hunting and automatic spawning as hard coded feature and provide it as Add-Ons instead
#   - Now, using overworld and normal encounters at the same time is a standard feature
#   - autospawning will not trigger instant battles anymore
#   - removed a bug that came from reorganising the code in original code and add-ons concerning Let's go shiny hunting add-on

#===============================================================================
#                             Settings            
#===============================================================================

module VisibleEncounterSettings
  #------------- SPAWN RATE AND SPAWN PROPABILITY ------------ 
  INSTANT_WILD_BATTLE_PROPABILITY = 0 # default 0.
  # This parameter holds the default propability of normal to overworld encountering.
  # The propability is stored in percentage with possible values 0,1,2,...,100.
  # <= 0           - means only overworld encounters, no instant battles
  # > 0 and < 100  - means overworld encounters and normal encounters at the same time.
  # >= 100         - means only normal encounters and instant battles as usual, no overworld spawning
  
  #--------------- SPAWN POSITION ------------------
  SPAWN_RANGE = 4 # default 4
  # This parameter needs to be a positive integer. It is the maximum range from the player a PokeEvent will be able to spawn 

  RESTRICT_ENCOUNTERS_TO_PLAYER_MOVEMENT = false # default false
  # true - means that water encounters are popping up
  #       if and only if player is surfing
  #       (perhaps decreases encounter rate)
  # false - means that all encounter types can pop up
  #        close to the player (as long as there is a suitable tile)
  
  NO_SPAWN_ON_BORDER = false # default false
  # true  - means that pokemon on water won't spawn in the border
  # false - means that pokemon will also spawn on the border of water   

  #---------------- GRAPHICS OF SPAWNED POKEMON -------------------
  SPRITES = [true, true, true] # default [true, true, true]
  # This parameter must be an array [alt_form, female, shiny] of three bools.
  # alt_form/ female/ shiny = false means: you don't use alternative/ female/ shiny sprites for your overworld encounter.
  #                         = true  means: alternative forms/ female forms/ shiny pokemon have there own special overworld sprite.
  # If true, make sure that you have the overworld sprites with the right name in your "\Graphics\Characters\Follower" folder
  # and that you have the shiny overworld sprites with the same name in your "\Graphics\Characters\Follower shiny" folder.
  # The right name of sprites:
  #  usual form     - SPECIES.png   where SPECIES is the species name in capslock (e.g. PIDGEY.png)
  #  alternate form - SPECIES_n.png where n is the number of the form (e.g. PIKACHU_3.png)
  #  female form    - SPECIES_female.png or SPECIES_n_female (e.g. PIDGEY_female.png or PIKACHU_3_female.png)
  
  USE_STEP_ANIMATION = true # default true
  #false - means that overworld encounters don't have a stop-animation
  #true - means that overworld encounters have a stop-animation similar as  
  #       following pokemon
  
  #------------------- MOVEMENT OF SPAWNED POKEMON -----------------------
  DEFAULT_MOVEMENT = [3, 3, 1] # default [3, 3, 1]
  # This parameter stores an array [move_speed, move_frequency, move_type] of three integers where
  # move_speed/ move_frequency/ move_type is the default movement speed/ frequency/ type of spawned PokeEvents.
  # See RPGMakerXP for more details (compare to autonomous movement of events).
  # speed/ frequency = 1   - means lowest movement speed/ frequency
  # speed/ frequency = 6   - means highest movement speed/ frequency
  # type = 0/ 1/ 3         - means no movement/ random movement/ run to player
  # ...

  Enc_Movements = [                  # default
    [:shiny?, true, 3, 4, nil],    # [:shiny?, true, 3, 4, 3] means that shiny encounters will be faster
    [:species, :SLOWPOKE, 1, 1, nil], # [:species, :SLOWPOKE, 1, 1, nil] means that slowpoke is very slow. It might still want to run random or to the player.
    [:nature, :NAUGHTY, nil, 4, 3] # [:nature, :NAUGHTY, nil, 4, 3] means pokemon with a naughty nature will run to the player and be faster
  ]
  # This parameter is used to change movement of spawned PokeEvents depending on the spawned pokemon.
  # The data is stored as an array of arrays. You can add your own arrays.s
  # The data is stored as an array of entries [variable, value, move_speed, move_frequency, move_type], where variable
  # is a variable or method which does not require parameters of the class Pokemon,
  # value is a possible outcome value of variable and move_speed, move_frequency and move_type are the movement speed,
  # frequency and type all PokeEvents should get if value == pokemon.variable.
  # nil  - means that the movement-parameter will not be changed.

  #--------------- BATTLING SPAWNED POKEMON ------------------
  BATTLE_WATER_FROM_SHORE = false #default true
  # this is used if you want to battle water pokemon without surfing
  # (default is true but I think is better in false)
  #false - means the battle wont start if not surfing 
  #true - means you can battle from the ground a pokemon from the water

  #--------------- VANISHING OF SPAWNED POKEMON AFTER STEPS -------------------
  DEFAULT_STEPS_BEFORE_VANISH = 10 # default 10
  # This is the number of steps a wild encounter goes by default before vanishing on the map.

  Add_Steps_Before_Vanish = [ # default
    [:shiny?, true, 8],       # [:shiny, true, 8]       - means that spawned shiny pokemon will more 8 steps longer on the map than default.
    [:species, :PIDGEY, -2]   # [:species, :PIDGEY, -2] - means that pidgeys will be gone faster (2 steps earlier).
  ]
  # This is an array of arrays. You can add your own conditions as an additional array. It must be of the form [variable, value, number] where
  # variable is a variable or an method that does not need any parameters of the class Pokemon,
  # value is a possible value of variable and number is the number of steps an pokemon goes more (or less) than default before vanishing on the map 
  # if it satisfies pokemon.variable == value
  
end

#===============================================================================
#                              THE SCRIPT
#===============================================================================

          #########################################################
          #                                                       #
          #      0. PART: BUG FIX FOR ONCHANGEDIRECTION           #
          #                                                       #
          #########################################################

#===============================================================================
# (Bug Fix for Events.onChangeDirection)
#   - ChangeDirection will be considered as taking a step
#===============================================================================

EventHandlers.remove(:on_player_change_direction, :trigger_encounter)

EventHandlers.add(:on_player_change_direction, :trigger_encounter,
  proc {
    next if $game_temp.in_menu
    repel_active = ($PokemonGlobal.repel > 0)
    if pbBattleOrSpawnOnStepTaken(repel_active) 
      pbBattleOnStepTaken(repel_active) # STANDARD WILD BATTLE
    else
      pbSpawnOnStepTaken(repel_active)  # OVERWORLD ENCOUNTERS
    end
  }
)


          #########################################################
          #                                                       #
          #      1. PART: SPAWNING THE OVERWORLD ENCOUNTER        #
          #                                                       #
          #########################################################


#===============================================================================
# We override the original method "pbOnStepTaken" in Script Overworld.
# It was  originally used for wild encounter battles
#===============================================================================
def pbOnStepTaken(eventTriggered)
  if $game_player.move_route_forcing || pbMapInterpreterRunning?
    EventHandlers.trigger(:on_step_taken, $game_player)
    return
  end
  $PokemonGlobal.stepcount = 0 if !$PokemonGlobal.stepcount
  $PokemonGlobal.stepcount += 1
  $PokemonGlobal.stepcount &= 0x7FFFFFFF
  repel_active = ($PokemonGlobal.repel > 0)
  EventHandlers.trigger(:on_player_step_taken)
  handled = [nil]
  EventHandlers.trigger(:on_player_step_taken_can_transfer, handled)
  return if handled[0]
  if !eventTriggered && !$game_temp.in_menu
    if pbBattleOrSpawnOnStepTaken(repel_active)
      pbBattleOnStepTaken(repel_active) # STANDARD WILD BATTLE
    else
      pbSpawnOnStepTaken(repel_active)  # OVERWORLD ENCOUNTERS
    end
  end
  $game_temp.encounter_triggered = false   # This info isn't needed here
end

#===============================================================================
# new Method pbBattleOrSpawnOnStepTaken which gives true with the probability of
# an instant encounter and false with the probability of an overworld encounter
#===============================================================================
def pbBattleOrSpawnOnStepTaken(repel_active)
  if (rand(100) < VisibleEncounterSettings::INSTANT_WILD_BATTLE_PROPABILITY) || pbPokeRadarOnShakingGrass
    return true
  else
    return false
  end
end

#===============================================================================
# new method pbSpawnOnStepTaken working almost like pbBattleOnStepTaken
#===============================================================================
def pbSpawnOnStepTaken(repel_active)
  return if $player.able_pokemon_count == 0 #check if trainer has pokemon
  #First we choose a tile near the player
  pos = pbChooseTileOnStepTaken
  return if !pos
  encounter_type = $PokemonEncounters.encounter_type_on_tile(pos[0],pos[1])
  return if !encounter_type
  return if !$PokemonEncounters.encounter_triggered_on_tile?(encounter_type, repel_active, true)
  $game_temp.encounter_type = encounter_type
  encounter = $PokemonEncounters.choose_wild_pokemon(encounter_type)
  $PokemonGlobal.creatingSpawningPokemon = true
  EventHandlers.trigger(:on_wild_species_chosen, encounter)
  if $PokemonEncounters.allow_encounter?(encounter, repel_active)
    pokemon = pbGenerateWildPokemon(encounter[0],encounter[1])
    # trigger event on spawning of pokemon
    EventHandlers.trigger(:on_wild_pokemon_created_for_spawning, pokemon)
    pbPlaceEncounter(pos[0],pos[1],pokemon)
    # $PokemonEncounters.reset_step_count # added such that your encounter rate resets after spawning of an overworld pokemon 
    $game_temp.encounter_type = nil
    $game_temp.encounter_triggered = true
  end
  $game_temp.force_single_battle = false
  EventHandlers.trigger(:on_wild_pokemon_created_for_spawning_end)
  $PokemonGlobal.creatingSpawningPokemon = false
  #EncounterModifier.triggerEncounterEndSpawn
  #EncounterModifier.triggerEncounterEnd # not use anymore in PEv20 ?
end

#===============================================================================
# new method pbChooseTileOnStepTaken to choose the tile on which the pkmn spawns 
#===============================================================================
def pbChooseTileOnStepTaken
  x = $game_player.x
  y = $game_player.y
  range = VisibleEncounterSettings::SPAWN_RANGE
  i = rand(range)
  r = rand((i+1)*8)
  if r<=(i+1)*2
    new_x = x-i-1+r
    new_y = y-i-1
  elsif r<=(i+1)*6-2
    new_x = [x+i+1,x-i-1][r%2]
    new_y = y-i+((r-1-(i+1)*2)/2).floor
  else
    new_x = x-i+r-(i+1)*6
    new_y = y+i+1
  end
  return [new_x,new_y] if pbTileIsPossible(new_x,new_y)
  return
end

#===============================================================================
# new method pbTileIsPossible to check if tile is good to spawn
#===============================================================================
def pbTileIsPossible(x,y)
  if !$game_map.valid?(x,y) #check if the tile is on the map
    return false
  else
    tile_terrain_tag = $game_map.terrain_tag(x,y)
  end
  for event in $game_map.events.values
    if event.x==x && event.y==y
      return false
    end
  end
  return false if !tile_terrain_tag
  #check if it's a valid grass, water or cave etc. tile
  return false if tile_terrain_tag.ice
  return false if tile_terrain_tag.ledge
  return false if tile_terrain_tag.waterfall
  return false if tile_terrain_tag.waterfall_crest
  return false if tile_terrain_tag.id == :Rock
  if VisibleEncounterSettings::RESTRICT_ENCOUNTERS_TO_PLAYER_MOVEMENT
    return false if !tile_terrain_tag.can_surf && 
              $PokemonGlobal && $PokemonGlobal.surfing
    return false if tile_terrain_tag.can_surf && 
              !($PokemonGlobal && $PokemonGlobal.surfing)
  end
  if tile_terrain_tag.can_surf
    for i in [2, 1, 0]
      tile_id = $game_map.data[x, y, i]
      return false if !tile_id || tile_id < 0
      next if tile_id == 0
      terrain = GameData::TerrainTag.try_get($game_map.terrain_tags[tile_id])
      passage = $game_map.passages[tile_id]
      priority = $game_map.priorities[tile_id]
      break if terrain.can_surf
      # Ignore if tile above water
      return false if passage!=0
      return false if priority==0 && !terrain.ignore_passability
    end
  else
    return false if !$game_map.passableStrict?(x, y, 0)
  end
  
  return false if !$PokemonEncounters.encounter_possible_here_on_tile?(x,y)
  
  return true
end

#===============================================================================
# defining new method pbPlaceEncounter to add/place and visualise the pokemon
# "encounter" on the overworld-tile (x,y)
#===============================================================================
def pbPlaceEncounter(x,y,pokemon)
  # place event with random movement with overworld sprite
  # We define the event, which has the sprite of the pokemon and activates the wildBattle on touch
  if !$map_factory
    $game_map.spawnPokeEvent(x,y,pokemon)
  else
    mapId = $game_map.map_id
    spawnMap = $map_factory.getMap(mapId)
    spawnMap.spawnPokeEvent(x,y,pokemon)
  end
  pbPlayCryOnOverworld(pokemon.species, pokemon.form) # Play the pokemon cry of encounter
end


#===============================================================================
# adding new Method encounter_type_on_tile in Class PokemonEncounters
#===============================================================================
class PokemonEncounters  
  def encounter_type_on_tile(x,y)
    time = pbGetTimeNow
    ret = nil
    if $game_map.terrain_tag(x,y).can_surf_freely
      ret = find_valid_encounter_type_for_time(:Water, time)
    else   # Land/Cave (can have both in the same map)
      if has_land_encounters? && $game_map.terrain_tag(x, y).land_wild_encounters
        ret = :BugContest if pbInBugContest? && has_encounter_type?(:BugContest)
        ret = find_valid_encounter_type_for_time(:Land, time) if !ret
      end
      if !ret && has_cave_encounters?
        ret = find_valid_encounter_type_for_time(:Cave, time)
      end
    end
    return ret
  end
  
  #===============================================================================
  # adding new method encounter_possible_here_on_tile? in class PokemonEncounters
  # in file 003_Overworld_WildEncounters.rb to check at arbitrary coordinates x
  # and y and not only at players position such as encounter_possible_here? does
  #===============================================================================
  def encounter_possible_here_on_tile?(x,y)
    tile_terrain_tag = $game_map.terrain_tag(x,y)
    if tile_terrain_tag.can_surf_freely
      if VisibleEncounterSettings::NO_SPAWN_ON_BORDER
        return false if !$game_map.terrain_tag(x+1,y).can_surf_freely
        return false if !$game_map.terrain_tag(x-1,y).can_surf_freely
        return false if !$game_map.terrain_tag(x,y+1).can_surf_freely
        return false if !$game_map.terrain_tag(x,y-1).can_surf_freely
      end
      return true
    end
    return true if tile_terrain_tag.can_surf_freely
    return false if tile_terrain_tag.ice
    return true if has_cave_encounters?   # i.e. this map is a cave
    return true if has_land_encounters? && tile_terrain_tag.land_wild_encounters
    return false
  end

  #===============================================================================
  # adding new Method encounter_triggered_on_tile? to Class PokemonEncounters
  # to returns whether a overworld wild encounter should happen, based on its encounter
  # chance. Called when taking a step. Add-ons may overwrite this method.
  #===============================================================================
  def encounter_triggered_on_tile?(enc_type, repel_active = false, triggered_by_step = true)
    return $PokemonEncounters.encounter_triggered?(enc_type, repel_active, true)
  end

  #===============================================================================
  # adding new method have_double_wild_battle_on_tile? in class PokemonEncounters
  # Returns whether a wild encounter should be turned into a double wild encounter
  # similar to have_double_wild_battle but depends on tile.
  #===============================================================================
  def have_double_wild_battle_on_tile?(x, y, map_id)
    return false if $game_temp.force_single_battle
    return false if pbInSafari?
    return true if $PokemonGlobal.partner
    return false if $player.able_pokemon_count <= 1
    if $map_factory
      terrainTag = $map_factory.getTerrainTag(map_id,x,y)
    else
      terrainTag = $game_map.terrain_tag(x,y)
    end
    return true if terrainTag.double_wild_encounters && rand(100) < 30  
    return false
  end
end

#===============================================================================
# adding new Class Game_PokeEvent and a new method attr_accessor to this Class
# to store the corresponding Pokemon in the Game_Event
#===============================================================================
class Game_PokeEvent < Game_Event
  #attr_accessor :event
  attr_accessor :pokemon # contains the original pokemon of class Pokemon

  def initialize(map_id, event, map=nil)
    super(map_id, event, map)
  end
end

#===============================================================================
# new Method spawnPokeEvent in Class Game_Map in Script Game_Map
#===============================================================================
class Game_Map
  def spawnPokeEvent(x,y,pokemon)
    #--- generating a new event ---------------------------------------
    event = RPG::Event.new(x,y)
    #--- nessassary properties ----------------------------------------
    key_id = (@events.keys.max || -1) + 1
    event.id = key_id
    event.x = x
    event.y = y
    #--- Graphic of the event -----------------------------------------
    encounter = [pokemon.species,pokemon.level]
    form = pokemon.form
    gender = pokemon.gender
    shiny = pokemon.shiny?
    #event.pages[0].graphic.tile_id = 0
    graphic_form = (VisibleEncounterSettings::SPRITES[0] && form!=nil) ? form : 0
    graphic_gender = (VisibleEncounterSettings::SPRITES[1] && gender!=nil) ? gender : 0
    graphic_shiny = (VisibleEncounterSettings::SPRITES[2] && shiny!=nil) ? shiny : false
    fname = ow_sprite_filename(encounter[0].to_s, graphic_form, graphic_gender, graphic_shiny)
    fname.gsub!("Graphics/Characters/","")

    event.pages[0].graphic.character_name = fname
    #--- movement of the event --------------------------------
    event.pages[0].move_speed = VisibleEncounterSettings::DEFAULT_MOVEMENT[0]
    event.pages[0].move_frequency = VisibleEncounterSettings::DEFAULT_MOVEMENT[1]
    event.pages[0].move_type = VisibleEncounterSettings::DEFAULT_MOVEMENT[2]
    event.pages[0].step_anime = true if VisibleEncounterSettings::USE_STEP_ANIMATION
    event.pages[0].trigger = 2
    event.pages[0].move_route.list[0].code = 10
    event.pages[0].move_route.list[1] = RPG::MoveCommand.new
    for move in VisibleEncounterSettings::Enc_Movements do
      if pokemon.method(move[0]).call == move[1]
        event.pages[0].move_speed = move[2] if move[2]
        event.pages[0].move_frequency = move[3] if move[3]
        event.pages[0].move_type = move[4] if move[4]
      end
    end
    #--- event commands of the event -------------------------------------
    #  - add a method that stores temp data when PokeEvent is triggered, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    Compiler::push_script(event.pages[0].list,sprintf(" pbStoreTempForBattle()"))
    #  - set data for roamer and encounterType, that is
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    if $PokemonGlobal.roamEncounter!=nil # i.e. $PokemonGlobal.roamEncounter = [i,species,poke[1],poke[4]]
      parameter1 = $PokemonGlobal.roamEncounter[0].to_s
      parameter2 = $PokemonGlobal.roamEncounter[1].to_s
      parameter3 = $PokemonGlobal.roamEncounter[2].to_s
      $PokemonGlobal.roamEncounter[3] != nil ? (parameter4 = '"'+$PokemonGlobal.roamEncounter[3].to_s+'"') : (parameter4 = "nil")
      parameter = " $PokemonGlobal.roamEncounter = ["+parameter1+",:"+parameter2+","+parameter3+","+parameter4+"] "
    else
      parameter = " $PokemonGlobal.roamEncounter = nil "
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.roamer_index_for_encounter!=nil) ? " $game_temp.roamer_index_for_encounter = "+$game_temp.roamer_index_for_encounter.to_s : " $game_temp.roamer_index_for_encounter = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($PokemonGlobal.nextBattleBGM!=nil) ? " $PokemonGlobal.nextBattleBGM = '"+$PokemonGlobal.nextBattleBGM.to_s+"'" : " $PokemonGlobal.nextBattleBGM = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.force_single_battle!=nil) ? " $game_temp.force_single_battle = "+$game_temp.force_single_battle.to_s : " $game_temp.force_single_battle = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    parameter = ($game_temp.encounter_type!=nil) ? " $game_temp.encounter_type = :"+$game_temp.encounter_type.to_s : " $game_temp.encounter_type = nil "
    Compiler::push_script(event.pages[0].list,sprintf(parameter))
    #  - add a branch to check if player can battle water pokemon from ground
    Compiler::push_branch(event.pages[0].list,sprintf(" pbCheckBattleAllowed()"))
    #  - set $PokemonGlobal.battlingSpawnedPokemon = true
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = true"),1)    
    #  - add method pbSingleOrDoubleWildBattle for the battle
    if !$map_factory
      parameter = " pbSingleOrDoubleWildBattle( $game_map.events[#{key_id}].map.map_id, $game_map.events[#{key_id}].x, $game_map.events[#{key_id}].y, $game_map.events[#{key_id}].pokemon )"
    else
      mapId = $game_map.map_id
      parameter = " pbSingleOrDoubleWildBattle( $map_factory.getMap("+mapId.to_s+").events[#{key_id}].map.map_id, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].x, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].y, $map_factory.getMap("+mapId.to_s+").events[#{key_id}].pokemon )"
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #   - set $PokemonGlobal.battlingSpawnedPokemon = false
    Compiler::push_script(event.pages[0].list,sprintf(" $PokemonGlobal.battlingSpawnedPokemon = false"),1) 
    #  - add a method to reset temporary data to previous state, must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"),1)
    #  - add method to remove this PokeEvent from map
    if !$map_factory
      parameter = "$game_map.removeThisEventfromMap(#{key_id})"
    else
      mapId = $game_map.map_id
      parameter = "$map_factory.getMap("+mapId.to_s+").removeThisEventfromMap(#{key_id})"
    end
    Compiler::push_script(event.pages[0].list,sprintf(parameter),1)
    #  - add the end of branch
    Compiler::push_branch_end(event.pages[0].list,1)
    #  - add a method to reset temporary data to previous state (if tried to battle waterpokemon from shore but not allowed), must include
    #    $PokemonGlobal.roamEncounter, $game_temp.roamer_index_for_encounter, $PokemonGlobal.nextBattleBGM, $game_temp.force_single_battle, $game_temp.encounter_type
    Compiler::push_script(event.pages[0].list,sprintf(" pbResetTempAfterBattle()"))
    #  - finally push end command
    Compiler::push_end(event.pages[0].list)
    #--- creating and adding the Game_PokeEvent ------------------------------------
    gameEvent = Game_PokeEvent.new(@map_id, event, self)
    gameEvent.id = key_id
    gameEvent.moveto(x,y)
    gameEvent.pokemon = pokemon
    for step in VisibleEncounterSettings::Add_Steps_Before_Vanish
      step_method = step[0]
      step_value = step[1]
      step_count = step[2]
      if pokemon.method(step_method).call == step_value
        gameEvent.remaining_steps += step_count
      end
    end
  
    @events[key_id] = gameEvent
    #--- updating the sprites --------------------------------------------------------
    sprite = Sprite_Character.new(Spriteset_Map.viewport,@events[key_id])
    $scene.spritesets[self.map_id]=Spriteset_Map.new(self) if $scene.spritesets[self.map_id]==nil
    $scene.spritesets[self.map_id].character_sprites.push(sprite)
    # alternatively: updating the sprites (old and slow but working):
    #$scene.disposeSpritesets
    #$scene.createSpritesets
  end
end

#-------------------------------------------------------------------------------
# New method for easily get the appropriate Pokemon Graphic
#-------------------------------------------------------------------------------
def ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
  fname = GameData::Species.check_graphic_file("Graphics/Characters/", species, form, gender, shiny, shadow, "Followers")
  fname = "Graphics/Characters/Followers/000.png" if nil_or_empty?(fname)
  return fname
end

class Game_Temp
  attr_accessor :VOWERoamEncounter
  attr_accessor :VOWERoamerIndex
  attr_accessor :VOWENextBattleBGM
  attr_accessor :VOWEForceSingleBattle
  attr_accessor :VOWEEncounterType
end

#===============================================================================
# adding new Method pbStoreTempForBattle to store temporary data before battling
# overworld pokemon
#===============================================================================
def pbStoreTempForBattle()
  $game_temp.VOWERoamEncounter = $PokemonGlobal.roamEncounter
  $game_temp.VOWERoamerIndex = $game_temp.roamer_index_for_encounter
  $game_temp.VOWENextBattleBGM = $PokemonGlobal.nextBattleBGM 
  $game_temp.VOWEForceSingleBattle = $game_temp.force_single_battle
  $game_temp.VOWEEncounterType = $game_temp.encounter_type
end

#===============================================================================
# adding new Method to reset temporary data after battling overworld back to before
#===============================================================================
def pbResetTempAfterBattle()
  $PokemonGlobal.roamEncounter = $game_temp.VOWERoamEncounter
  $game_temp.roamer_index_for_encounter = $game_temp.VOWERoamerIndex
  $PokemonGlobal.nextBattleBGM = $game_temp.VOWENextBattleBGM 
  $game_temp.force_single_battle = $game_temp.VOWEForceSingleBattle
  $game_temp.encounter_type = $game_temp.VOWEEncounterType
end

#===============================================================================
# adding new Method pbCheckBattleAllowed to check if battling water pokemon from ground are allowed
#===============================================================================
def pbCheckBattleAllowed()
  encType = GameData::EncounterType.try_get($game_temp.encounter_type)
  #the pokemon encounter battle won't happen if it is in the water and the player is not surfing
  return false if !$PokemonGlobal.surfing && encType.type == :water && VisibleEncounterSettings::BATTLE_WATER_FROM_SHORE == false
  return true
end

#===============================================================================
# adding new Method pbSingleOrDoubleWildBattle to reduce the code in spawnPokeEvent
#===============================================================================
def pbSingleOrDoubleWildBattle(map_id,x,y,pokemon)
  if $PokemonEncounters.have_double_wild_battle_on_tile?(x,y,map_id)
      encounter2 = $PokemonEncounters.choose_wild_pokemon($game_temp.encounter_type)
      EventHandlers.trigger(:on_wild_species_chosen, encounter2)
      setBattleRule("double")
      WildBattle.start(pokemon, encounter2, can_override: true)
  else
    WildBattle.start(pokemon, can_override: true)
  end
  $game_temp.encounter_type = nil
  $game_temp.encounter_triggered = true
end

#===============================================================================
# adding new method pbPlayCryOnOverworld to load/play Pokémon cry files 
# SPECIAL THANKS TO "Ambient Pokémon Cries" - by Vendily
# actually it's not used, but that code helped to include the pkmn cries faster
#===============================================================================
def pbPlayCryOnOverworld(pokemon,form=0,volume=30,pitch=100) # default volume=90
  return if !pokemon || pitch <= 0
  form = 0 if form==nil
  if pokemon.is_a?(Pokemon)
    if !pokemon.egg?
      GameData::Species.play_cry_from_pokemon(pokemon,volume,pitch)
    end
  else
    GameData::Species.play_cry_from_species(pokemon,form,volume,pitch)
  end
end

#===============================================================================
# adding a new method attr_reader to the Class Spriteset_Map in Script
# Spriteset_Map to get access to the variable @character_sprites of a
# Spriteset_Map
#===============================================================================
class Spriteset_Map
  attr_reader :character_sprites
end

#===============================================================================
# adding a new method attr_reader to the Class Scene_Map in Script
# Scene_Map to get access to the Spriteset_Maps listed in the variable 
# @spritesets of a Scene_Map
#===============================================================================
class Scene_Map
  attr_reader :spritesets
end


          #########################################################
          #                                                       #
          #   2. PART: VANISH OVERWORLD ENCOUNTER AFTER BATTLE    #
          #                                                       #
          #########################################################

#-------------------------------------------------------------------
# adding new Method removeThisEventfromMap in Class Game_Map 
# to let an overworld pokemon disappear after battling
#-------------------------------------------------------------------
class Game_Map
  def removeThisEventfromMap(id)
    if @events.has_key?(id)
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[@map_id].character_sprites
          if sprite.character == @events[id]
            $scene.spritesets[@map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
      @events.delete(id)
    end
  end
end

#===============================================================================
# adding a new variable remaining_steps and replacing the method increase_steps
# in class Game_PokeEvent to count the remaining steps of the PokeEvent of the 
# overworld encounter before vanishing from map and to make them disappear after
# remaining_steps became <= 0 
#===============================================================================
class Game_PokeEvent < Game_Event
  attr_accessor :remaining_steps #counts the remaining steps of an overworld encounter before vanishing 
  
  alias o_initialize initialize
  def initialize(map_id, event, map=nil)
    o_initialize(map_id, event, map)
    @remaining_steps  = VisibleEncounterSettings::DEFAULT_STEPS_BEFORE_VANISH
  end
  
  alias original_increase_steps increase_steps
  def increase_steps
    if @remaining_steps <= 0
      removeThisEventfromMap
    else
      @remaining_steps-=1
      original_increase_steps
    end
  end
  
  # self.map_id bzw. @map_id

  def removeThisEventfromMap
    if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
      if defined?($scene.spritesets)
        for sprite in $scene.spritesets[$game_map.map_id].character_sprites
          if sprite.character==self
            $scene.spritesets[$game_map.map_id].character_sprites.delete(sprite)
            sprite.dispose
            break
          end
        end
      end
      $game_map.events.delete(@id)
    else
      if $map_factory
        for map in $map_factory.maps
          if map.events.has_key?(@id) and map.events[@id]==self
            if defined?($scene.spritesets) && $scene.spritesets[self.map_id] && $scene.spritesets[self.map_id].character_sprites
              for sprite in $scene.spritesets[self.map_id].character_sprites
                if sprite.character==self
                  $scene.spritesets[map.map_id].character_sprites.delete(sprite)
                  sprite.dispose
                  break
                end
              end
            end
            map.events.delete(@id)
            break
          end
        end
      else
        raise ArgumentError.new(_INTL("Actually, this should not be possible"))
      end
    end
  end
end


          #########################################################
          #                                                       #
          #             3. PART: ADDITIONAL FEATURES              #
          #                                                       #
          #########################################################

#===============================================================================
# introduces EventHandlers
# :on_wild_pokemon_created_for_spawning_end (used for roamer)
# :on_wild_pokemon_created_for_spawning (nessessary?)
# This Event is triggered  when a new pokemon spawns. Use this Event instead of OnWildPokemonCreate
# if you want to add a new procedure that modifies a pokemon on spawning 
# but not on creation while going into battle with an already spawned pokemon.
#Note that OnPokemonCreate is also triggered when a pokemon is created for spawning,
#But OnPokemonCreateForSpawning is not triggered when a pokemon is created in other situations than for spawning
#===============================================================================

#-------------------------------------------------------------------------------
# adding a process to the EncounterModifier TriggerEncounterEnd For roaming
# encounters. We have to set roamed_already to true after one roamer spawned.
#-------------------------------------------------------------------------------

#===============================================================================
# adds new parameter battlingSpawnedPokemon to the class PokemonGlobalMetadata.
# Also overrides initialize include that parameter there.
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :creatingSpawningPokemon
  attr_accessor :battlingSpawnedPokemon

  alias original_initialize initialize
  def initialize
    creatingSpawningPokemon = false
    battlingSpawnedPokemon = false
    original_initialize
  end
end


          #########################################################
          #                                                       #
          #            4. PART: ROAMING POKEMON                   #
          #                                                       #
          #########################################################
#===============================================================================
# This part is about roaming pokemon
#
# By default roaming pokemon can encounter as overworld and as normal encounters
#===============================================================================

#-------------------------------------------------------------------------------
# Overwriting pbRoamingMethodAllowed such that the encounter_type is not computed
# by the position of the player but of the chosen tile near the player
# Returns whether the given category of encounter contains the actual encounter
# method that will not occur in the player's current position.
#-------------------------------------------------------------------------------
def pbRoamingMethodAllowed(roamer_method)
  enc_type = $game_temp.encounter_type # $game_temp.encounter_type stores the encounter type of the chosen tile
  type = GameData::EncounterType.get(enc_type).type
  case roamer_method
  when 0   # Any step-triggered method (except Bug Contest)
    return [:land, :cave, :water].include?(type)
  when 1   # Walking (except Bug Contest)
    return [:land, :cave].include?(type)
  when 2   # Surfing
    return type == :water
  when 3   # Fishing
    return type == :fishing
  when 4   # Water-based
    return [:water, :fishing].include?(type)
  end
  return false
end

#-------------------------------------------------------------------------------
# adding a process to the EncounterModifier TriggerEncounterEnd For roaming
# encounters. We have to set roamed_already to true after one roamer spawned.
#-------------------------------------------------------------------------------  
EventHandlers.add(:on_wild_pokemon_created_for_spawning_end, :roamer_spawned, proc{
  if $game_temp.roamer_index_for_encounter != nil &&  $PokemonGlobal.roamEncounter != nil
    $PokemonGlobal.roamEncounter = nil
    $PokemonGlobal.roamedAlready = true
    $game_temp.roamer_index_for_encounter = nil
   end
})
