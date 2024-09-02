# frozen_string_literal: true

FactoryBot.define do
  factory :partner do
    name { "Partner #{Faker::Company.name}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    operating_radius { rand(10..100) }
    rating { rand(1.0..5.0).round(1) }
  end
end
