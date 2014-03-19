# Unsubscribe feature have some conventions:
# - {{unsubscribe}} substitution variable must be placed somewhere in email template or body
# 
module Brightbytes
  module Sendgrid
    class Unsubscribe
      include SubstPattern
      
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
          sendgrid.section :unsubscribe_html_section, unsubscribe.html_link % key_to_tag(:unsubscribe_url)
          sendgrid.section :unsubscribe_text_section, unsubscribe.text_link % key_to_tag(:unsubscribe_url)
          emails.each do |email|
            sendgrid.add_substitute :unsubscribe_html, key_to_tag(:unsubscribe_html_section)
            sendgrid.add_substitute :unsubscribe_text, key_to_tag(:unsubscribe_text_section)
            sendgrid.add_substitute :unsubscribe_url,  unsubscribe_url(email)
          end
        else
          sendgrid.add_substitute :unsubscribe_html, Array.new(emails.size, '')
          sendgrid.add_substitute :unsubscribe_text, Array.new(emails.size, '')
          sendgrid.add_substitute :unsubscribe_url,  Array.new(emails.size, '')
        end
      end
            
      private
      
      def unsubscribe
        Brightbytes::Sendgrid.config.unsubscribe
      end
            
      def feature_active?
        unsubscribe.categories.present? || unsubscribe.url.present?
      end
            
      def categories
        @categories ||= unsubscribe.categories & sendgrid.categories
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
            
      def unsubscribe_url(email)
        if unsubscribe.url.instance_of? Proc
          unsubscribe.url.call(email: email, category: categories)
        else
          "#{unsubscribe.url}#{unsubscribe.url[-1] == '?' ? '' : '?'}#{url_parameters(email)}"
        end
      end
      
      def url_parameters(email)
        URI.encode_www_form(email: email, category: categories)
      end
            
    end
  end
end
