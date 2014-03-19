require 'singleton'

module Brightbytes
  module Sendgrid
    class Config
      include Singleton
      
      attr_accessor :dummy_recipient, :subst_pattern

      # Sendgrid default settings storage
      
      delegate *Brightbytes::Sendgrid::SmtpApiHeader::DELEGATE_METHODS, to: :sendgrid, prefix: :default

      def sendgrid
        @sendgrid ||= Brightbytes::Sendgrid::SmtpApiHeader.new
      end

      # Unsubscribe default settings storage

      class UnsubscribeConfig < Struct.new(:categories, :url, :html_link, :text_link); end
      
      def unsubscribe
        @unsubscribe ||= UnsubscribeConfig.new(
          [],
          nil, 
          'If you would like to unsubscribe and stop receiving these emails <a href="%s" rel="nofollow">click here</a>.',
          'If you would like to unsubscribe and stop receiving these emails click here: %s'
        )
      end

      def unsubscribe_categories(*categories)
        unsubscribe.categories = categories.flatten.map(&:to_sym)
      end

      [:url, :html_link, :text_link].each do |meth|
        class_eval <<-DEF
          def unsubscribe_#{meth}(value)
            unsubscribe.#{meth} = value
          end
        DEF
      end
      
    end
  end
end
