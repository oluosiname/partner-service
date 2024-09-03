# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Partner, type: :model do
  let(:hakerscher_markt_coord) { { lat: 52.5233, lon: 13.4028 } }
  let(:europa_park_rust_coord) { { lat: 48.2660, lon: 7.7215 } }
  let(:tv_tower_berlin_coord) { { lat: 52.5208, lon: 13.4095 } }

  describe 'associations' do
    it { is_expected.to have_many(:partner_materials).dependent(:destroy) }
    it { is_expected.to have_many(:materials).through(:partner_materials) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_presence_of(:operating_radius) }
    it { is_expected.to validate_presence_of(:rating) }

    it {
      expect(subject).to validate_numericality_of(:latitude)
        .is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90)
    }

    it do
      expect(subject).to validate_numericality_of(:longitude)
        .is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180)
    end

    it { is_expected.to validate_numericality_of(:operating_radius).is_greater_than(0) }

    it do
      expect(subject).to validate_numericality_of(:rating).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(5)
    end
  end

  describe 'callbacks' do
    describe '#set_location_point' do
      let(:partner) { build(:partner) }

      before do
        allow(partner).to receive(:set_location_point).and_call_original
      end

      it 'sets the location point' do
        expect do
          partner.save
        end.to change(partner, :location).from(nil).to(be_a(RGeo::Geographic::SphericalPointImpl))
      end
    end
  end

  describe 'scopes' do
    describe '.within_radius' do
      let!(:partner_within_radius) do
        create(
          :partner,
          latitude: tv_tower_berlin_coord[:lat],
          longitude: tv_tower_berlin_coord[:lon],
          operating_radius: 20,
        )
        # Alexanderplatz, Berlin
      end

      let!(:partner_outside_radius) do
        create(
          :partner,
          latitude: tv_tower_berlin_coord[:lat],
          longitude: tv_tower_berlin_coord[:lon],
          operating_radius: 0.5,
        )
        # Alexanderplatz, Berlin
      end

      let!(:point_within_radius) { hakerscher_markt_coord.values } # Hackescher Markt, Berlin
      let!(:point_outside_radius) { europa_park_rust_coord.values } # Europa Park Rust

      it 'returns partners within the specified radius' do
        results = described_class.within_radius(*point_within_radius)

        expect(results).to include(partner_within_radius)
        expect(results).not_to include(partner_outside_radius)
      end

      it 'does not return partners outside the specified radius' do
        results = described_class.within_radius(point_outside_radius[1], point_outside_radius[0])
        expect(results).not_to include(partner_within_radius)
        expect(results).not_to include(partner_outside_radius)
      end
    end

    describe '.with_experience_in' do
      let(:partner_one) { create(:partner) }

      let(:partner_two) { create(:partner) }

      let(:wood) { create(:material, name: 'wood') }
      let(:metal) { create(:material, name: 'metal') }

      before do
        partner_one.materials << wood
        partner_two.materials << wood
        partner_one.materials << metal
      end

      it 'returns partners with experience in the specified material' do
        expect(described_class.with_experience_in('wood')).to include(partner_one)
        expect(described_class.with_experience_in('wood')).to include(partner_two)

        expect(described_class.with_experience_in('metal')).to include(partner_one)
        expect(described_class.with_experience_in('metal')).not_to include(partner_two)
      end
    end
  end

  describe '.best_matches' do
    let!(:partner_one) do
      create(:partner, latitude: 52.5208, longitude: 13.4095, operating_radius: 20, rating: 4)
      # Alexanderplatz, Berlin
    end

    let!(:partner_two) do
      create(:partner, latitude: 52.5220, longitude: 13.4060, operating_radius: 18, rating: 5)
      # closer location to Hackescher Markt, Berlin
    end

    let(:wood) { create(:material, name: 'wood') }
    let(:metal) { create(:material, name: 'metal') }

    before do
      partner_one.materials << wood
      partner_two.materials << wood
      partner_one.materials << metal
    end

    it 'orders the partners by rating and distance' do
      result = described_class.best_matches('wood', hakerscher_markt_coord[:lat], hakerscher_markt_coord[:lon])

      expect(result).to eq([partner_two, partner_one])
    end

    it 'filters the partners by material experience' do
      result = described_class.best_matches('metal', hakerscher_markt_coord[:lat], hakerscher_markt_coord[:lon])
      expect(result).to include(partner_one)
      expect(result).not_to include(partner_two)
    end
  end
end
