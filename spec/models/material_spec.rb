# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Material, type: :model do
  describe 'validations' do
    subject { build(:material) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }

    it 'is valid with a unique name' do
      material = described_class.new(name: 'Steel')
      expect(material).to be_valid
    end

    it 'is invalid without a name' do
      material = described_class.new(name: nil)
      expect(material).not_to be_valid
      expect(material.errors[:name]).to include("can't be blank")
    end

    it 'is invalid with a duplicate name' do
      described_class.create!(name: 'Wood')
      material = described_class.new(name: 'Wood')
      expect(material).not_to be_valid
      expect(material.errors[:name]).to include('has already been taken')
    end
  end

  describe 'callbacks' do
    it 'downcases the name before saving' do
      material = described_class.create!(name: 'IRON')
      expect(material.name).to eq('iron')
    end
  end
end
