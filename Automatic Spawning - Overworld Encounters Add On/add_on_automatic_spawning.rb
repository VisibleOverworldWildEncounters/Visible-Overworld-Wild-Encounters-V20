#===============================================================================
# Add-On for automatic spawning without making a step * by derFischae
#===============================================================================

# This is an add-on for the visible overworld wild encounter script.
# It adds automatic pokemon spawning to the script.

# FEATURES INCLUDED:
#  - Choose whether pokemon spawn automatically or only while moving the player
#  - Set the speed of automatic spawning

# INSTALLATION:
# 1) Place the folder in your plugins folder
# 2) Open the file add_on_automatic_spawning.rb and change the the parameter AUTO_SPAWN_SPEED to your liking in the settings section.

# PROPERTIES:
# You can choose whether pokemon can spawn automatically or only while the 
# player is moving and you can set the spawning frequency in the parameter
#     AUTO_SPAWN_SPEED
# in the settings below

#===============================================================================
# Settings
#===============================================================================
AUTO_SPAWN_SPEED = 60 # default 60
#You can set the speed of automatic pokemon spawning, i.e. the ability of pokemon
# to spawn automatically even without even moving the player.
#0   - means that pokemon only spawn while the player is moving
#>0  - means automatic spawning is activated, the closer to 0 the faster the spawning

#===============================================================================
# Overriding the update method of the class Game_Map in script section Game_Map
#===============================================================================
class Game_Map
  
  alias original_update update
  def update
    original_update
    return unless $Trainer
    return if $PokemonGlobal.repel>0
    repel_active = ($PokemonGlobal.repel > 0)
    #repel = ($PokemonGlobal.repel>0)
    $framecounter = 0 if !$framecounter 
    $framecounter = $framecounter + 1
    return unless $framecounter >= AUTO_SPAWN_SPEED
    $framecounter = 0
    pbSpawnOnStepTaken(repel_active) if !pbBattleOrSpawnOnStepTaken(repel_active) 
  end
end
