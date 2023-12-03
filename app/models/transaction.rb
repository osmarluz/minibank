# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :clinic

  enum kind: {
    incoming: 'incoming',
    outgoing: 'outgoing'
  }
end
