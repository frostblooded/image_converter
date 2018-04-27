require 'rails_helper'

describe ReceivedMailController do
  describe '#endpoint' do
    it 'confirms subscription' do
      data = {
        TopicArn: SecureRandom.hex,
        Token: SecureRandom.hex
      }

      @request.headers['x-amz-sns-message-type'] = 'SubscriptionConfirmation'

      expect_any_instance_of(ReceivedMailController)
        .to receive(:confirm_subscription)

      post :endpoint, params: data, as: :json
    end
  end
end