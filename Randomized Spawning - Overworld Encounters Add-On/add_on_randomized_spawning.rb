#======================================================
#           Randomized Spawning v1.2 by derFischae
#======================================================
# This is an Add-On for the visible overworld wild encounters script. It will randomize overworld encounters.
#
# Copy the folder of this plugin in your plugins folder.

Events.onWildPokemonCreateForSpawning+=proc{|sender,e|
  pokemon=e[0]
  keys = GameData::Species.keys
  k = rand(keys.size)
  pokemon.species = keys[k]
}
