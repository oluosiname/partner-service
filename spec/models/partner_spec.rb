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
        end.to change(partner, :location).from(nil)

        expect(partner).to have_received(:set_location_point)
      end
    end
  end
end
