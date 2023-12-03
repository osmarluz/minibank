# frozen_string_literal: true

describe Clinic do
  describe 'Relationships' do
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end
end
