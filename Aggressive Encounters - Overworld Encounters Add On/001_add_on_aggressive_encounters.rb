
#=======================================================================
# ADD-ON: Aggressive Encounters
#=======================================================================

# This ADD-ON introduces aggressive encounters, which are pokemon that follow the player after spawning.
# 
# You can set the move speed and movee frequency of aggressive pokemon.
# 
# FEATURES:
#  - introduces aggressive encounters, which are pokemon that chase the player after spawning
#  - aggressive encounters may only start to chase if the player comes them to close
#  - set the move speed, move frequency and move type of aggressive pokemon
#  - aggressive ecounters are restricted to player movements
#  - add animations to aggressive encounters. See Additional Animations -Add On and TrankerGolD's animations for aggressive encounters
#    at https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383 to include spawning animations in your game


# SETTINGS

module VisibleEncounterSettings
  AGGRESSIVE_ENCOUNTER_PROBABILITY = 20 # default 20 
  #this is the probability in percent of spawning of an aggressive encounter, that runs to you
  #0   - means that there are no aggressive encounters
  #100 - means that all encounter are aggressive

  AGG_ENC_SPAWN_MOVEMENT = [3, 3, 1] # default [3, 5, 3] -  means that aggressive encounters will be faster and run to the player
  # This is used to store the movement data of aggressive encounters. 
  # The data is stored as an array of entries [move_speed, move_frequency, move_type],
  # where move_speed, move_frequency and move_type and  are the movement speed,
  # frequency and type all aggressive encounters should get.
  # nil  - means that the movement-parameter will not be changed.
  # move_type = 1  - means random movement
  # move_type = 3  - means movement toward player

  AGG_ENC_SWITCH_MOVEMENT = [3, 5, 2] # default [3, 5, 2] -  means that aggressive encounters will be faster and run to the player
  # This is used to store the movement data of aggressive encounters. 
  # The data is stored as an array of entries [move_speed, move_frequency, move_type],
  # where move_speed, move_frequency and move_type and  are the movement speed,
  # frequency and type all aggressive encounters should get.
  # nil  - means that the movement-parameter will not be changed.
  # move_type = 1  - means random movement
  # move_type = 2  - means movement toward player


  ADD_STEPS_BEFORE_AGG_ENC_VANISH = 6 # default 6 - means that spawned aggressive pokemon will stay longer (6 steps more) on the map
  # This is the number of additional steps (of less steps if the number is negative) an aggressive pokemon takes before it vanishes.

  AGG_ON_DISTANCE = 2 # default 2
  # This is an integer
  #  0  - means the aggressive pokemon will not switch its movement when player is close to the pokemon
  # >0  - means the aggressive pokemon will switch its movement when the player is at most that much tiles away

  AGG_ANIMATIONS = [7, nil, nil] # default [7, nil, nil]
  # This stores the IDs of your animations in database, where the first animation
  # 1st entry  - the id of the animation in database that triggers when a pokemon becomes aggressive if the player comes it to close.
  # 2nd entry  - the id of the animation in database that triggers on spawning of the aggressive encounter (needs additional animations add on)
  # 3rd entry  - the id of the animation in database that plays permanently as long as the pokemon is on the screen (needs additional animations add on)
  #  nil  - means no animation
  # So create new animations in database. See also TrankerGolD's animations for aggressive encounters at https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383
  # Don't forget to edit animation_id in settings script (line 199),
  #     (if the id number is bigger than the database number of animations it will crash the game).

end


# THE SCRIPT
VisibleEncounterSettings::Enc_Movements.push(
  [:aggressive, true, VisibleEncounterSettings::AGG_ENC_SPAWN_MOVEMENT[0], VisibleEncounterSettings::AGG_ENC_SPAWN_MOVEMENT[1], VisibleEncounterSettings::AGG_ENC_SPAWN_MOVEMENT[2]]
)

VisibleEncounterSettings::Add_Steps_Before_Vanish.push(
  [:aggressive, true, VisibleEncounterSettings::ADD_STEPS_BEFORE_AGG_ENC_VANISH]
)

if VisibleEncounterSettings::Enc_Spawn_Animations and VisibleEncounterSettings::AGG_ANIMATIONS[1] != nil
  VisibleEncounterSettings::Enc_Spawn_Animations.push(
    [:aggressive, true, VisibleEncounterSettings::AGG_ANIMATIONS[1]]
  )
end

if VisibleEncounterSettings::Perma_Enc_Animations and VisibleEncounterSettings::AGG_ANIMATIONS[2] != nil
  VisibleEncounterSettings::Perma_Enc_Animations.push(
    [:aggressive, true, VisibleEncounterSettings::AGG_ANIMATIONS[2]] 
  )
end


class Game_PokeEvent < Game_Event
  attr_accessor :move_type
end

class Pokemon
  #===============================================================================
  # adding new variable aggressive in Class Pokemon. Every spawned, aggressive 
  # Pokemon, i.e. a Pokemon that follows you on the map has this variable set true
  #===============================================================================
  attr_accessor :aggressive
  attr_accessor :chasing

  #===============================================================================
  # adding new Method aggressive? in Class Pokemon
  #===============================================================================
  def aggressive?(encType)
    return self.aggressive if self.aggressive == true || self.aggressive == false
    encType = GameData::EncounterType.try_get(encType)
    if encType
      #aggressive Pokemon on water only when surfing, and on land when not surfing
      if (!$PokemonGlobal.surfing && encType.type == :water) || ($PokemonGlobal.surfing && encType.type != :water)
        self.aggressive = false 
        return false
      end
    end
    if rand(100) < VisibleEncounterSettings::AGGRESSIVE_ENCOUNTER_PROBABILITY
      self.aggressive = true
      return true
    end
  end
end

#-------------------------------------------------------------------------------
# adding this process to the Event onWildPokemonCreateForSpawning to distinguish 
# between aggressive encounters and non-aggressive ones
#-------------------------------------------------------------------------------
Events.onWildPokemonCreateForSpawning += proc { |_sender,_e|
  pokemon = _e[0]
  encType = GameData::EncounterType.try_get($PokemonTemp.encounterType)
  pokemon.aggressive?(encType)
}

#===============================================================================
# We override the method "pbOnStepTaken" in the overworld encounters script it
# was originally used for wild encounter battles
#===============================================================================
alias o_pbOnStepTaken pbOnStepTaken

def pbOnStepTaken(eventTriggered)
  if VisibleEncounterSettings::AGG_ON_DISTANCE > 0
    for event in $game_map.events.values
      if event.is_a?(Game_PokeEvent) && event.pokemon.aggressive && !event.pokemon.chasing && (event.x - $game_player.x).abs <= VisibleEncounterSettings::AGG_ON_DISTANCE && (event.y - $game_player.y).abs <= VisibleEncounterSettings::AGG_ON_DISTANCE
        event.move_speed = VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[0] if VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[0]
        event.move_frequency = VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[1] if VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[1]
        event.move_type = VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[2] if VisibleEncounterSettings::AGG_ENC_SWITCH_MOVEMENT[2]
        $scene.spriteset.addUserAnimation(VisibleEncounterSettings::AGG_ANIMATIONS[0],event.x,event.y,true,1)
      end
    end
  end
  o_pbOnStepTaken(eventTriggered)
end
