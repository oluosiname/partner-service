# frozen_string_literal: true

FactoryBot.define do
  factory :material do
    name { Faker::Lorem.word }
  end
end
