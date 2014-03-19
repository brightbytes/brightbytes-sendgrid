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

    it 'unsubscribe html version should be empty' do
      header.should include('"{{unsubscribe_html}}": [""]')
    end

    it 'unsubscribe text version should be empty' do
      header.should include('"{{unsubscribe_text}}": [""]')
    end

    it 'unsubscribe url should be empty' do
      header.should include('"{{unsubscribe_url}}": [""]')
    end
  end

  describe "when unsubscribe required" do
    subject(:message) { described_class.unsubscribe_required }
    
    before(:each) { sendgrid_config_setup }

    it 'unsubscribe html section should be set' do
      header.should include('"{{unsubscribe_html_section}}": "If you would like to unsubscribe and stop receiving these emails <a href=\"{{unsubscribe_url}}\" rel=\"nofollow\">click here</a>."')
    end

    it 'unsubscribe text section should be set' do
      header.should include('"{{unsubscribe_text_section}}": "If you would like to unsubscribe and stop receiving these emails click here: {{unsubscribe_url}}"')
    end

    it 'unsubscribe html version should be set' do
      header.should include('"{{unsubscribe_html}}": ["{{unsubscribe_html_section}}"]')
    end

    it 'unsubscribe text version should be set' do
      header.should include('"{{unsubscribe_text}}": ["{{unsubscribe_text_section}}"]')
    end

    it 'unsubscribe url should be set' do
      header.should include('"{{unsubscribe_url}}": ["http://example.com/u?email=email%40email.com&category=unsubscribe"]')
    end
  end
    
end
