require 'net/http'

class UnreceivedMailController < ApplicationController
  skip_before_action :verify_authenticity_token

  def endpoint
    type = request.headers['x-amz-sns-message-type']
    body = JSON.parse(request.body.read)

    if type == 'SubscriptionConfirmation'
      confirm_subscription body
    elsif type == 'Notification'
      handle_unreceived_mail
    end

    render status: 200
  end

  private

  def confirm_subscription(body)
    client = Aws::SNS::Client.new region: 'eu-west-1'
    client.confirm_subscription topic_arn: body['TopicArn'],
                                token: body['Token']

    puts 'Subscription confirmed'
  end

  def handle_unreceived_mail

  end
end