# frozen_string_literal: true

describe Webhooks::RetrieveJob do
  describe '#call' do
    subject do
      described_class.new.call(integration)
    end

    context 'when job exists' do
      let(:integration) { 'iugu' }

      it 'returns success' do
        expect(subject).to be_success
      end

      it 'returns the class' do
        expect(subject.success).to eq(Webhooks::Invoices::ProcessPaymentJob)
      end
    end

    context 'when job does not exist' do
      let(:integration) { 'whatever' }

      it 'returns failure' do
        expect(subject).to be_failure
      end
    end
  end
end
