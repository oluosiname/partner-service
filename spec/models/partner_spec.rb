# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Partner, type: :model do
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
        create(:partner, latitude: 52.5208, longitude: 13.4095, operating_radius: 20)
        # Alexanderplatz, Berlin
      end

      let!(:partner_outside_radius) do
        create(:partner, latitude: 52.5208, longitude: 13.4095, operating_radius: 0.5)
        # Alexanderplatz, Berlin
      end

      let!(:point_within_radius) { [13.4028, 52.5233] } # Hackescher Markt, Berlin
      let!(:point_outside_radius) { [7.7215, 48.2660] } # Europa Park Rust

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
  end
end
