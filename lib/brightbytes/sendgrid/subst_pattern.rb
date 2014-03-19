module Brightbytes
  module Sendgrid
    module SubstPattern
      extend ActiveSupport::Concern
      
      DEFAULT_PATTERN = '{{\1}}'
      
      private
      
      def key_to_tag(key)
        key.is_a?(Symbol) ? key.to_s.sub(/(.*)/, subst_pattern) : key.to_s
      end
                  
      def subst_pattern
        Brightbytes::Sendgrid.config.subst_pattern || DEFAULT_PATTERN
      end
      
    end
  end
end
