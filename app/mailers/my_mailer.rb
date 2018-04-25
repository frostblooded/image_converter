class MyMailer < ApplicationMailer
  def send_email
    mail to: 'bounce@simulator.amazonses.com', subject: 'Amazon SES Test'
  end
end
