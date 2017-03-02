require 'spec_helper'

describe SendgridMailer do

  let(:header) { subject.header.to_s.gsub(/\r|\n/, "") }
  
  describe "when sendgrid default category is set" do
    subject(:message) { described_class.default_category }

    it 'header should have category' do
      expect(header).to include('"category": ["system"]')
    end
  end

  describe "when sendgrid category is set" do
    subject(:message) { described_class.new_category }

    it 'header should have new category' do
      expect(header).to include('"category": ["new_category"]')
    end
  end

  describe "when sendgrid recipients present" do
    subject(:message) { described_class.dummy_recipient }

    before(:each) { sendgrid_config_setup }

    it 'header should have dummy recipient' do
      expect(header).to include('To: noreply@brightbytes.net')
    end
  end

  describe "when sendgrid recipients are set" do
    subject(:message) { described_class.with_recipients }

    it 'header should have recipients' do
      expect(header).to include('"to": ["email1@email.com","email2@email.com"]')
    end
  end

  describe "when unsubscribe not required" do
    subject(:message) { described_class.unsubscribe_not_required }
    
    before(:each) { sendgrid_config_setup }

    it 'unsubscribe html version should be empty' do
      expect(header).to include('"{{unsubscribe_html}}": ["",""]')
    end

    it 'unsubscribe text version should be empty' do
      expect(header).to include('"{{unsubscribe_text}}": ["",""]')
    end

    it 'unsubscribe url should be empty' do
      expect(header).to include('"{{unsubscribe_url}}": ["",""]')
    end
  end
  
  describe "when unsubscribe required" do
    subject(:message) { described_class.unsubscribe_required }
    
    before(:each) { sendgrid_config_setup }
  
    it 'unsubscribe html section should be set' do
      expect(header).to include('"{{unsubscribe_html_section}}": "If you would like to unsubscribe and stop receiving these emails <a href=\"{{unsubscribe_url}}\" rel=\"nofollow\">click here</a>."')
    end

    it 'unsubscribe text section should be set' do
      expect(header).to include('"{{unsubscribe_text_section}}": "If you would like to unsubscribe and stop receiving these emails click here: {{unsubscribe_url}}"')
    end

    it 'unsubscribe html version should be set' do
      expect(header).to include('"{{unsubscribe_html}}": ["{{unsubscribe_html_section}}","{{unsubscribe_html_section}}"]')
    end

    it 'unsubscribe text version should be set' do
      expect(header).to include('"{{unsubscribe_text}}": ["{{unsubscribe_text_section}}","{{unsubscribe_text_section}}"]')
    end

    it 'unsubscribe url should be set' do
      expect(header).to include('"{{unsubscribe_url}}": ["http://example.com/u?email=email1%40email.com&category=unsubscribe","http://example.com/u?email=email2%40email.com&category=unsubscribe"]')
    end
  end
    
end
