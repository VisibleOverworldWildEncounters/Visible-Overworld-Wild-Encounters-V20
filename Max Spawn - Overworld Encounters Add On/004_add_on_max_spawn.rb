
          #########################################################
          #                                                       #
          #          ADD-ON:  MAX SPAWN by TrankerGolD            #
          #                                                       #
          #########################################################

# You can use this add-on to set a maximal number of wild Encounters Events
# that can be spawned on the map at the same time.
# Use the parameter MAX_SPAWN (see below) to set the limit of overworld pokeEvents at the same time.

# FEATURES:
# * Stop more PokeEvent from spawning with the MAX_SPAWN parameter


module VisibleEncounterSettings
  MAX_SPAWN = 1 # default 0
  # MAX_SPAWN is the max number of wild Encounters Events that can be spawned on the map at the same time.
  # <=0  - means infinite (no maximum)
  # >0   - maximum of wild encounters on the map  
end

#===============================================================================
# overwriting method pbSpawnOnStepTaken in script visible overworld wild encounters
# to include maximal number of spawned pokemon
#===============================================================================
alias o_pbSpawnOnStepTaken pbSpawnOnStepTaken
def pbSpawnOnStepTaken(repel_active)
  return false if VisibleEncounterSettings::MAX_SPAWN>0 && pbCountPokeEvent >= VisibleEncounterSettings::MAX_SPAWN
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
  
