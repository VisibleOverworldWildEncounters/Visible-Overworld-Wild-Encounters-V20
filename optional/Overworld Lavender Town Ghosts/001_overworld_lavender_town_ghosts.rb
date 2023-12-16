
          #########################################################
          #                                                       #
          #        ADD-ON:  OVERWORLD LAVENDER TOWN GHOSTS        #
          #                                         by derFischae #
          #########################################################


# FEATURES:
# [*] Shows ghost sprite for overworld encounters when not having Silphscope in the bag
# [*] needs the original Lavender Town Ghosts Plugin for fully potential

# INSTALLATION:
# 1) Get or create an overworld sprite for your overworld ghost encounter. This plugin will not provide a sprite but maybe you can easily find some resource, for example search for "shiny missingNo [Ghost Form]".
# 2) Name that graphic "ghost.png" and place it in your "/Graphisc/Characters/" folder of your project.
# 3) [Optional] Download and install the "Lavender Town Ghosts" Plugin. Might only exist for outdated Pokemon Essentials versions.
# 4) Download and install the "Visible Overworld Wild Encounters" Plugin.
# 5) Download and install this plugin.
# 6) [If not using the original "Lavender Town Ghost" plugin] Open this plugin in a texteditor and include the map-ids of all ghost maps in the parameter Overworld_Ghostmaps 

module Ghost
	Overworld_Ghostmaps = [] # default [] - if you already have written all your ghostmaps in the original lavender town ghost plugin.
    # The parameter Overworld_Ghostmaps is used to say the game which maps should show the ghost sprite on the overworld when not having the silph scope.
    # So, include all map-ids of that maps in the parameter
    
    if Ghost.const_defined?(:GHOSTMAPS)
        Ghost::Overworld_Ghostmaps.push(*Ghost.GHOSTMAPS)
    end

    # Check event ghost
    def self.active?
        return true if !$bag.has?(:SILPHSCOPE) && Overworld_Ghostmaps.include?($game_map.map_id) && pbResolveBitmap("Graphics/Characters/ghost")
        return false
    end
end

#-------------------------------------------------------------------------------
# Overwriting method ow_sprite_filename to include overworld ghost sprite
#-------------------------------------------------------------------------------
alias ghost_ow_sprite_filename ow_sprite_filename
def ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
    return "Graphics/Characters/ghost" if Ghost.active?
    return ghost_ow_sprite_filename(species, form, gender, shiny, shadow)
end
    
