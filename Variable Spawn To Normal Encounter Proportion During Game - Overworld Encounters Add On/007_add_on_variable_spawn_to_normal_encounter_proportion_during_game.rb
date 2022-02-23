
#=======================================================================
# ADD-ON: Variable Spawn/Normal Encounter Proportion During Game
#=======================================================================

# This ADD-ON let's you change the percentage between overworld spawning
# pokemon and normal encounters during playthrough.
# 
# Most fan-game-developers don't need to change that percentage during
# the story of their game runs forward. But, for example, if you plan
# that there are no overworld pokemon anymore (still normal encounters)
# after an important storydriven cutscene and they only come back after
# your hero saved the day, then this ADD-ON is for you.  
#
# You can get and change the current instant battle probability by using
# getInstantChance and setInstantChance(value) in an event on the map.
#
# Please set the parameter OVERWORLD_ENCOUNTER_VARIABLE (see below) as you need it.
# This parameter stores the ID of the $game_variable which holds the propability
# of normal to overworld encountering. Make sure that no other script uses
# the $game_variable with this ID.
# And also don't forget to set the parameter INSTANT_WILD_BATTLE_PROPABILITY
# in the settings section of the visible overworld wild encounters script
# as you need it for the start of your game.

# The outcome of getInstantChance means
#    < 0        - means only overworld encounters
#    = 0        - means the propability of instant battle to spawning will be equal to the value 
#                 of INSTANT_WILD_BATTLE_PROPABILITY in percentage, see settings section
#                 of visible overworld wild encounters script
# > 0 and < 100 - means overworld encounters and normal encounters at the same time,
#                 where the value equals the propability of normal encounters in percentage
#   >= 100      - means only normal encounters and instant battles as usual, no overworld spawning

# The outcome for setInstantChance(value) depends on the value. If value is
#   <= 0        - means only overworld encounters
#    nil        - means the propability of instant battle to spawning will be equal to the value 
#                 of INSTANT_WILD_BATTLE_PROPABILITY in percentage, see settings section
#                 of visible overworld wild encounters script
# > 0 and < 100 - means overworld encounters and normal encounters at the same time,
#                 where the value equals the propability of normal encounters in percentage
#   >= 100      - means only normal encounters and instant battles as usual, no overworld spawning

 
module VisibleEncounterSettings
  OVERWORLD_ENCOUNTER_VARIABLE = 26 # default is an ID which is not used anywhere else
  # This parameter stores the ID of the $game_variable which holds the propability
  # of normal to overworld encountering.
  # Make sure that no other script uses the $game_variable with this ID,
  # except for the visible overworld wild encounter script itself and its add-ons.
  #
  # The $game_variable with the ID equal to OVERWORLD_ENCOUNTER_VARIABLE is used 
  # to store the propability of an instant (normal) wild battle.
  # You can modify the value of that $game_variable during game or with events as usual. It is similar to use
  # game switches. See the Pokemon Essentials manual for more informations.
  # The propability is stored the following way
  # $game_variables[OVERWORLD_ENCOUNTER_VARIABLE] = 0
  #    - the propability of instant battle to spawning will be equal to the value 
  # of INSTANT_WILD_BATTLE_PROPABILITY in percentage, see settings section of visible overworld wild encounters script
  # $game_variables[OVERWORLD_ENCOUNTER_VARIABLE] < 0
  #    - means only overworld encounters, no instant battles
  # $game_variables[OVERWORLD_ENCOUNTER_VARIABLE] > 0 and < 100
  #    - means overworld encounters and normal encounters at the same time,
  #      where the value equals the propability of normal encounters in percentage
  # $game_variables[OVERWORLD_ENCOUNTER_VARIABLE] >= 100 
  #    - means only normal encounters and instant battles as usual, no overworld spawning
  
  # Note that INSTANT_WILD_BATTLE_PROPABILITY will be used when starting the game the first time.
  # Changing this value later on will not affect the propability anymore.
  # However, you can still change the propability stored in the $game_variable with ID above during runtime.
  # This parameter holds the DEFAULT propability of normal to overworld encountering.
  # The propability is stored in percentage with possible values 0,1,2,...,100.
  # <= 0           - means only overworld encounters, no instant battles
  # > 0 and < 100  - means overworld encounters and normal encounters at the same time.
  # >= 100         - means only normal encounters and instant battles as usual, no overworld spawning
  # You can still change the propability stored in the $game_variable with ID above during runtime.
  # But if you don't change the propability ingame, then it will be this INSTANT_WILD_BATTLE_PROPABILITY
  # Note that, if $game_variables[OVERWORLD_ENCOUNTER_VARIABLE] = 0 then the propability stored in that $game_variable will be reset to
  # the value of INSTANT_WILD_BATTLE_PROPABILITY, unless this is also 0.  

end

#===============================================================================
# overwriting Method pbBattleOrSpawnOnStepTaken in the visible overworld wild
# encounters script to the probability between normal encountering and overworld
# spawning variable during play
#===============================================================================
def pbBattleOrSpawnOnStepTaken(repel_active)
  setInstantChance if getInstantChance == 0
  if (rand(100) < getInstantChance) || pbPokeRadarOnShakingGrass
    return true # STANDARD WILD BATTLE
  else
    return false  # OVERWORLD ENCOUNTERS
  end
end
  
#===============================================================================
# Method shortcuts for variable from OVERWORLD_ENCOUNTER_VARIABLE
#===============================================================================
def getInstantChance
  return $game_variables[VisibleEncounterSettings::OVERWORLD_ENCOUNTER_VARIABLE]
end
  
def setInstantChance(value=nil)
  value = VisibleEncounterSettings::INSTANT_WILD_BATTLE_PROPABILITY if !value
  value = -1 if value <= 0
  value = 100 if value >= 100
  $game_variables[VisibleEncounterSettings::OVERWORLD_ENCOUNTER_VARIABLE] = value
end
