# frozen_string_literal: true

describe Webhooks::RetrievePolicy do
  describe '#call' do
    subject do
      described_class.new.call(integration)
    end

    context 'when policy exists' do
      let(:integration) { 'iugu' }

      it 'returns success' do
        expect(subject).to be_success
      end

      it 'returns the class' do
        expect(subject.success).to eq(Webhooks::Invoices::Policy)
      end
    end

    context 'when policy does not exist' do
      let(:integration) { 'whatever' }

      it 'returns failure' do
        expect(subject).to be_failure
      end
    end
  end
end
