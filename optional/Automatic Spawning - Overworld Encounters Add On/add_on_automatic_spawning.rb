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
module VisibleEncounterSettings
  AUTO_SPAWN_SPEED = 60 # default 60
  #You can set the speed of automatic pokemon spawning, i.e. the ability of pokemon
  # to spawn automatically even without even moving the player.
  #0   - means that pokemon only spawn while the player is moving
  #>0  - means automatic spawning is activated, the closer to 0 the faster the spawning
end

#===============================================================================
# adding method to event :on_frame_update for automatic sapwning
#===============================================================================
EventHandlers.add(:on_frame_update, :automatic_spawning,
  proc {
    next if !$player
    repel_active = ($PokemonGlobal.repel > 0)
    next if repel_active
    $framecounter = 0 if !$framecounter 
    $framecounter = $framecounter + 1
    next unless $framecounter == VisibleEncounterSettings::AUTO_SPAWN_SPEED
    $framecounter = 0
    pbSpawnOnStepTaken(repel_active) if !pbBattleOrSpawnOnStepTaken(repel_active) 
  }
)
