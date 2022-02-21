#===============================================================================
#       ADD-ON: different encounters for overworld spawning and 
#                 original encountering on the same map
#===============================================================================


# You can define different encounters for overworld spawning and normal encountering in the PBS for your maps.
# For instance, you can have purely overworld encounters at day and purely normal instant encounters at night,
# or Overworld and normal encounters at the same time on the same map.
#
# For normal encounters use the usual encounter types such as Land, LandDay, Cave, Water, etc.
# For overworld encounters use the corresponding overworld encounter types such as OverworldLand, OverworldLandDay, OverworldCave, OverworldWater.
# Note that there is no overworld fishing and no overworld rocksmash. 
#
# Please make sure that the settings of your visible overworld wild encounters script allow overworld spawning and instant encountering at the same time.
# Please set the fall back variable LET_NORMAL_ENCOUNTERS_SPAWN (see below) for your preferences.
# Please note that roaming Pokemon can spawn as overworld pokemon or can encounter normally as instant battles. If you want your roaming pokemon to be purely overworld spawning or purely normal encountering then you have to add new roamer methods to the method
# pbRoamingMethodAllowed and give your roamer that number in the Settings section of Pokemon Essentials. See below for examples how to modify.

# How to use it:
# - Go to encounters.txt in the PBS folder.
# - Use for example OverworldLand instead of Land for visible encounters spawning.
# - All new EncounterType are:
# 	OverworldLand,	OverworldLandDay,	OverworldLandNight,	OverworldLandMorning,	OverworldLandAfternoon,	OverworldLandEvening
# 	OverworldCave,	OverworldCaveDay,	OverworldCaveNight,	OverworldCaveMorning,	OverworldCaveAfternoon,	OverworldCaveEvening
# 	OverworldWater,	OverworldWaterDay,	OverworldWaterNight,	OverworldWaterMorning,	OverworldWaterAfternoon,
# 	OverworldWaterEvening,	OverworldBugContest

module VisibleEncounterSettings

  LET_NORMAL_ENCOUNTERS_SPAWN = true # default false
  # This parameter must be true or false. This parameter comes in play when
  # there is no specific overworld encounter type defined in the PBS "encounters.txt"
  # false - means: if there is no specific overworld ecounter type in the PBS 
  #         for the current map then there will be no spawning pokemon on that map
  # true  - means: if there is no specific overworld ecounter type in the PBS 
  #         for the current map but a usual encounter type then a pokemon from
  #         that usual encounter type list will spawn
  
end

#===============================================================================
# overwriting Method encounter_type_on_tile in Class PokemonEncounters in Script
# visible overworld wild encounters to include overworld encounter types
#===============================================================================
class PokemonEncounters  
  def encounter_type_on_tile(x,y)
    time = pbGetTimeNow
    ret = nil
    if $game_map.terrain_tag(x,y).can_surf_freely
      ret = find_valid_encounter_type_for_time(:OverworldWater, time)
      ret = find_valid_encounter_type_for_time(:Water, time) if !ret && VisibleEncounterSettings::LET_NORMAL_ENCOUNTERS_SPAWN
    else   # Land/Cave (can have both in the same map)
      if has_land_encounters? && $game_map.terrain_tag(x, y).land_wild_encounters
        ret = :OverworldBugContest if pbInBugContest? && has_encounter_type?(:OverworldBugContest)
        ret = :BugContest if pbInBugContest? && has_encounter_type?(:BugContest) if !ret && VisibleEncounterSettings::LET_NORMAL_ENCOUNTERS_SPAWN
        ret = find_valid_encounter_type_for_time(:OverworldLand, time) if !ret
        ret = find_valid_encounter_type_for_time(:Land, time) if !ret && VisibleEncounterSettings::LET_NORMAL_ENCOUNTERS_SPAWN
      end
      if !ret && has_cave_encounters?
        ret = find_valid_encounter_type_for_time(:OverworldCave, time)
        ret = find_valid_encounter_type_for_time(:Cave, time) if !ret && VisibleEncounterSettings::LET_NORMAL_ENCOUNTERS_SPAWN
      end
    end
    return ret
  end
end


#===============================================================================
# we register the new Overworld EncounterTypes
#===============================================================================
GameData::EncounterType.register({
  :id             => :OverworldLand,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandDay,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandNight,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandMorning,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandAfternoon,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldLandEvening,
  :type           => :land,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCave,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveDay,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveNight,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveMorning,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveAfternoon,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldCaveEvening,
  :type           => :cave,
  :trigger_chance => 25,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWater,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterDay,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterNight,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterMorning,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterAfternoon,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldWaterEvening,
  :type           => :water,
  :trigger_chance => 20,
  :old_slots      => [60, 30, 5, 4, 1]
})

GameData::EncounterType.register({
  :id             => :OverworldBugContest,
  :type           => :contest,
  :trigger_chance => 41,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

#===============================================================================
#                   FOR ROAMING POKEMON
# overwriting Method pbRoamingMethodAllowed in Class PokemonEncounters in Script
# visible overworld wild encounters to include new roamer methods. 
#
# Note that cases 1 to 4 are exactly the same as in the visible overworld wild 
# encounters script. Only the cases 5 and 6 are new.
# 1 to 4  - triggers for normal encounterTypes and for overworld encounterTypes,
#    5    - means purely Overworld Surfing, and
#    6    - means purely Normal Land. 
# Uncomment the following code and modify the cases of roamer methods, or add 
# your own new roamer methods as you want.
#===============================================================================

#def pbRoamingMethodAllowed(roamer_method)
#  enc_type = $PokemonTemp.encounterType # $PokemonTemp.encounterType stores the encounter type of the chosen tile
#  id = GameData::EncounterType.get(enc_type).id
#  type = GameData::EncounterType.get(enc_type).type
#  case roamer_method
#  when 0   # Any step-triggered method (except Bug Contest)
#    return [:land, :cave, :water].include?(type)
#  when 1   # Walking (except Bug Contest)
#    return [:land, :cave].include?(type)
#  when 2   # Surfing
#    return type == :water
#  when 3   # Fishing
#    return type == :fishing
#  when 4   # Water-based
#    return [:water, :fishing].include?(type)
#  when 5   # purely Overworld Surfing
#    return [:OverworldWater, :OverworldWaterDay, :OverworldWaterNight, :OverworldWaterMorning,  :OverworldWaterAfternoon,  :OverworldWaterEvening].include?(id)
#  when 6   # purely Normal Land Encounters (except Bug Contest)
#    return [:OverworldLand, :OverworldLandDay, :OverworldLandNight, :OverworldLandMorning,  :OverworldLandAfternoon,  :OverworldLandEvening].include?(id)
#  end
#  return false
#end
