# frozen_string_literal: true

require 'dry/monads'

module Webhooks
  module Invoices
    class ProcessPaymentJob
      include Sidekiq::Worker
      include Dry::Monads[:result]

      sidekiq_options lock: :while_executing,
                      unique_across_queues: true,
                      lock_args_method: :lock_args

      def self.lock_args(args)
        [args.first.dig(:data, :id)]
      end

      def perform(params)
        invoice_id = params.dig('data', 'id')
        result = ProcessPaymentOperation.new.call(invoice_id)

        case result
        in Success
          logs_success(invoice_id)
        in Failure(String => message)
          logs_validation_error(message, invoice_id)
        in Failure
          logs_exception(
            result.failure.class,
            result.failure.message,
            result.trace,
            invoice_id
          )
          raise result.failure
        end
      end

      private

      def logs_success(invoice_id)
        Rails.logger.info(
          class: self.class,
          message: 'Payment processed successfully',
          invoice_id:
        )
      end

      def logs_validation_error(message, invoice_id)
        Rails.logger.error(
          class: self.class,
          message:,
          invoice_id:
        )
      end

      def logs_exception(exception, message, trace, invoice_id)
        Rails.logger.error(
          class: self.class,
          exception:,
          message:,
          trace:,
          invoice_id:
        )
      end
    end
  end
end
