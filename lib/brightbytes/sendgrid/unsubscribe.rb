# Unsubscribe feature have some conventions:
# - {{unsubscribe}} substitution variable must be placed somewhere in email template or body
# 
module Brightbytes
  module Sendgrid
    class Unsubscribe
      
      class << self
      
        def add_links(sendgrid, message)
          new(sendgrid, message).add_links
        end
        
      end
      
      attr_reader :sendgrid
      attr_reader :message
            
      def initialize(sendgrid, message)
        @sendgrid, @message = sendgrid, message
      end
      
      def add_links
        return unless feature_active?
        if categories.present?
          sendgrid.section :unsubscribe, "<a href=\"{{unsubscribe_link}}\">Unsubscribe</a>"
          emails.each do |email|
            sendgrid.add_substitute :unsubscribe_link, unsubscribe_link(email)
          end
        else
          sendgrid.section :unsubscribe, ''
          sendgrid.add_substitute :unsubscribe_link, Array.new(emails.size, '')
        end
      end
            
      private
      
      def config
        Brightbytes::Sendgrid.config.unsubscribe
      end
      
      delegate :categories, :url, to: :config, prefix: :unsubscribe
      
      def feature_active?
        unsubscribe_categories.present? || unsubscribe_url.present?
      end
            
      def categories
        @categories ||= unsubscribe_categories & sendgrid.categories
      end

      def emails
        @emails ||= recipients.map{ |e| e =~ /([^<]+)\s<(.*)>|(.*)/; $2 || $3 }
      end
      
      def recipients
        sendgrid.recipients + message_recipients
      end
      
      def message_recipients
        Array.wrap(message.to) + Array.wrap(message.cc) + Array.wrap(message.bcc)
      end
      
      def unsubscribe_link(email)
        if unsubscribe_url.instance_of? Proc
          unsubscribe_url.call(email: email, category: categories)
        else
          "#{unsubscribe_url}#{unsubscribe_url[-1] == '?' ? '' : '?'}#{url_parameters(email)}"
        end
      end
      
      def url_parameters(email)
        URI.encode_www_form(email: email, category: categories)
      end
            
    end
  end
end
