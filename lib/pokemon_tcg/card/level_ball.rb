module PokemonTCG
  module Card
    class LevelBall
      include PokemonTCG::Card

      def actions(player_state)
        [
          -> { GameAction::Search.new(:deck, player_state) { |card| card in { hp: ..90 } }.call }
        ]
      end
    end
  end
end
