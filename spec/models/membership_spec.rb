require 'spec_helper'

class Membership
  attr_accessible :patient, :patient_list
end

describe Membership do
  let(:patient)      { Patient.make! }
  let(:patient_list) { PatientList.make! :user => current_user }
  let(:membership)   { Membership.create! :patient => patient, :patient_list => patient_list }
    
  it { should belong_to(:patient) }
  it { should belong_to(:patient_list) }

  it { should validate_presence_of(:patient_id) }
  it { should validate_presence_of(:patient_list_id) }
  

  it "returns its owner" do
    membership.owner.should == current_user
  end

  it "doesn't allow the same patient to be duplicated on a list" do
    membership.save!
    new_membership = Membership.new :patient_list => patient_list, :patient => patient

    new_membership.should_not be_valid
  end
end
