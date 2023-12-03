# frozen_string_literal: true

module Webhooks
  module Invoices
    class FindOrCreateClinic < BaseService
      def initialize(clinic_id, clinic_name)
        @clinic_id = clinic_id
        @clinic_name = clinic_name
      end

      def call
        Clinic.create_with(id: @clinic_id, name: @clinic_name)
              .find_or_create_by(id: @clinic_id)
      end
    end
  end
end
