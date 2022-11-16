module PokemonTCG
  module Card
    class AdventurersDiscovery
      include PokemonTCG::Card

      def actions(player_state)
        [
          -> { GameAction::Search.new(:deck, player_state) { |card| card in { name: /V(STAR|MAX)?$/ } }.call }
        ]
      end
    end
  end
end
