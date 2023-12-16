
#===============================================================================
#                       ADD-ON: Reroll Spawn Tile
#                           by TrankerGolD
#===============================================================================

# Pokemon only spawn on allowed ground. This reduces the probability of spawning
# if there is only few grass around the player.

# This add on can be used to increase the probability, by checking more than only
# one random tile around the player. 

# Set up to how many different tiles will be checked around the player in the
# parameter NO_OF_CHOSEN_TILES below. But be careful, it might produce lag with
# other scripts.

# Features
#  [*] stabilizes the probability of spawning on maps with low grass by choosing
#      another tile if the previous random chosen one does not allow spawning  
#  [*] set the maximal number of tiles chosen for spawning in parameter
#      NO_OF_CHOSEN_TILES
#  [*] be careful, it might produce lag with other scripts

#===============================================================================
#       Settings
#===============================================================================

module VisibleEncounterSettings

  NO_OF_CHOSEN_TILES = 1 # default 1
  # Pokemon only spawn on allowed ground. This parameter needs to be an integer.
  # It says up to how many different, random tiles in SPAWN_RANGE to the player
  # will be checked for beeing allowed spawning ground.
  # = 0  - means that it will choose a random tile until one of them 
  #       is possible to spawn a pokemon or all tiles in SPAWN_RANGE to the player were chosen
  #       (this will increase the spawn probability)
  #       (may cause lag with other scripts)
  # = 1  - means that only one random tile around the player will be chosen
  # > 1   - maximal number of chosen tiles to find a possible tile where a pokemon can spawn
  #         (the more you use, more performance needed)

end

#===============================================================================
#        Script
#===============================================================================


def pbChooseTileOnStepTaken
    x = $game_player.x
    y = $game_player.y
    range = VisibleEncounterSettings::SPAWN_RANGE
    rolls = VisibleEncounterSettings::NO_OF_CHOSEN_TILES # maybe 1 or higher or 0 (means rolling till there are all tiles checked near player)
    rolls = 8*range*(range+1)/2 if rolls > 8*range*(range+1)/2 || rolls <= 0
    positions = []
    for j in 0..rolls-1 do
      if j == 0
        i = rand(range)
        r = rand((i+1)*8)
      else
        k = rand(positions.length)
        i,r = positions[k]
      end
      if r<=(i+1)*2
        new_x = x-i-1+r
        new_y = y-i-1
      elsif r<=(i+1)*6-2
        new_x = [x+i+1,x-i-1][r%2]
        new_y = y-i+((r-1-(i+1)*2)/2).floor
      else
        new_x = x-i+r-(i+1)*6
        new_y = y+i+1
      end
      return [new_x,new_y] if pbTileIsPossible(new_x,new_y)
      return if j >= rolls-1
      if j == 0
        for i2 in 0..range-1
          for r2 in 0..(i2+1)*8-1
            positions.push([i2,r2])
          end
        end
      end
      positions.delete([i,r])
      return if positions.length == 0
    end
    return
  end
  
