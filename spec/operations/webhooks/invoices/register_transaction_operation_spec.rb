# frozen_string_literal: true

describe Webhooks::Invoices::RegisterTransactionOperation do
  describe '#call' do
    subject do
      described_class.new.call(
        clinic_id,
        clinic_name,
        invoice_id,
        total_paid_cents
      )
    end

    let(:clinic_id) { '1' }
    let(:clinic_name) { 'clinic_name' }
    let(:invoice_id) { Faker::Alphanumeric.alphanumeric(number: 32).upcase }
    let(:total_paid_cents) { '10000' }

    context 'when transaction has already been registered' do
      before do
        allow(Registry).to receive(:exists?)
          .with(source: :iugu, external_id: invoice_id)
          .and_return(true)
      end

      it 'returns failure' do
        expect(subject).to be_failure
      end

      it 'returns error message' do
        expect(subject.failure).to eq('Transação já foi registrada')
      end
    end

    context 'when transaction has not been registered' do
      let(:transaction) { instance_double(Transaction, amount: 100.00) }
      let(:clinic) { instance_double(Clinic, balance: 0.0) }

      it 'returns success', :aggregate_failures do
        expect(Webhooks::Invoices::FindOrCreateClinic).to receive(:call)
          .with(clinic_id, clinic_name)
          .and_return(clinic)
        expect(Transaction).to receive(:create!)
          .with(
            kind: :incoming,
            amount: 1e2,
            description: 'Pagamento de boleto',
            clinic:
          )
          .and_return(transaction)
        expect(clinic).to receive(:update!)
          .with(balance: 100.00)
        expect(Registry).to receive(:create!)
          .with(source: :iugu, external_id: invoice_id)

        expect(subject).to be_success
      end
    end
  end
end
