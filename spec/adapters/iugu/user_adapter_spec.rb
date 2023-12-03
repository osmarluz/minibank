# frozen_string_literal: true

describe Iugu::UserAdapter do
  describe '.find', :vcr do
    subject { described_class.find(id:) }

    let(:id) { '324A1CA97321401BB612AA680CFBA337' }

    it 'returns user data' do
      expect(subject['id']).to eq('324A1CA97321401BB612AA680CFBA337')
    end
  end
end
