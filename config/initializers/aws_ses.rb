# This requires the AWS credentials to be available on the system
Aws::Rails.add_action_mailer_delivery_method(:aws_sdk,region: 'eu-west-1')
