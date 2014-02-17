class SendgridMailer < ActionMailer::Base
  default from: 'support@brightbytes.net',
          subject: 'Clarity'

  sendgrid_categories :system

  def default_category
    mail to: 'email@email.com', body: 'Hello!'
  end

  def new_category
    sendgrid_categories :new_category
    mail body: 'Hello!'
  end

  def dummy_recipient
    sendgrid_add_recipients 'email@email.com'
    mail body: 'Hello!'
  end

  def with_recipients
    sendgrid_recipients 'email1@email.com', 'email2@email.com'
    mail body: 'Hello!'
  end

  def unsubscribe_not_required
    sendgrid_recipients 'email1@email.com', 'email2@email.com'
    mail body: 'Hello!'
  end

  def unsubscribe_required
    sendgrid_recipients 'email1@email.com', 'email2@email.com'
    sendgrid_categories :unsubscribe
    mail body: 'Hello!'
  end


end
