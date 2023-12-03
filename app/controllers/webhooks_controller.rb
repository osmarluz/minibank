# frozen_string_literal: true

require 'dry/monads'

class WebhooksController < ActionController::API
  include Dry::Monads[:result]

  before_action { authorize(params[:integration], request) }

  def receive
    case Webhooks::RetrieveJob.new.call(params[:integration])
    in Success(_ => job)
      job.perform_async(
        request.params.to_h
      )
    end
  end

  private

  def authorize(integration, request)
    case Webhooks::RetrievePolicy.new.call(integration)
    in Success(_ => policy)
      head :forbidden unless policy.call(request)
    in Failure
      head :forbidden
    end
  end
end
