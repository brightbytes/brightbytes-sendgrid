class StandardMailer < ActionMailer::Base
  default from: 'support@brightbytes.net',
          subject: 'Clarity'
          
  def sendgrid_not_engaged
    mail to: 'email@email.com', body: 'Hello!'
  end

  def unsubscribe_not_required
    mail to: 'email@email.com', body: 'Hello!'
  end

  def unsubscribe_required
    sendgrid_categories :unsubscribe
    mail to: 'email@email.com', body: 'Hello!'
  end

end
