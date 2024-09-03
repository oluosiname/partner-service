# frozen_string_literal: true

class Material < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  before_save :downcase_name

  private

  def downcase_name
    self.name = name.downcase
  end
end
