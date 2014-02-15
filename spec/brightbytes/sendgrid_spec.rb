require 'spec_helper'

describe Brightbytes::Sendgrid do

  describe "config" do
    
    subject { described_class.config }

    it "should be an instance of Config " do
      should be_instance_of Brightbytes::Sendgrid::Config
    end
    
  end

end
