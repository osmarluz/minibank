# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Webhooks
  class RetrieveJob
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    INTEGRATION = {
      iugu: Invoices::ProcessPaymentJob
    }.freeze

    def call(integration)
      job = yield retrieve_job(integration&.to_sym)

      Success(job)
    end

    private

    def retrieve_job(integration)
      INTEGRATION[integration].present? ? Success(INTEGRATION[integration]) : Failure()
    end
  end
end
