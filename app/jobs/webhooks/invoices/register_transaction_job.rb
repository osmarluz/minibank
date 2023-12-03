# frozen_string_literal: true

require 'dry/monads'

module Webhooks
  module Invoices
    class RegisterTransactionJob
      include Sidekiq::Worker
      include Dry::Monads[:result]

      sidekiq_options lock: :while_executing,
                      on_conflict: :reschedule,
                      unique_across_queues: true,
                      lock_args_method: :lock_args

      def self.lock_args(args)
        [args.first]
      end

      def perform(clinic_id, clinic_name, invoice_id, total_paid_cents)
        result = RegisterTransactionOperation.new.call(clinic_id, clinic_name, invoice_id, total_paid_cents)

        case result
        in Success
          logs_success(invoice_id)
        in Failure(String => message)
          logs_validation_error(message, invoice_id, clinic_id)
        in Failure
          logs_exception(
            result.failure.class,
            result.failure.message,
            result.trace,
            invoice_id,
            clinic_id
          )
          raise result.failure
        end
      end

      private

      def logs_success(invoice_id)
        Rails.logger.info(
          class: self.class,
          message: 'Transaction registered successfully',
          invoice_id:
        )
      end

      def logs_validation_error(message, invoice_id, clinic_id)
        Rails.logger.error(
          class: self.class,
          message:,
          invoice_id:,
          clinic_id:
        )
      end

      def logs_exception(exception, message, trace, invoice_id, clinic_id)
        Rails.logger.error(
          class: self.class,
          exception:,
          message:,
          trace:,
          invoice_id:,
          clinic_id:
        )
      end
    end
  end
end
