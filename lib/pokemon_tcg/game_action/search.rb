module PokemonTCG
  module GameAction
    class Search
      def initialize(pile, player_state, &block)
        @pile = pile
        @player_state = player_state
        @filter_method = block
      end

      def call
        player_state.public_send(pile).partition(&filter_method)
      end

      private

      attr_reader :player_state, :pile, :filter_method
    end
  end
end
