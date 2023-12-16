
          #########################################################
          #                                                       #
          #          ADD-ON:  MAX SPAWN by TrankerGolD            #
          #                              -updated by derFischae   #
          #########################################################

# You can use this add-on to set a maximal number of wild Encounters Events
# that can be spawned on the map at the same time.
# Use the parameter DEFAULT_MAX_SPAWN (see below) to set the limit of overworld pokeEvents at the same time.
# Use the parameter MAP_MAX_SPAWN (see below) to set specific limits for each map differently. 

# FEATURES:
# * Stop more PokeEvent from spawning with the DEFAULT_MAX_SPAWN parameter and give exceptions for each map in MAP_MAX_SPAWN.


module VisibleEncounterSettings
  DEFAULT_MAX_SPAWN = 0 # default 0
  # DEFAULT_MAX_SPAWN is the max number of wild Encounters Events that can be spawned on the map at the same time.
  # <=0  - means infinite (no maximum)
  # >0   - equals maximum of wild encounters on all maps (that are not listed as exceptions in MAP_MAX_SPAWN below) 

  MAP_MAX_SPAWN = [
    [4, 5]              # - means the maximal spawn limit is 5 on map with map_id 4
    #[map_id, limit],   # - add your specific map limits here. Don't forget to use a comma between your pairs.
  ]
  # MAP_MAX_SPAWN is a parameter that contains pairs of the form [map_id, limit], where each pair consists of the map_id of a map and the corresponding spawn limit of that map.
  # example: [ [4,5], [6,0] ]   means   "map with id 4 has spawn limit of 5 pokemons and map with id 6 has no spawn limit".
end

#===============================================================================
# overwriting method pbSpawnOnStepTaken in script visible overworld wild encounters
# to include maximal number of spawned pokemon
#===============================================================================
alias o_pbSpawnOnStepTaken pbSpawnOnStepTaken
def pbSpawnOnStepTaken(repel_active)
  max_spawn = VisibleEncounterSettings::DEFAULT_MAX_SPAWN

  currentRegion = pbGetCurrentRegion
  currentMapName = $game_map.name
  if VisibleEncounterSettings::MAP_MAX_SPAWN && VisibleEncounterSettings::MAP_MAX_SPAWN.length > 0
    for map_limit in VisibleEncounterSettings::MAP_MAX_SPAWN do
      map_id = map_limit[0]

      if map_id != $game_map.map_id
        map_metadata = GameData::MapMetadata.try_get(map_id)
        next if !map_metadata || !map_metadata.town_map_position ||
                map_metadata.town_map_position[0] != currentRegion
        next if pbGetMapNameFromId(map_id) != currentMapName
      end
      
      max_spawn = map_limit[1]
      break
    
    end
  end
  return false if max_spawn>0 && pbCountPokeEvent >= max_spawn
  o_pbSpawnOnStepTaken(repel_active)
end 

#===============================================================================
# new methods to count pkmn spawned 
#===============================================================================
#Count all spawned events
def pbCountPokeEvent
  currentCountPokeEvent = 0
  if $MapFactory
    for map in $MapFactory.maps
      for event in map.events.values
        if event.is_a?(Game_PokeEvent)
          currentCountPokeEvent = currentCountPokeEvent + 1
        end
      end
    end
  else
    for event in $game_map.events.values
      if event.is_a?(Game_PokeEvent)
        currentCountPokeEvent = currentCountPokeEvent + 1
      end
    end
  end
  return currentCountPokeEvent
end
  
#Count spawned events in current map
def pbCountPokeEventInMap
  currentCountPokeEvent = 0
  $game_map.events.values.each { |event|
    if event.is_a?(Game_PokeEvent)
      currentCountPokeEvent = currentCountPokeEvent + 1
    end
  }
  return currentCountPokeEvent
end



