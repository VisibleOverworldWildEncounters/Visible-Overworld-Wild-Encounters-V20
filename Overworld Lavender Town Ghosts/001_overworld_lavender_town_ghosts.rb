
          #########################################################
          #                                                       #
          #        ADD-ON:  OVERWORLD LAVENDER TOWN GHOSTS        #
          #                                         by derFischae #
          #########################################################


# FEATURES:
# [*] Shows ghost sprite for overworld encounters, needs Lavender Town Ghosts Plugin

# INSTALLATION:
# 1) Get or create an overworld sprite for your overworld ghost encounter. This plugin will not provide a sprite but maybe you find can easily find some resource, for example search for "shiny missingNo [Ghost Form]".
# 2) Name that graphic "ghost.png" and place it in your "/Graphics/Characters/" folder of your project.
# 3) Download and install the "Lavender Town Ghosts" Plugin.
# 4) Download and install the "Visible Overworld Wild Encounters" Plugin.
# 5) Download and install this plugin.

#-------------------------------------------------------------------------------
# Overwriting method ow_sprite_filename to include overworld ghost sprite
#-------------------------------------------------------------------------------
module GameData
    class Species
        def self.ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
            return "Graphics/Characters/ghost.png" if Ghost.active?
            ret = self.check_graphic_file("Graphics/Characters/", species, form, gender, shiny, shadow, "Followers")
            ret = "Graphics/Characters/Followers/000" if nil_or_empty?(ret)
            return ret
        end
    end
end
  
