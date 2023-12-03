# frozen_string_literal: true

describe Webhooks::Invoices::ParseClinicInformation do
  describe '#call' do
    subject do
      described_class.call(invoice)
    end

    let(:invoice) do
      {
        'custom_variables' => [
          { 'name' => 'clinic_name', 'value' => 'clinic_name' },
          { 'name' => 'installment_id', 'value' => '1234' },
          { 'name' => 'clinic_id', 'value' => '345' }
        ]
      }
    end

    it 'returns an array with clinic_id and clinic_name' do
      expect(subject).to eq(%w[345 clinic_name])
    end
  end
end
