
#=======================================================================
# ADD ON: pokemon are not there after saving and loading up your game
# by TrankerGolD 
#=======================================================================

#See  https://www.pokecommunity.com/showpost.php?p=10395097&postcount=382

##===============================================================================
## new methods to remove pkmn spawned 
##===============================================================================
#Remove all spawned events
def pbRemovePokeEvents
  if $MapFactory
    for map in $MapFactory.maps
      for event in map.events.values
        if event.name.include? "vanishingEncounter"
          event.removeThisEventfromMap
        end
      end
    end
  end
end

#Remove spawned events in current map
def pbRemovePokeEventsInMap
  $game_map.events.values.each { |event|
    if event.name.include? "vanishingEncounter"
      event.removeThisEventfromMap
    end
  }
end
