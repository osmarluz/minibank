# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    kind { Transaction.kinds.keys.sample }
    amount { Faker::Number.decimal(l_digits: 2) }
    description { Faker::Lorem.sentence }
    clinic
  end
end
