class MyMailer < ApplicationMailer
  def send_email
    mail to: 'success@simulator.amazonses.com', subject: 'Amazon SES Test'
  end
end
