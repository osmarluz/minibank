# frozen_string_literal: true

class Clinic < ApplicationRecord
  has_many :transactions, dependent: :destroy
end
