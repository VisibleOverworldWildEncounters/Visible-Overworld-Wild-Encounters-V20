#======================================================
#           Randomized Spawning v1.2 by derFischae
#======================================================
# This is an Add-On for the visible overworld wild encounters script. It will randomize overworld encounters.
#
# Copy the folder of this plugin in your plugins folder.

EventHandlers.add(:on_wild_pokemon_created_for_spawning, :randomized_spawn,
  proc { |pkmn|
    keys = GameData::Species.keys
    k = rand(keys.size)
    pkmn.species = keys[k]
  }
)
