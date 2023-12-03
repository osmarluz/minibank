# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Webhooks
  module Invoices
    class RegisterTransactionOperation
      include Dry::Monads[:result, :try]
      include Dry::Monads::Do.for(:call)

      def call(clinic_id, clinic_name, invoice_id, total_paid_cents)
        ActiveRecord::Base.transaction do
          yield transaction_already_registered?(invoice_id)
          clinic = yield find_or_create_clinic(clinic_id, clinic_name)
          transaction = yield create_transaction(clinic, total_paid_cents)
          yield update_balance(clinic, transaction)
          yield register_payment(invoice_id)
        end

        Success()
      end

      private

      def transaction_already_registered?(invoice_id)
        if Registry.exists?(source: :iugu, external_id: invoice_id)
          Failure('Transação já foi registrada')
        else
          Success()
        end
      end

      def find_or_create_clinic(clinic_id, clinic_name)
        Try do
          FindOrCreateClinic.call(clinic_id, clinic_name)
        end.to_result
      end

      def create_transaction(clinic, amount)
        Try do
          Transaction.create!(
            kind: :incoming,
            amount: amount.to_d / 100,
            description: 'Pagamento de boleto',
            clinic:
          )
        end.to_result
      end

      def update_balance(clinic, transaction)
        Try { clinic.update!(balance: clinic.balance + transaction.amount) }.to_result
      end

      def register_payment(invoice_id)
        Try { Registry.create!(source: :iugu, external_id: invoice_id) }.to_result
      end
    end
  end
end
