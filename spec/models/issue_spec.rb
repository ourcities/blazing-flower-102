require 'spec_helper'

describe Issue do
  it { should validate_presence_of :name } 
  
  describe "#petitions" do
    it { should have_many :petitions }
  end
end