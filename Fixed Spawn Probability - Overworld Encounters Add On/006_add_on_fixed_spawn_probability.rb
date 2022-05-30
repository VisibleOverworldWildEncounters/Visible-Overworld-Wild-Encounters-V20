
          #########################################################
          #                                                       #
          #          ADD-ON:  FIXED SPAWN PROBABILITY             #
          #                                                       #
          #########################################################


# FEATURES
# [*] Use your own overworld spawn chance in VISIBLE_ENCOUNTER_PROBABILITY


# With this add-on, you can set the overworld encounter chance with a fixed 
# percentage in the parameter
#       VISIBLE_ENCOUNTER_PROBABILITY (see below)
# If VISIBLE_ENCOUNTER_PROBABILITY > 0 then overworld spawning will not use the
# default PEv20 encounter chance calculator anymore.


module VisibleEncounterSettings
  VISIBLE_ENCOUNTER_PROBABILITY = 80 # default 0
  # The PokeEvent will spawn according to this probability if the value is greater than 0
  # <= 0           - means only using the default PEv19.1 encounter chance calculator
  # > 0 (1..100)   - means using this probabilty out of 100 instead of normal chance
end

class PokemonEncounters
  #===============================================================================
  # overwriting Method encounter_triggered_on_tile? to Class PokemonEncounters in 
  # Script section visible overworld wild encounters to include returns a different
  # encounter chance for overworld wild encounters
  #===============================================================================  
  def encounter_triggered_on_tile?(enc_type, repel_active = false, triggered_by_step = true)
    if VisibleEncounterSettings::VISIBLE_ENCOUNTER_PROBABILITY>0
      if !enc_type || !GameData::EncounterType.exists?(enc_type)
        raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
      end
      return false if $game_system.encounter_disabled
      return false if !$player
      return false if $DEBUG && Input.press?(Input::CTRL)
      return false if !(rand(100) < VisibleEncounterSettings::VISIBLE_ENCOUNTER_PROBABILITY)
      return true
    else
      return $PokemonEncounters.encounter_triggered?(enc_type, repel_active, true)
    end  
  end
end
