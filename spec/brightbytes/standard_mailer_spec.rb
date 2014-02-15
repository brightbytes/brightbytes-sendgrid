require 'spec_helper'

describe StandardMailer do

  let(:header) { subject.header.to_s.gsub(/\r|\n/, "") }
  
  describe "when sendgrid not engaged" do
    subject(:message) { described_class.sendgrid_not_engaged }

    it 'header should not be set' do
      header.should_not include('X-SMTPAPI:')
    end
  end

  describe "when unsubscribe not required" do
    subject(:message) { described_class.unsubscribe_not_required }
    
    before(:each) { sendgrid_config_setup }

    it 'unsubscribe section should be empty' do
      header.should include('"{{unsubscribe}}": ""')
    end
  end

  describe "when unsubscribe required" do
    subject(:message) { described_class.unsubscribe_required }
    
    before(:each) { sendgrid_config_setup }

    it 'unsubscribe section should be set' do
      header.should include('"{{unsubscribe}}": "<a href=\"{{unsubscribe_link}}\">Unsubscribe</a>"')
    end

    it 'unsubscribe link should be set' do
      header.should include('"{{unsubscribe_link}}": ["http://example.com/u?email=email%40email.com&category=unsubscribe"]')
    end
  end
    
end
