          #########################################################
          #                                                       #
          #            ADD-ON:  ADDITIONAL ANIMATIONS             #
          #                                                       #
          #########################################################

# FEATURES:
# [*] You can manage different appear animations in pbPlaceEncounter depending on encounter type

# NOTES:
# [*] Create new animation in database and edit animation_id in settings script (line 199),
#     (if the id number is bigger than the database number of animations it will crash the game).


#===============================================================================
# This Part is all about grass rustle animations during spawning and other 
# animations for the spawned overworld encounters
#
# including animations depending on the ground during spawning,
#           animations depending on the spawning pokemon during spawning,
#           permanent animations depending on the properties of the PokeEvent
#
# See in Settings section for your parameters
# See also the animations by TrankerGolD for aggressive encounters, water 
# encounters, and shiny encounters under the following link 
# https://www.pokecommunity.com/showpost.php?p=10395100&postcount=383
# See also the Aggressive Encounters - Add On for the visible overworld wild encounters script
#===============================================================================

module VisibleEncounterSettings
    #------------- ADDITIONAL ANIMATIONS DURING SPAWNING ETC ------------
    # Create your own animations in database, then and edit the number ids 
    DEFAULT_SPAWN_ANIMATION_ID = Settings::RUSTLE_NORMAL_ANIMATION_ID # default Settings::RUSTLE_NORMAL_ANIMATION_ID
    # This parameter stores the id of the default animation that triggers when a new pokemon spawns on the overworld.
    # Usually it is the normal grass rustle animation. But you can create your own animation in database and place in its id here.
  
    DEFAULT_DESPAWN_ANIMATION_ID = Settings::RUSTLE_NORMAL_ANIMATION_ID # default Settings::RUSTLE_NORMAL_ANIMATION_ID
    # This parameter stores the id of the default animation that triggers when a new pokemon despawns from the overworld.
    # Usually it is the normal grass rustle animation. But you can create your own animation in database and place in its id here.
    
    ENV_SPAWN_ANIMATIONS = [                          # default
      [:dust, Settings::DUST_ANIMATION_ID],           # [:dust, Settings::DUST_ANIMATION_ID],  -  means if pokemon spawns on dust then use default dust animation
      [:land, Settings::RUSTLE_NORMAL_ANIMATION_ID],  # [:land, Settings::RUSTLE_NORMAL_ANIMATION_ID],  -  means if pokemon spawns on land then use default grass rustle animation
      [:water, 10]                                    # [:water, 10],  -  means if pokemon spawns on water then use user animation with id 10
    ]
    # This parameter is used to add a grass rustle/ water splash/ etc. animation depending on the ground where the pokemon spawns.
    # The data is stored as an array of entries [encounter_type, animation_id], where encounter_type is a GameData::EncounterType 
    # and animation_id is the id of the user animation.

    ENV_DESPAWN_ANIMATIONS = [                          # default
    [:Sand, Settings::DUST_ANIMATION_ID],           # [:dust, Settings::DUST_ANIMATION_ID],  -  means if pokemon spawns on dust then use default dust animation
    [:Grass, Settings::RUSTLE_NORMAL_ANIMATION_ID],  # [:land, Settings::RUSTLE_NORMAL_ANIMATION_ID],  -  means if pokemon spawns on land then use default grass rustle animation
    [:Water, 10]                                    # [:water, 10],  -  means if pokemon spawns on water then use user animation with id 10
  ]
  # This parameter is used to add a special grass rustle/ water splash/ etc. animation depending on the ground where the pokemon despawns.
  # The data is stored as an array of entries [tile_terrain_tag_id, animation_id], where tile_terrain_tag_id is an id of an GameData::TerrainTag  
  # and animation_id is the id of the user animation.

    Enc_Spawn_Animations = [     # default
      [:shiny?, true, 8],        # [:shiny?, true, 8],     -  means if pokemon is shiny then use animation with id 8
      [:pokerusStage, 1, 8]      # [:pokerusStage, 1, 11]  -  means if pokemon is infected then use animation with id 11
    ]
    # This parameter is used to add an animation to the PokeEvent depending on the spawning pokemon.
    # The data is stored as an array of entries [method, value, animation_id], where method is a variable or method which does not require parameters of the class Pokemon,
    # value is a possible outcome value of the method method and animation_id is the id of the user animation that should 
    # trigger if value == pokemon.method for the spawning pokemon pokemon.
    
    Perma_Enc_Animations = [  # default
      [:shiny?, true, 7],     # [:shiny?, true, 7],  -  means if pokemon is shiny then permanently play animation with id 7 from database
    ]
    # This parameter is used to add an permanent animation to the PokeEvent depending on the spawning pokemon.
    # The data is stored as an array of entries [variable, value, animation_id], where variable is a variable or a method (that does not need a ) of the class Pokemon,
    # value is a possible outcome value of that variable and animation_id is the id of the existing user animation in database
    # that will play constantly over the overworld PokeEvent if it is in the screen and the value value equals the actual value
    # of the variable of that Game_PokeEvent.
  end
  
  
  
  #-------------------------------------------------------------------------------
  # overwriting pbPlaceEncounter to add animations while spawning to the overworld
  #-------------------------------------------------------------------------------
  alias original_pbPlaceEncounter pbPlaceEncounter
  def pbPlaceEncounter(x,y,pokemon)
    #Appear Animation
    encType = GameData::EncounterType.try_get($game_temp.encounter_type)
    if !encType
      # Show default spawn animation
      $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_SPAWN_ANIMATION_ID,x,y,true,1)
    else
      default_anim = true
      for anim in VisibleEncounterSettings::ENV_SPAWN_ANIMATIONS
        anim_type = anim[0]
        anim_id = anim[1]
        if encType.type  == anim_type && $data_animations[anim_id]
          # Show animation
          $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
          default_anim = false
        end
      end
      if default_anim == true
        # Show default grass rustling animation
        $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_SPAWN_ANIMATION_ID,x,y,true,1)
      end
    end
    #Appear Encounter Animations
    for anim in VisibleEncounterSettings::Enc_Spawn_Animations
      anim_method = anim[0]
      anim_value = anim[1]
      anim_id = anim[2]
      if pokemon.method(anim_method).call == anim_value && $data_animations[anim_id]
        $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
      end
    end
    original_pbPlaceEncounter(x,y,pokemon)
  end
  
  #-------------------------------------------------------------------------------
  # overwriting Method update in Class Game_PokeEvent to include permanent 
  # animations for overworld encounters
  #-------------------------------------------------------------------------------
  class Game_PokeEvent < Game_Event
    alias anim_update update
    def update
      if !$game_temp.in_menu
  
        for anim in VisibleEncounterSettings::Perma_Enc_Animations
          anim_method = anim[0]
          anim_value = anim[1]
          anim_id = anim[2]
          if self.pokemon.method(anim_method).call == anim_value && $data_animations[anim_id]
            #spam every (animationframes + 4) frames
            if Graphics.frame_count % ($data_animations[anim_id].frames.length + 4) == 0
              #check if event on screen
              if (self.screen_x >= 0 && self.screen_x <= Graphics.width) || (self.screen_y-16 >= 0 && self.screen_y-16 <= Graphics.height)
                #Show shiny animation
                #check if event on same map as player
                if @map_id!= $game_map.map_id #different map
                  sx = self.screen_x - $game_player.screen_x
                  sy = self.screen_y - $game_player.screen_y
                  newx = $game_player.x + (sx/32)
                  newy = $game_player.y + (sy/32)
                  $scene.spriteset.addUserAnimation(anim_id,newx,newy,true,1)
                else #same map
                  $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
                end
              end
            end
          end
        end
      end
      anim_update
    end
  end
  
  #-------------------------------------------------------------------------------
  # overwriting removeThisEventfromMap in Game_Map to add animations while despawning
  #-------------------------------------------------------------------------------
  class Game_Map
  
    alias original_removeThisEventfromMap removeThisEventfromMap
    def removeThisEventfromMap(id)
      if @events.has_key?(id)
        x = @events[id].x
        y = @events[id].y
        tile_terrain_tag = $game_map.terrain_tag(x,y)
        default_anim = true
        for anim in VisibleEncounterSettings::ENV_SPAWN_ANIMATIONS
            anim_tag_id = anim[0]
            anim_id = anim[1]
            if tile_terrain_tag.id == anim_tag_id && $data_animations[anim_id]
                $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
                default_anim = false
            end
        end
        if default_anim == true
            # Show default despawn animation
            $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_SPAWN_ANIMATION_ID,x,y,true,1)
        end
      end
      original_removeThisEventfromMap(id)
    end
  end
  
  class Game_PokeEvent < Game_Event
    #-------------------------------------------------------------------------------
    # adding attr_reader for oldX and oldY to find last position of overworld pokemon
    #-------------------------------------------------------------------------------
    attr_reader :oldX
    attr_reader :oldY
    
    #-------------------------------------------------------------------------------
    # overwriting removeThisEventfromMap in Game_PokeEvent to add animations while despawning
    #-------------------------------------------------------------------------------
    alias original_removeThisEventfromMap removeThisEventfromMap
    def removeThisEventfromMap
        if $game_map.events.has_key?(@id) and $game_map.events[@id]==self
            x = $game_map.events[@id].oldX
            y = $game_map.events[@id].oldY
            tile_terrain_tag = $game_map.terrain_tag(x,y)
            default_anim = true
            for anim in VisibleEncounterSettings::ENV_SPAWN_ANIMATIONS
                anim_tag_id = anim[0]
                anim_id = anim[1]
                if tile_terrain_tag.id == anim_tag_id && $data_animations[anim_id]
                    $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
                    default_anim = false
                end
            end
            if default_anim == true
                # Show default despawn animation
                $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_SPAWN_ANIMATION_ID,x,y,true,1)
            end
        else
            if $map_factory
                for map in $map_factory.maps
                    if map.events.has_key?(@id) and map.events[@id]==self
                        x = map.events[@id].oldX
                        y = map.events[@id].oldY
                        tile_terrain_tag = $game_map.terrain_tag(x,y)
                        default_anim = true
                        for anim in VisibleEncounterSettings::ENV_SPAWN_ANIMATIONS
                            anim_tag_id = anim[0]
                            anim_id = anim[1]
                            if tile_terrain_tag.id == anim_tag_id && $data_animations[anim_id]
                                $scene.spriteset.addUserAnimation(anim_id,x,y,true,1)
                                default_anim = false
                            end
                        end
                        if default_anim == true
                            # Show default despawn animation
                            $scene.spriteset.addUserAnimation(VisibleEncounterSettings::DEFAULT_SPAWN_ANIMATION_ID,x,y,true,1)
                        end
                        break
                    end
                end
            else
                raise ArgumentError.new(_INTL("Actually, this should not be possible"))
            end
        end
        original_removeThisEventfromMap
    end
  
  end
