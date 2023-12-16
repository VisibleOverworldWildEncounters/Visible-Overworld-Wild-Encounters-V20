#===============================================================================
# Ditto Transform - Overworld Encounters Add-On * by derFischae
#===============================================================================

# This is an add-on for the visible overworld wild encounter script.
# It adds automatic pokemon spawning to the script.

# FEATURES INCLUDED:
#  - Like in Pokemon Go, transformable Pokemon such as Ditto get the overworld appearence of different species
#  - Choose in settings if completely random, set by a list of candidates or set by the map encounters

# INSTALLATION:
# 1) Place the folder of this plugin in your plugins folder
# 2) Open the file add_on_automatic_spawning.rb and change the parameter TRANSFORMS to your liking in the settings section.


#===============================================================================
#    Settings
#===============================================================================
module VisibleEncounterSettings
  TRANSFORMS = [                      # default
    [:DITTO],                         # means - Ditto will have any overworld appearence of encounters of the map where you are
    [:MEW, nil],                      #       - Mew will have overworld appearence of any random species
    [:SMEARGLE, :BULBASAUR, :PIDGEY]  #       - Smeargle will have the overworld sprite of one of the following pokemon, i.e. bulbasaur and pidgey.
  ]
  # This parameter is used to change the overworld appearence of pokemon such as ditto.
  # The data is stored as an array of arrays. You can add your own arrays or change/remove the existing.
  # The first entry  - is the species that transforms its overworld appearence.
  # No more entries  - means the species have any overworld appearence of encounters of the map where the player is.
  # nil              - means the species will have overworld appearence of any random species.
  # species names    - means the species will have random overworld appearence of one of that following species.
end


#===============================================================================
#    Script
#===============================================================================

#-------------------------------------------------------------------------------
# Overwriting method ow_sprite_filename to include ditto transform 
#-------------------------------------------------------------------------------
alias ditto_ow_sprite_filename ow_sprite_filename
def ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
  for transform in VisibleEncounterSettings::TRANSFORMS
    next if transform[0] != species.to_sym
    if transform.size == 1
      encounter = $PokemonEncounters.choose_wild_pokemon($game_temp.encounter_type)
      return ditto_ow_sprite_filename(encounter[0].to_s, form, gender, shiny, shadow)
    elsif transform.size == 2 && !transform[1]
      keys = GameData::Species.keys
      k = rand(keys.size)
      species = keys[k]
      return ditto_ow_sprite_filename(species, form, gender, shiny, shadow)
    else
      k = rand(transform.size-1)
      species = transform[k+1]
      return ditto_ow_sprite_filename(species, form, gender, shiny, shadow)
    end
  end
  return ditto_ow_sprite_filename(species, form, gender, shiny, shadow)
end
