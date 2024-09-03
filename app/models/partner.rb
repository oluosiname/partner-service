# frozen_string_literal: true

class Partner < ApplicationRecord
  has_many :partner_materials, dependent: :destroy
  has_many :materials, through: :partner_materials

  before_save :set_location_point

  validates :name, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :operating_radius, presence: true, numericality: { greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  scope :within_radius, ->(lat, lon) {
    where('ST_DWithin(location, ST_MakePoint(?, ?)::geography, operating_radius * 1000)', lon, lat)
  }

  scope :with_experience_in, ->(material) {
    joins(:materials).where(materials: { name: material.downcase })
  }

  class << self
    def best_matches(material, lat, lon)
      with_experience_in(material)
        .within_radius(lat, lon)
        .select("partners.*, ST_Distance(location, ST_MakePoint(#{lon}, #{lat})::geography) AS distance")
        .order('rating DESC, distance ASC')
    end
  end

  private

  def set_location_point
    self.location = "POINT(#{longitude} #{latitude})"
  end
end
