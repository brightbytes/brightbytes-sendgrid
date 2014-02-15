require 'active_support'
require 'active_support/core_ext'
require 'brightbytes/sendgrid/smtp_api_header'
require 'brightbytes/sendgrid/config'
require 'brightbytes/sendgrid/unsubscribe'
require 'brightbytes/sendgrid/version'

module Brightbytes
  module Sendgrid
    extend ActiveSupport::Concern

    autoload :SmtpApiHeader, 'sendgrid/smtp_api_header'
    autoload :Config, 'sendgrid/config'
    autoload :Unsubscribe, 'sendgrid/unsubscribe'
    autoload :VERSION, 'sendgrid/version'

    included do
      delegate *Brightbytes::Sendgrid::SmtpApiHeader::DELEGATE_METHODS, to: :sendgrid, prefix: true
      alias_method_chain :mail, :sendgrid
    end
    
    protected
    
    def sendgrid
      @sendgrid ||= Brightbytes::Sendgrid::SmtpApiHeader.new(self.class.sendgrid.data)
    end
    
    def mail_with_sendgrid(headers={}, &block)
      mail_without_sendgrid(headers, &block).tap do |message|
        # Add Unsubscribe links
        Brightbytes::Sendgrid::Unsubscribe.add_links(sendgrid, message)
        # Store Sendgrid in Message for future use
        message.instance_variable_set :@sendgrid, sendgrid
        # Add X-SMTPAPI Header
        message.header['X-SMTPAPI'] = sendgrid.to_json if sendgrid.data.present?
      end
    end
    
    module ClassMethods

      delegate *Brightbytes::Sendgrid::SmtpApiHeader::DELEGATE_METHODS, to: :sendgrid, prefix: true

      def sendgrid
        @sendgrid ||= Brightbytes::Sendgrid::SmtpApiHeader.new(Brightbytes::Sendgrid.config.sendgrid.data)
      end
      
    end
    
    class << self

      def config
        Brightbytes::Sendgrid::Config.instance
      end

      def configure
        yield(self.config) if block_given?
      end
    end
    
  end
end
