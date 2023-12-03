# frozen_string_literal: true

require 'dry/monads'

describe 'webhooks/' do
  include Dry::Monads[:result]

  describe 'GET /receive' do
    let(:policy_operation) { instance_double(Webhooks::RetrievePolicy) }

    before do
      expect(Webhooks::RetrievePolicy).to receive(:new).and_return(policy_operation)
    end

    context 'when policy exists' do
      let(:policy) { double }

      before do
        expect(policy_operation).to receive(:call)
          .with('iugu')
          .and_return(Success(policy))
      end

      context 'when policy returns true' do
        before do
          expect(policy).to receive(:call)
            .and_return(true)
        end

        it 'returns successful response' do
          post webhooks_receive_path(:iugu)

          expect(response).to be_successful
        end

        it 'calls the job to process the incoming notification', :aggregate_failures do
          job_operation = instance_double(Webhooks::RetrievePolicy)
          job = double

          expect(Webhooks::RetrieveJob).to receive(:new).and_return(job_operation)
          expect(job_operation).to receive(:call)
            .with('iugu')
            .and_return(Success(job))
          expect(job).to receive(:perform_async)
            .with({
                    'action' => 'receive',
                    'controller' => 'webhooks',
                    'integration' => 'iugu'
                  })

          post webhooks_receive_path(:iugu)
        end
      end

      context 'when policy returns false' do
        before do
          expect(policy).to receive(:call)
            .and_return(false)
        end

        it 'does not call the job to process the incoming notification' do
          post webhooks_receive_path(:iugu)

          expect(response).to be_forbidden
        end
      end
    end

    context 'when policy does not exist' do
      before do
        expect(policy_operation).to receive(:call)
          .with('iugu')
          .and_return(Failure())
      end

      it 'does not call the job to process the incoming notification' do
        post webhooks_receive_path(:iugu)

        expect(response).to be_forbidden
      end
    end
  end
end
