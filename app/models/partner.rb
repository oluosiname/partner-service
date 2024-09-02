# frozen_string_literal: true

class Partner < ApplicationRecord
  before_save :set_location_point

  validates :name, presence: true
  validates :latitude, presence: true, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, presence: true, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }
  validates :operating_radius, presence: true, numericality: { greater_than: 0 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }

  private

  def set_location_point
    self.location = "POINT(#{longitude} #{latitude})"
  end
end
