module PokemonTCG
  module Card
    class Octillery
      include PokemonTCG::Card::Pokemon

      def actions(player_state)
        [
          -> { GameAction::Search.new(:deck, player_state) { |card| card in { battle_styles: [:rapid_strike, *] } }.call }
        ]
      end
    end
  end
end
