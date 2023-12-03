# frozen_string_literal: true

describe Iugu::InvoiceAdapter do
  describe '.find', :vcr do
    subject { described_class.find(id:) }

    let(:id) { '1EDC9C2A32244F749ABBE1E9CF70AD3E' }

    it 'returns invoice data' do
      expect(subject['id']).to eq('1EDC9C2A32244F749ABBE1E9CF70AD3E')
    end
  end
end
