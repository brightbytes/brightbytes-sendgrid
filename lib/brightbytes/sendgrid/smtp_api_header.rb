require 'json'

module Brightbytes
  module Sendgrid
    class SmtpApiHeader
      include SubstPattern
      
      DELEGATE_METHODS = [
        :substitute,
        :add_substitute,
        :section, 
        :unique_args,
        :categories, 
        :add_categories,
        :recipients,
        :add_recipients,
        :filter_setting, 
        :enable, 
        :disable, 
        :ganalytics_options,
        :bcc
      ]
      
      VALID_FILTERS = [
        :bcc,
        :dkim,
        :domainkeys,
        :forwardspam,
        :opentrack,
        :clicktrack,
        :ganalytics,
        :gravatar,
        :subscriptiontrack,
        :template,
        :footer,
        :spamcheck,
        :bypass_list_management
      ]
      
      VALID_GANALYTICS_OPTIONS = [
        :utm_source,
        :utm_medium,
        :utm_campaign,
        :utm_term,
        :utm_content
      ]
            
      attr_reader :data
            
      def initialize(default_data = nil)
        @data = default_data.instance_of?(Hash) ? default_data.dup : Hash.new { |h,k| h[k] = Hash.new(&h.default_proc) }
      end
                  
      def substitute(key, values)
        @data[:sub][key_to_tag(key)] = Array.wrap(values)
      end

      def add_substitute(key, values)
        @data[:sub][key_to_tag(key)] = [] unless @data[:sub][key_to_tag(key)].instance_of?(Array)
        @data[:sub][key_to_tag(key)] += Array.wrap(values)
      end

      def section(key, value)
        @data[:section][key_to_tag(key)] = value.to_s
      end

      def unique_args(value)
        @data[:unique_args] = value if value.instance_of?(Hash)
      end

      # getter/setter
      def categories(*categories)
        @data[:category] = categories.flatten.map(&:to_sym) if categories.flatten.present?
        @data.fetch(:category, [])
      end

      def add_categories(*categories)
        init_array_key :category
        @data[:category] |= categories.flatten.map(&:to_sym)
      end

      # getter/setter
      def recipients(*recipients)
        @data[:to] = recipients.flatten if recipients.flatten.present?
        @data.fetch(:to, [])
      end

      def add_recipients(*recipients)
        init_array_key :to
        @data[:to] += recipients.flatten
      end

      def filter_setting(filter, setting, value)
        return unless VALID_FILTERS.include? filter
        @data[:filters][filter][:settings][setting] = value
      end

      def enable(*filters)
        filters.flatten.each { |filter| filter_setting filter, :enabled, 1 }
      end

      def disable(*filters)
        filters.flatten.each { |filter| filter_setting filter, :enabled, 0 }
      end
            
      def ganalytics_options(options = {})
        options.reject! { |k,v| !VALID_GANALYTICS_OPTIONS.include?(k) }
        if options.present?
          options.each { |setting, value| filter_setting :ganalytics, setting, value }
          enable :ganalytics
        end
      end

      def bcc(email)
        filter_setting :bcc, :email, email
        enable :bcc
      end
      
      def to_json
        JSON.generate(@data, {indent: '', space: ' ', space_before: '', object_nl: '', array_nl: ''})
      end
      
      private
                      
      def init_array_key(key)
        @data[key] = [] unless @data[key].instance_of?(Array)
      end
      
    end
  end
end
