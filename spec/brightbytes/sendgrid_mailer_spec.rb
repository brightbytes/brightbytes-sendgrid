require 'spec_helper'

describe SendgridMailer do

  let(:header) { subject.header.to_s.gsub(/\r|\n/, "") }
  
  describe "when sendgrid default category is set" do
    subject(:message) { described_class.default_category }

    it 'header should have category' do
      header.should include('"category": ["system"]')
    end
  end

  describe "when sendgrid category is set" do
    subject(:message) { described_class.new_category }

    it 'header should have new category' do
      header.should include('"category": ["new_category"]')
    end
  end

  describe "when sendgrid recipients present" do
    subject(:message) { described_class.dummy_recipient }

    before(:each) { sendgrid_config_setup }

    it 'header should have dummy recipient' do
      header.should include('To: noreply@brightbytes.net')
    end
  end

  describe "when sendgrid recipients are set" do
    subject(:message) { described_class.with_recipients }

    it 'header should have recipients' do
      header.should include('"to": ["email1@email.com","email2@email.com"]')
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
      header.should include('"{{unsubscribe_link}}": ["http://example.com/u?email=email1%40email.com&category=unsubscribe","http://example.com/u?email=email2%40email.com&category=unsubscribe"]')
    end
  end
    
end
