# frozen_string_literal: true

describe 'clinics/' do
  describe 'GET /index' do
    let!(:clinic) { create(:clinic) }

    it 'renders the index page succesfully', :aggregate_failures do
      get clinics_path

      expect(response).to be_successful
      assert_select('td', clinic.name)
    end
  end

  describe 'GET /show' do
    let(:clinic) { create(:clinic, balance: 123.45) }
    let!(:transaction) { create(:transaction, amount: 123.45, clinic:) }

    it 'renders the show page succesfully', :aggregate_failures do
      get clinic_path(clinic)

      expect(response).to be_successful
      assert_select('h2', clinic.name)
      assert_select('span', 'R$ 123,45')
      assert_select('td', 'R$ 123,45')
    end
  end
end
