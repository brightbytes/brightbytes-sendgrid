require 'spec_helper'

describe Brightbytes::Sendgrid::SmtpApiHeader do

  let(:header) { described_class.new }
  
  subject { header.to_json }

  it { should eql '{}' }
  
  it "contains substitution" do
    header.substitute :key, 'Hello'
    should eql '{"sub": {"{{key}}": ["Hello"]}}'
  end

  it "adds substitution" do
    header.substitute :key, 'Hello'
    header.add_substitute :key, ['Again', 'And Again']
    should eql '{"sub": {"{{key}}": ["Hello","Again","And Again"]}}'
  end

  it "contains section" do
    header.section :key, 'Hello'
    should eql '{"section": {"{{key}}": "Hello"}}'
  end

  it "contains category" do
    header.categories :category_name
    should eql '{"category": ["category_name"]}'
  end

  it "adds category" do
    header.categories :category_name
    header.add_categories :new_category, :category_name
    should eql '{"category": ["category_name","new_category"]}'
  end

  it "contains 1 recipient (as array)" do
    header.recipients 'email1@email.com'
    should eql '{"to": ["email1@email.com"]}'
  end

  it "adds recipients" do
    header.recipients 'email1@email.com'
    header.add_recipients 'email2@email.com'
    should eql '{"to": ["email1@email.com","email2@email.com"]}'
  end

  it "contains unique args" do
    header.unique_args arg1: 'val1'
    should eql '{"unique_args": {"arg1": "val1"}}'
  end

  it "contains valid filter settings" do
    header.filter_setting :opentrack, :setting, 'value'
    should eql '{"filters": {"opentrack": {"settings": {"setting": "value"}}}}'
  end

  it "skips invalid filter settings" do
    header.filter_setting :somefilter, :setting, 'value'
    should eql '{}'
  end
    
  it "enables filters" do
    header.enable :opentrack, :bcc
    should eql '{"filters": {"opentrack": {"settings": {"enabled": 1}},"bcc": {"settings": {"enabled": 1}}}}'
  end

  it "disables filters" do
    header.disable :opentrack, :bcc
    should eql '{"filters": {"opentrack": {"settings": {"enabled": 0}},"bcc": {"settings": {"enabled": 0}}}}'
  end
  
end
