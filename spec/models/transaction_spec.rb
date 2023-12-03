# frozen_string_literal: true

describe Transaction do
  describe 'Relationships' do
    it { is_expected.to belong_to(:clinic) }
  end
end
