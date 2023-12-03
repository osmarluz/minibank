# frozen_string_literal: true

describe Webhooks::Invoices::Policy do
  describe '#call' do
    subject do
      described_class.call(request)
    end

    before do
      expect(Rails.application.credentials.iugu).to receive(:token)
        .and_return('123456')
    end

    let(:request) { double }

    context 'when the token matches' do
      before do
        expect(request).to receive(:authorization)
          .and_return('123456')
        expect(request).to receive(:params)
          .and_return(params)
      end

      context 'when the notification comes from a payment' do
        let(:params) do
          {
            data: {
              status: 'paid'
            }
          }
        end

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when the notification does not come from a payment' do
        let(:params) do
          {
            data: {
              status: 'whatever'
            }
          }
        end

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end

    context 'when the token does not match' do
      before do
        expect(request).to receive(:authorization)
          .and_return('123')
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
