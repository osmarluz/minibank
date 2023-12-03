# frozen_string_literal: true

FactoryBot.define do
  factory :clinic do
    name { Faker::Company.name }
    balance { 0.0 }
  end
end
