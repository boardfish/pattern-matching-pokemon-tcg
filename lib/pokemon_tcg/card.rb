require_relative 'card/pokemon'
require_relative 'card/adventurers_discovery'
require_relative 'card/octillery'
require_relative 'card/level_ball'

module PokemonTCG
  module Card
    def name
      self.class.name
    end

    def type
      raise NotImplementedError
    end

    def action(player_state)
      actions(player_state).first
    end

    def deconstruct_keys(keys)
      { battle_styles:, name: }
    end

    def battle_styles
      []
    end

    def pokemon_v?
      name in /V(STAR|MAX)?$/
    end

    def rapid_strike?
      battle_styles.include?(:rapid_strike)
    end

    def pokemon?
      respond_to?(:hp)
    end

    class << self
      def card(card_battle_styles: [])
        Class.new { include PokemonTCG::Card }
             .tap { _1.define_method(:battle_styles) { card_battle_styles } }
      end

      alias supporter card
      alias energy card
      alias tool card

      def pokemon(base_hp:, card_battle_styles: [])
        Class.new { include PokemonTCG::Card::Pokemon }
             .tap { _1.define_method(:hp) { base_hp } }
             .tap { _1.define_method(:battle_styles) { card_battle_styles } }
      end
    end
  end
end
