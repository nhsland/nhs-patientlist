require 'spec_helper'

describe PatientList do
  let(:patient)      { Patient.make! }
  let(:patient_list) { PatientList.make!(:user => current_user, :name => 'Inpatients') }
  
  it { should belong_to(:user) }
  it { should have_many(:memberships) }
  it { should have_many(:patients) }
  it { should have_many(:to_do_items) }

  it { should validate_presence_of(:name) }
  
  it "doesn't allow the same patient to be duplicated on a list" do
    patient_list.patients << patient
    patient_list.patients.reload.size.should == 1

    expect {
      patient_list.patients << patient
    }.to raise_error

    patient_list.patients.reload.size.should == 1
  end

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
end
