# frozen_string_literal: true

class Registry < ApplicationRecord
  enum source: {
    iugu: 'iugu'
  }
end
