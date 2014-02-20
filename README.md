# Brightbytes::Sendgrid

[![Gem Version](https://badge.fury.io/rb/brightbytes-sendgrid.png)](http://badge.fury.io/rb/brightbytes-sendgrid)

This gem allows for painless integration between ActionMailer and the SendGrid SMTP API.
The current scope of this gem is focused around setting configuration options for outgoing email (essentially, setting categories, filters and the settings that can accompany those filters). 

SendGrid's service allows to automatically include Unsubscribe link into your emails. Unfortunately, SendGrid doesn't manage multiple unsubscriptions lists based on your's emails categories.

Visit [SendGrid SMTP API](http://sendgrid.com/docs/API_Reference/SMTP_API/index.html) to learn more.

## Installation

Add this line to your application's Gemfile:

    gem 'brightbytes-sendgrid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install brightbytes-sendgrid
    
In your config/initializers/sendgrid.rb:

    ActionMailer::Base.send :include, Brightbytes::Sendgrid
    
    Brightbytes::Sendgrid.configure do |config|
      config.default_categories :system
      config.unsubscribe_categories :system, :onboarding
      config.unsubscribe_url 'http://brightbytes.net/unsubscribe'
    end

Or use it with selected mailers:

    Brightbytes::Sendgrid

## Usage

You can use following methods to set both global and per-email SendGrid SMTP API header options:

**sendgrid_substitute**

    sendgrid_substitute :full_name, ['Jack', 'John']
    sendgrid_substitute '{{some_text}}', 'another text'
    
**sendgrid_section**

    sendgrid_section :greeting, I18n.translate('Hello')
    
**sendgrid_unique_args**

    sendgrid_unique_args email_id: 12345

**sendgrid_categories**

    sendgrid_categories :newsletter
    
**sendgrid_recipients**

    sendgrid_recipients 'email1@email.com', 'email2@email.com'

**sendgrid_enable**

    sendgrid_enable :opentrack
    
**sendgrid_disable**
  
    sendgrid_disable :clicktrack
    
**sendgrid_bcc**

    sendgrid_bcc 'some@email.com'
    
## Auto generated unsubscribe link

It is not a SendGrid **subscriptiontrack** filter!

What we diong here is just collecting recipients and generating unsubscribe links for every recipient.
Those links will be sent as a substitutions to SendGrid.

So, to make this feature work, you have to:

1. Configure unsubscribe categories. It will trigger link generator

        config.unsubscribe_categories [:newsletter, :notifications]
      
2. Configure an unsubscribe_url. The resulting URL will be composed of unsubscribe_url and email and category parameters.

        config.unsubscribe_url 'http://domain.com/unsubscribe'
        config.unsubscribe_url Proc.new { |params| your_way_to_build_the_url(params) }
        
3. Put {{unsubscribe_html}} or {{unsubscribe_text}} or {{unsubcribe_url}} placeholder somewhere in your email body. You can adjust how html and text version are built:

        config.unsubcribe_html_message "Click here to"
        config.unsubcribe_link_text "unsubcribe"
        # will produce "Click here to <a href="url">unsubscribe</a>"
        config.unsubcribe_text_message "Go there to unsubscribe:"
        # will produce "Go there to unsubscribe: url"

##Contributors

This gem is written using code samples from:

* [http://github.com/stephenb/sendgrid](http://github.com/stephenb/sendgrid)
* [https://github.com/kylejginavan/sendgrid_smtpapi](https://github.com/kylejginavan/sendgrid_smtpapi)

