require 'singleton'

module Brightbytes
  module Sendgrid
    class Config
      include Singleton
      
      attr_accessor :dummy_recipient

      # Sendgrid default settings storage
      
      delegate *Brightbytes::Sendgrid::SmtpApiHeader::DELEGATE_METHODS, to: :sendgrid, prefix: :default

      def sendgrid
        @sendgrid ||= Brightbytes::Sendgrid::SmtpApiHeader.new
      end

      # Unsubscribe default settings storage

      class UnsubscribeConfig < Struct.new(:categories, :url); end
      
      def unsubscribe
        @unsubscribe ||= UnsubscribeConfig.new([],nil)
      end

      def unsubscribe_categories(*categories)
        unsubscribe.categories = categories.flatten.map(&:to_sym)
      end

      def unsubscribe_url(url)
        unsubscribe.url = url
      end

    end
  end
end
