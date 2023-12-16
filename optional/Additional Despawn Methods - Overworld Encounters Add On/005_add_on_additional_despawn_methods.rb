####################################################################################
####################################################################################
#                ADD-ON by TrankerGolD 
####################################################################################
####################################################################################

# FEATURES:
#   - Choose to remove PokeEvent distanced on screen from the player with REMOVE_DISTANCED
#   - The distance (steps) is edited in DISTANCE_VANISH and DISTANCE_VANISH_SHINY
#   - Remove by time chronometer with REMOVE_PROLONGED

module VisibleEncounterSettings
  #------------(SCREEN DISTANCE DESPAWNING)-------------------
  REMOVE_DISTANCED = false #default false
  # this is used if you want a mechanic that removes PokeEvents when
  # distancing from them
  #false - means nothing happens
  #true - means distanced PokeEvent will disappear
  # (regardless of this parameter PokeEvents will despawn when being
  # completely in another map)
  DISTANCE_VANISH = 12 # default 12
  #      DISTANCE_VANISH is the max distance on screen a wild Encounter can be
  #      from the player before vanishing on the map.
  #<=0  - means infinite distance (wont disappear from distance)
  DISTANCE_VANISH_SHINY = 30 # default 30 (or 0 ?)
  #      DISTANCE_VANISH_SHINY is the max distance on screen a shiny wild Encounter can be
  #      from the player before vanishing on the map.
  #<=0  - means infinite distance (wont disappear from distance)
  #------------------------------------------------------------
  
  #------------(SECONDS PROLONGED DESPAWNING)-------------------
  REMOVE_PROLONGED = false #default false
  # this is used if you want a mechanic that removes PokeEvents when
  # being a prolonged time active
  #false - means nothing happens
  #true - means prolonged PokeEvent will disappear
  SECONDS_VARIATION = 5 # default 5
  #      SECONDS_VARIATION is the maximum time in seconds randomized
  #      that will be added or substracted to the actual seconds
  #      (5 seconds variation to 25 will be 20-30 seconds randomly)
  SECONDS_BEFORE_VANISH = 25 # default 25
  #      SECONDS_BEFORE_VANISH is the max time in secons a wild Encounter can be
  #      active before vanishing on the map.
  #<=0  - means infinite time (wont disappear from time)
  SECONDS_BEFORE_VANISH_SHINY = 50 # default 50 (or 0 ?)
  #      SECONDS_BEFORE_VANISH_SHINY is the max time in secons a shiny wild Encounter can be
  #      active before vanishing on the map.
  #<=0  - means infinite time (wont disappear from time)
  #------------------------------------------------------------
end

# also replacing method update
#   - if REMOVE_DISTANCED is activated calculates the screen distance from the
#   PokeEvent to the Player and make them disappear after separeting exactly
#   DISTANCE_VANISH tiles, and for shiny if exactly DISTANCE_VANISH_SHINY tiles
#   - if REMOVE_PROLONGED is activated checks by frames how long has the
#   PokeEvent being active, and make them disappear after waiting
#   SECONDS_BEFORE_VANISH seconds, and for shiny SECONDS_BEFORE_VANISH_SHINY seconfs

class Game_PokeEvent < Game_Event
  attr_accessor :frameCount #counts the existence frames of an overworld encounter

  alias o_update update
  def update
    o_update
    return if $game_temp.in_menu
    #REMOVE DISTANCED
    if VisibleEncounterSettings::REMOVE_DISTANCED
      sx = (self.screen_x - $game_player.screen_x).abs
      sy = (self.screen_y - $game_player.screen_y).abs
      distance = [sx,sy].max
      if self.pokemon.shiny? && VisibleEncounterSettings::DISTANCE_VANISH_SHINY>0 && distance>=VisibleEncounterSettings::DISTANCE_VANISH_SHINY*32
        removeThisEventfromMap
      elsif VisibleEncounterSettings::DISTANCE_VANISH>0 && distance>=VisibleEncounterSettings::DISTANCE_VANISH*32
        removeThisEventfromMap
      end
    end
    #REMOVE PROLONGED
    @frameCount=0 if !@frameCount
    if VisibleEncounterSettings::REMOVE_PROLONGED
      varTime = VisibleEncounterSettings::SECONDS_VARIATION
      extraTime = rand(varTime*2)+1 - varTime
      time = VisibleEncounterSettings::SECONDS_BEFORE_VANISH
      time = VisibleEncounterSettings::SECONDS_BEFORE_VANISH_SHINY if self.pokemon.shiny?
      if  time>0
        removeThisEventfromMap if @frameCount > ((time + extraTime) * Graphics.frame_rate)
      end
    end
    @frameCount+=1
  end

end
