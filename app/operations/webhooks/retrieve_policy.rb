# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Webhooks
  class RetrievePolicy
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)

    POLICIES = {
      iugu: Invoices::Policy
    }.freeze

    def call(integration)
      policy = yield retrieve_policy(integration&.to_sym)

      Success(policy)
    end

    private

    def retrieve_policy(integration)
      POLICIES[integration].present? ? Success(POLICIES[integration]) : Failure()
    end
  end
end
