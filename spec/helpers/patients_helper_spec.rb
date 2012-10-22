require 'spec_helper'

describe PatientsHelper do
  let(:patient){ Patient.make(:firstnames=>"Rita", :lastname=>"O'Really") }

  describe :full_name do
    it "concats first and last names" do
      helper.full_name(patient).should == "Rita O'Really"
    end
  end
end
