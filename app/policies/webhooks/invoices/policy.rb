# frozen_string_literal: true

module Webhooks
  module Invoices
    class Policy < BasePolicy
      def initialize(request)
        @request = request
      end

      def call
        ActiveSupport::SecurityUtils.secure_compare(
          @request.authorization,
          Rails.application.credentials.iugu.token
        ) && @request.params.dig(:data, :status) == 'paid'
      end
    end
  end
end
