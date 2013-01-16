require 'spec_helper'

describe PatientList do
  it { should belong_to(:user) }
  it { should have_many(:memberships) }
  it { should have_many(:patients) }
  it { should have_many(:to_do_items) }
  it { should have_many(:handed_over_items) }

  it { should validate_presence_of(:name) }
  
  describe "list name" do
    let(:other_user) { User.make! }
    
    it "is unique within a user's lists" do
      current_user.patient_lists.create!(:name => "Outpatients")
      new_list = current_user.patient_lists.new(:name => "Outpatients")
      
      new_list.should_not be_valid
    end

    it "can be repeated accross differernt user's lists" do
      current_user.patient_lists.create!(:name => "Outpatients")
      new_list = other_user.patient_lists.new(:name => "Outpatients")

      new_list.should be_valid
    end
  end

  describe "handed_over_items" do
    let(:handover)     { HandoverItem.make! }
    let(:patient_list) { handover.patient_list_from }

    it "should contain the handed over to_do_item" do
      patient_list.handed_over_items.should include(handover.to_do_item)
    end
  end
end
