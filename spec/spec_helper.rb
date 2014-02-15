$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'action_mailer'
require 'brightbytes/sendgrid'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.deliveries = []

ActionMailer::Base.send :include, Brightbytes::Sendgrid

Dir["#{File.dirname(__FILE__)}/mailers/*.rb"].each { |f| require f }

def sendgrid_config_setup
  Brightbytes::Sendgrid.configure do |config|
    config.unsubscribe_categories :unsubscribe
    config.unsubscribe_url 'http://example.com/u'
  end
end

def sendgrid_config_reset
  Brightbytes::Sendgrid.configure do |config|
    config.unsubscribe_categories []
    config.unsubscribe_url nil
  end
end

RSpec.configure do |config|

  config.after(:each) do
    Brightbytes::Sendgrid.configure do |config|
      config.unsubscribe_categories []
      config.unsubscribe_url nil
    end
  end

end
