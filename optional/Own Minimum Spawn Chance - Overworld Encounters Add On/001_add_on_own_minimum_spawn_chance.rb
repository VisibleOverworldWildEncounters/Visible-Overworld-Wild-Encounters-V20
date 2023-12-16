
          #########################################################
          #                                                       #
          #          ADD-ON:  OWN MINIMUM SPAWN CHANCE            #
          #                                                       #
          #########################################################

# As we all know, it is annoying to run into the next wild battle just a few steps after your last one.
# That's why Pokemon Essentials v19 implements an encounter chance that is low after a wild battle and
# increases each step. So, it might suppress 8 pokemons to spawn, before a new pokemon encounters.
# This is totally fine for normal encounters. Unfortunately, this might result in an odd behaviour for spawning encounters, since the encounter chance will be reset after a battle and not after a pokemon has spawned.
# it will take long for the first pokemon to spawn, and then it will be fast and gets even faster the more steps the game player makes, until the game player runs into a pokemon and triggers a battle.

# This Add-On gets rid of this odd behaviour.

# FEATURES
# [*] The Spawn probability of the first encounter and later ones are similar.
# [*] Spawning does not interact with the encounter chance for normal encounters.
# [*] Increase the average spawning time of pokeon by setting MAX_ENCOUNTER_REDUCED larger than zero in the settings section of this script

# SETTINGS
module VisibleEncounterSettings
  #------------- MAXIMAL NUMBER OF ENCOUNTERS WITH REDUCED ENCOUNTER PROBABILITY ------------ 
  MAX_ENCOUNTER_REDUCED = 0 # default 8 - means that at most 8 pokemon will have a drastically reduced spawn probability before it become the usual encounter probability
  # 0   - means that all pokemon have the encounter probability as it is set by you for the maps and the encounter type, grass, cave, water.
  # >0  - means that the first at most that given number of pokemon will have a drastically reduced spawn probability and might not make it. This will increase the average spawning time for every pokemon.
end

class PokemonEncounters
  def reset_ow_step_count
    @ow_step_count = 0
    @ow_chance_accumulator = 0
  end

  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    @ow_step_count = 0 if !@ow_step_count
    @ow_chance_accumulator = 0 if !@ow_chance_accumulator
    if !enc_type || !GameData::EncounterType.exists?(enc_type)
      raise ArgumentError.new(_INTL("Encounter type {1} does not exist", enc_type))
    end
    return false if $game_system.encounter_disabled
    return false if !$player
    return false if $DEBUG && Input.press?(Input::CTRL)
    # Check if enc_type has a defined step chance/encounter table
    return false if !@step_chances[enc_type] || @step_chances[enc_type] == 0
    return false if !has_encounter_type?(enc_type)
    # Poké Radar encounters always happen, ignoring the minimum step period and
    # trigger probabilities
    return true if pbPokeRadarOnShakingGrass
    # Get base encounter chance and minimum steps grace period
    encounter_chance = @step_chances[enc_type].to_f
    min_steps_needed = (VisibleEncounterSettings::MAX_ENCOUNTER_REDUCED - encounter_chance / 10).clamp(0, 8).to_f
    # Apply modifiers to the encounter chance and the minimum steps amount
    if triggered_by_step
      encounter_chance += @ow_chance_accumulator / 200
      encounter_chance *= 0.8 if $PokemonGlobal.bicycle
    end
    if !Settings::FLUTES_CHANGE_WILD_ENCOUNTER_LEVELS
      encounter_chance /= 2 if $PokemonMap.blackFluteUsed
      min_steps_needed *= 2 if $PokemonMap.blackFluteUsed
      encounter_chance *= 1.5 if $PokemonMap.whiteFluteUsed
      min_steps_needed /= 2 if $PokemonMap.whiteFluteUsed
    end
    first_pkmn = $player.first_pokemon
    if first_pkmn
      case first_pkmn.item_id
      when :CLEANSETAG
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      when :PUREINCENSE
        encounter_chance *= 2.0 / 3
        min_steps_needed *= 4 / 3.0
      else   # Ignore ability effects if an item effect applies
        case first_pkmn.ability_id
        when :STENCH, :WHITESMOKE, :QUICKFEET
          encounter_chance /= 2
          min_steps_needed *= 2
        when :SNOWCLOAK
          if GameData::Weather.get($game_screen.weather_type).category == :Hail
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SANDVEIL
          if GameData::Weather.get($game_screen.weather_type).category == :Sandstorm
            encounter_chance /= 2
            min_steps_needed *= 2
          end
        when :SWARM
          encounter_chance *= 1.5
          min_steps_needed /= 2
        when :ILLUMINATE, :ARENATRAP, :NOGUARD
          encounter_chance *= 2
          min_steps_needed /= 2
        end
      end
    end
    # Wild encounters are much less likely to happen for the first few steps
    # after a previous wild encounter
    if triggered_by_step && @ow_step_count < min_steps_needed
      @ow_step_count += 1
      return false if rand(100) >= encounter_chance * 5 / (@step_chances[enc_type] + @ow_chance_accumulator / 200)
    end
    # Decide whether the wild encounter should actually happen
    return true if rand(100) < encounter_chance
    # If encounter didn't happen, make the next step more likely to produce one
    if triggered_by_step
      @ow_chance_accumulator += @step_chances[enc_type]
      @ow_chance_accumulator = 0 if repel_active
    end
    return false
  end
end

EventHandlers.add(:on_wild_pokemon_created_for_spawning, :reset_ow_step_count, proc{
  $PokemonEncounters.reset_ow_step_count
})
