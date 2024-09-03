# frozen_string_literal: true

class PartnerSerializer < ActiveModel::Serializer
  attributes :id, :name, :latitude, :longitude, :rating, :operating_radius, :distance

  has_many :materials
end
