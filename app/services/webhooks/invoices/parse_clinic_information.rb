# frozen_string_literal: true

module Webhooks
  module Invoices
    class ParseClinicInformation < BaseService
      def initialize(invoice)
        @invoice = invoice
      end

      def call
        sorted_custom_variables = @invoice['custom_variables'].sort_by do |custom_variable|
          custom_variable['name']
        end

        sorted_custom_variables.map do |custom_variable|
          custom_variable['value'].strip if %w[clinic_id clinic_name].include?(custom_variable['name'])
        end.compact
      end
    end
  end
end
