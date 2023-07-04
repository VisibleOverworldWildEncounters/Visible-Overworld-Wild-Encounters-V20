#===============================================================================
# Add-On: the spawned pokemon will not leave there terrain/ grass * by derFischae
#===============================================================================

# This is an add-on for the visible overworld wild encounter script.
# It restricts the movement of spawned pokemon to there spawning terrain.
# I.e. grass encounters stay on grass and will move around grass field but not come out of the grass.
# The same holds for all other terrains, such as sand, mud, or whatever else you added to your project.


# FEATURES INCLUDED:
#  - Overworld spawned Grass/Water/Sand/etc encounters move only on Grass/Water/Sand tiles and not leave there terrain.
#  - You can activate the restriction and deactivate it by setting the parameter RESTRICT_MOVEMENT in the settings section below.

# INSTALLATION:
# 1) Place the folder in your plugins folder
# 2) Open the file 001_add_on_restrict_movement.rb and change the the parameters to your liking in the settings section.


#===============================================================================
# Settings
#===============================================================================
module VisibleEncounterSettings
    RESTRICT_MOVEMENT = true # default true
    #With this parameter, you restrict the movement of spawned pokemon to there terrain.
    #true   - means that spawned pokemon will not leave there spawning terrain
    #false  - means that spawned pokemon can move as usual overworld npcs
end


class Game_PokeEvent < Game_Event
  
  alias o_passable? passable?
  
  def passable?(x, y, d, strict = false)
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
    return false unless self.map.valid?(new_x, new_y)
    return false if  VisibleEncounterSettings::RESTRICT_MOVEMENT == true && terrain_tag != self.map.terrain_tag(new_x, new_y)
    return o_passable?(x, y, d, strict)
  end
end
