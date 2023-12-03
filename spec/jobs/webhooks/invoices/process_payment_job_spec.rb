# frozen_string_literal: true

require 'dry/monads'

describe Webhooks::Invoices::ProcessPaymentJob do
  include Dry::Monads[:result]

  describe '#perform' do
    subject do
      described_class.new.perform(params)
    end

    let(:invoice_id) { Faker::Alphanumeric.alphanumeric(number: 32).upcase }
    let(:params) do
      {
        'data' => {
          'id' => invoice_id
        }
      }
    end

    let(:operation) { double }
    let(:logger) { double }

    before do
      allow(Webhooks::Invoices::ProcessPaymentOperation).to receive(:new).and_return(operation)
      allow(Rails).to receive(:logger).and_return(logger)
    end

    context 'when operation is successful' do
      before do
        allow(operation).to receive(:call).with(
          invoice_id
        ).and_return(Success())
      end

      it 'logs success message' do
        expect(logger).to receive(:info).with(
          class: described_class,
          message: 'Payment processed successfully',
          invoice_id:
        )

        subject
      end
    end

    context 'when operation fails' do
      before do
        allow(operation).to receive(:call).with(
          invoice_id
        ).and_return(Failure('message'))
      end

      it 'logs error' do
        expect(logger).to receive(:error).with(
          class: described_class,
          message: 'message',
          invoice_id:
        )

        subject
      end
    end

    context 'when operation returns an error' do
      before do
        allow(operation).to receive(:call).with(
          invoice_id
        ).and_return(Failure(StandardError.new('BOOOM!')))
      end

      it 're-raises the exception', :aggregate_failures do
        expect(logger).to receive(:error).with(
          class: described_class,
          exception: StandardError,
          message: 'BOOOM!',
          trace: anything,
          invoice_id:
        )

        expect { subject }.to raise_error(StandardError, 'BOOOM!')
      end
    end
  end
end
