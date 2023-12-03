# frozen_string_literal: true

class Subdomain
  def self.webhooks
    Rails.env.production? ? { subdomain: 'hooks' } : nil
  end
end
