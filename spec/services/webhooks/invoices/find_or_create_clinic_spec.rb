# frozen_string_literal: true

describe Webhooks::Invoices::FindOrCreateClinic do
  describe '#call' do
    subject do
      described_class.call(clinic_id, clinic_name)
    end

    let(:clinic_id) { '1' }
    let(:clinic_name) { 'clinic_name' }

    context 'when clinic already exists' do
      let!(:clinic) { create(:clinic, id: 1) }

      it 'returns the clinic' do
        expect(subject).to eq(clinic)
      end

      it 'does not create a new clinic' do
        expect { subject }.not_to(change { Clinic.count })
      end
    end

    context 'when clinic does not exist' do
      it 'creates a new clinic' do
        expect { subject }.to change { Clinic.count }.by(1)
      end
    end
  end
end
