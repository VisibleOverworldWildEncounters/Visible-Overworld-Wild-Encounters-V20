
#=======================================================================
# ADD-ON: Aggressive Encounters
#=======================================================================

# This ADD-ON introduces aggressive encounters, which are pokemon that follow the player after spawning for fighting.
# 
# FEATURES:
#  - Adds aggressive encounters to your game, which want to run to the player to attack
#  - Aggressive ecounters are restricted to player movements
#  - You can set the move speed and movee frequency of aggressive pokemon
#  - See Additional Animations - Add On and TrankerGolD's animations for aggressive encounters
#    at https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383 to include spawning animations in your game


# SETTINGS

module VisibleEncounterSettings
  AGGRESSIVE_ENCOUNTER_PROBABILITY = 20 # default 20 
  #this is the probability in percent of spawning of an aggressive encounter, that runs to you
  #0   - means that there are no aggressive encounters
  #100 - means that all encounter are aggressive

  AGG_ENC_MOVEMENT = [3, 5, 3] # default [3, 5, 3] -  means that aggressive encounters will be faster and run to the player
  # This is used to store the movement data of aggressive encounters. 
  # The data is stored as an array of entries [move_speed, move_frequency, move_type],
  # where move_speed, move_frequency and move_type are the movement speed,
  # frequency and type all aggressive encounters should get.
  # nil  - means that the movement-parameter will not be changed.
  
  ADD_STEPS_BEFORE_AGG_ENC_VANISH = 6 # default 6 - means that spawned aggressive pokemon will stay longer (6 steps more) on the map
  # This is the number of additional steps (of less steps if the number is negative) an aggressive pokemon takes before it vanishes.
end


# THE SCRIPT
VisibleEncounterSettings::Enc_Movements.push(
  [:aggressive, true, VisibleEncounterSettings::AGG_ENC_MOVEMENT[0], VisibleEncounterSettings::AGG_ENC_MOVEMENT[1], VisibleEncounterSettings::AGG_ENC_MOVEMENT[2]]
)

VisibleEncounterSettings::Add_Steps_Before_Vanish.push(
  [:aggressive, true, VisibleEncounterSettings::ADD_STEPS_BEFORE_AGG_ENC_VANISH]
)

class Pokemon
  #===============================================================================
  # adding new variable aggressive in Class Pokemon. Every spawned, aggressive 
  # Pokemon, i.e. a Pokemon that follows you on the map has this variable set true
  #===============================================================================
  attr_accessor :aggressive

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

Events.onWildPokemonCreateForSpawning+=proc {|sender,e|
  pkmn = e[0]
  pkmn.aggressive?(GameData::EncounterType.try_get($PokemonTemp.encounterType))
}
