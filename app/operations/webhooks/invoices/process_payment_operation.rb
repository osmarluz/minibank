# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Webhooks
  module Invoices
    class ProcessPaymentOperation
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)

      def call(invoice_id)
        invoice = yield find_invoice(invoice_id)
        user_id = yield parse_user_id(invoice)
        user = yield find_user(user_id)
        yield clinic_generated_invoice?(user)
        clinic_id, clinic_name = yield parse_clinic_information(invoice)
        trigger_transaction_registration(
          clinic_id,
          clinic_name,
          invoice_id,
          invoice['total_paid_cents']
        )

        Success()
      end

      private

      def find_invoice(id)
        Try { ::Iugu::InvoiceAdapter.find(id:) }.to_result
      end

      def parse_user_id(invoice)
        Try { invoice['customer_id'] }.to_result
      end

      def find_user(id)
        Try { ::Iugu::UserAdapter.find(id:) }.to_result
      end

      def clinic_generated_invoice?(user)
        if user['custom_variables'].any? { |hash| hash['name'] == 'bill_id' }
          Success()
        else
          Failure('Fatura originária de fluxo de BNPL')
        end
      end

      def parse_clinic_information(invoice)
        Try { ParseClinicInformation.call(invoice) }.to_result
      end

      def trigger_transaction_registration(clinic_id, clinic_name, invoice_id, total_paid_cents)
        RegisterTransactionJob.perform_async(clinic_id, clinic_name, invoice_id, total_paid_cents)
      end
    end
  end
end
