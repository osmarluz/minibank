# frozen_string_literal: true

describe Webhooks::Invoices::ProcessPaymentOperation do
  describe '#call' do
    subject do
      described_class.new.call(invoice_id)
    end

    let(:user_id) { Faker::Alphanumeric.alphanumeric(number: 32).upcase }
    let(:invoice_id) { Faker::Alphanumeric.alphanumeric(number: 32).upcase }
    let(:invoice) { { 'customer_id' => user_id, 'total_paid_cents' => 10_000 } }
    let(:clinic_id) { '1' }
    let(:clinic_name) { 'clinic_name' }

    before do
      expect(Iugu::UserAdapter).to receive(:find)
        .with(id: user_id)
        .and_return(user)
      expect(Iugu::InvoiceAdapter).to receive(:find)
        .with(id: invoice_id)
        .and_return(invoice)
    end

    context 'when invoice comes from buy-now-pay-later' do
      let(:user) do
        { 'custom_variables' => [{ 'name' => 'user_id', 'value' => anything }] }
      end

      it 'returns failure' do
        expect(subject).to be_failure
      end

      it 'returns error message' do
        expect(subject.failure).to eq('Fatura originária de fluxo de BNPL')
      end
    end

    context 'when invoice does not come from buy-now-pay-later' do
      let(:user) do
        { 'custom_variables' => [{ 'name' => 'bill_id', 'value' => anything }] }
      end

      before do
        expect(Webhooks::Invoices::ParseClinicInformation).to receive(:call)
          .with(invoice)
          .and_return([clinic_id, clinic_name])
      end

      it 'enqueues a RegisterTransactionJob' do
        expect(Webhooks::Invoices::RegisterTransactionJob).to receive(:perform_async).with(
          clinic_id,
          clinic_name,
          invoice_id,
          10_000
        )

        expect(subject).to be_success
      end
    end
  end
end
