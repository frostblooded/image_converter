require 'rails_helper'

describe 'Received mail controller', type: :request do
  it 'handles correct notification' do
    data = {
      TopicArn: SecureRandom.hex,
      Token: SecureRandom.hex
    }

    headers = {
      'x-amz-sns-message-type' => 'SubscriptionConfirmation'
    }

    expect_any_instance_of(ReceivedMailController)
      .to receive(:confirm_subscription)

    post '/received_mail/endpoint', params: data, headers: headers, as: :json
  end
end