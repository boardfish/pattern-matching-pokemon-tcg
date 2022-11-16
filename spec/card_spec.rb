# frozen_string_literal: true

require "spec_helper"

PokemonTCG::Player = Struct.new(:deck)
Sobble = PokemonTCG::Card.pokemon(base_hp: 60, card_battle_styles: [:rapid_strike])
Inteleon = PokemonTCG::Card.pokemon(base_hp: 140, card_battle_styles: [:rapid_strike])
RapidStrikeUrshifuV = PokemonTCG::Card.pokemon(base_hp: 220, card_battle_styles: [:rapid_strike])
Brawly = PokemonTCG::Card.supporter(card_battle_styles: [:rapid_strike])
RapidStrikeUrshifuVMAX = PokemonTCG::Card.pokemon(base_hp: 320, card_battle_styles: [:rapid_strike])
Energy = Module.new
Energy::RapidStrike = PokemonTCG::Card.energy(card_battle_styles: [:rapid_strike])
Energy::Water = PokemonTCG::Card.energy
Drizzile = PokemonTCG::Card.pokemon(base_hp: 90, card_battle_styles: [])
SingleStrikeUrshifuVMAX = PokemonTCG::Card.pokemon(base_hp: 320, card_battle_styles: [:single_strike])
LeafeonV = PokemonTCG::Card.pokemon(base_hp: 210, card_battle_styles: [])
LeafeonVSTAR = PokemonTCG::Card.pokemon(base_hp: 280, card_battle_styles: [])
LeafeonVMAX = PokemonTCG::Card.pokemon(base_hp: 320, card_battle_styles: [])
Leafeon = PokemonTCG::Card.pokemon(base_hp: 110, card_battle_styles: [])
LevelBall = PokemonTCG::Card::LevelBall
ProfessorsResearch = PokemonTCG::Card.supporter
ChoiceBelt = PokemonTCG::Card.tool

RSpec.describe "Card end to end tests" do
  let(:card) { described_class.new }

  # For the sake of these tests, we'll pretend each of these cards does only one thing.
  subject { card.action(player_state).call[0] }

  let(:rapid_strike_test_deck) do
    PokemonTCG::Player.new(
      [
        Sobble.new,
        Inteleon.new,
        RapidStrikeUrshifuV.new,
        Brawly.new,
        RapidStrikeUrshifuVMAX.new,
        Energy::RapidStrike.new,
        # Invalid search targets
        SingleStrikeUrshifuVMAX.new,
        Drizzile.new,
        Energy::Water.new
      ]
    )
  end

  let(:leafeons_test_deck) do
    PokemonTCG::Player.new(
      [
        LeafeonV.new,
        LeafeonVSTAR.new,
        LeafeonVMAX.new,
        Leafeon.new,
        # Invalid search targets
        LevelBall.new,
        ProfessorsResearch.new,
        ChoiceBelt.new,
        Energy::Water.new
      ]
    )
  end

  describe PokemonTCG::Card::AdventurersDiscovery, "#action" do
    let(:player_state) { leafeons_test_deck }

    it { is_expected.to all be_a_pokemon_v }
    it do
      is_expected.to contain_exactly(
        be_a(LeafeonV),
        be_a(LeafeonVSTAR),
        be_a(LeafeonVMAX)
      )
    end
  end

  describe PokemonTCG::Card::Octillery, "#search_targets" do
    let(:player_state) { rapid_strike_test_deck }

    it { is_expected.to all be_rapid_strike }
    it do
      is_expected.to contain_exactly(
        be_a(Sobble),
        be_a(Inteleon),
        be_a(RapidStrikeUrshifuV),
        be_a(Brawly),
        be_a(RapidStrikeUrshifuVMAX),
        be_a(Energy::RapidStrike)
      )
    end
  end

  describe PokemonTCG::Card::LevelBall, "#search_targets" do
    let(:player_state) { rapid_strike_test_deck }

    it { is_expected.to all be_a_pokemon }
    it { is_expected.to all have_attributes(hp: be <= 90) }

    it do
      is_expected.to contain_exactly(
        be_a(Sobble),
        be_a(Drizzile)
      )
    end
  end
end
