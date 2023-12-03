# frozen_string_literal: true

class BasePolicy
  def self.call(...)
    new(...).call
  end
end
