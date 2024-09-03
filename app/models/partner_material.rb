# frozen_string_literal: true

class PartnerMaterial < ApplicationRecord
  belongs_to :partner
  belongs_to :material
end
