# frozen_string_literal: true

module Iugu
  class InvoiceAdapter
    include HTTParty

    base_uri('https://api.iugu.com/v1/invoices')

    def self.find(id:)
      api_key = Rails.application.credentials.iugu.api_key
      options = {
        headers: {
          Accept: 'application/json',
          Authorization: "Basic #{Base64.strict_encode64(api_key)}",
          'Content-Type': 'application/json'
        }
      }

      get("/#{id}", options)
    end
  end
end
