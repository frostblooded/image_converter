require 'rails_helper'

describe 'Received mail controller', type: :request do
  it 'handles subscription confirmation' do
    allow_any_instance_of(ReceivedMailController).to receive :confirm_subscription

    data = {
      TopicArn: SecureRandom.hex,
      Token: SecureRandom.hex
    }

    headers = {
      'x-amz-sns-message-type' => 'SubscriptionConfirmation'
    }

    post '/received_mail/endpoint', params: data, headers: headers, as: :json
    expect(response).to have_http_status 200
  end

  it 'handles normal notification' do
    headers = {
      'x-amz-sns-message-type' => 'Notification'
    }

    post '/received_mail/endpoint', params: {}, headers: headers, as: :json
    expect(response).to have_http_status 200
  end
end