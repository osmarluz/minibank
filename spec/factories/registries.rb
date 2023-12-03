# frozen_string_literal: true

FactoryBot.define do
  factory :registry do
    source { Registry.sources.keys.sample }
    external_id { Faker::Alphanumeric.alphanumeric(number: 32).upcase }
  end
end
