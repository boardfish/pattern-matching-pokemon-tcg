module PokemonTCG
  module Card
    module Pokemon
      include PokemonTCG::Card

      def hp
        0
      end

      def battle_styles
        []
      end

      def deconstruct_keys(keys)
        { hp:, battle_styles:, name: }
      end
    end
  end
end
