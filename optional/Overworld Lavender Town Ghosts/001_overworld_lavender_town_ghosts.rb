
          #########################################################
          #                                                       #
          #        ADD-ON:  OVERWORLD LAVENDER TOWN GHOSTS        #
          #                                         by derFischae #
          #########################################################


# FEATURES:
# [*] Shows ghost sprite for overworld encounters, needs Lavender Town Ghosts Plugin

# INSTALLATION:
# 1) Get or create an overworld sprite for your overworld ghost encounter. This plugin will not provide a sprite but maybe you find can easily find some resource, for example search for "shiny missingNo [Ghost Form]".
# 2) Name that graphic "ghost.png" and place it in your "/Graphisc/Characters/" folder of your project.
# 3) Download and install the "Lavender Town Ghosts" Plugin.
# 4) Download and install the "Visible Overworld Wild Encounters" Plugin.
# 5) Download and install this plugin.

#-------------------------------------------------------------------------------
# Overwriting method ow_sprite_filename to include overworld ghost sprite
#-------------------------------------------------------------------------------
alias ghost_ow_sprite_filename ow_sprite_filename
def ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
    return "Graphics/Characters/ghost" if Ghost.active?
    return ghost_ow_sprite_filename(species, form, gender, shiny, shadow)
end
    
