require 'spec_helper'

describe PatientList do
  let(:patient) { Patient.make! }
  let(:outpatients) { "Outpatients" }
  # current_user via spec_helper
  let(:list) { PatientList.make!(:user => current_user, :name => 'Inpatients') }
  it "can have patients added to it" do
    list.patients << patient
    list.save!

    lists = PatientList.find_all_by_user_id current_user.id
    lists.size.should == 1
    l = lists.first
    l.user.should == current_user
    l.name.should == "Inpatients"
    patients = l.patients
    patients.size.should == 1
    p = patients.first
    p.should == patient
  end
  it "requires a name" do
    expect {
      current_user.patient_lists.create()
    }.to change(PatientList, :count).by(0)
  end

  it "validates uniques of name" do
    current_user.patient_lists.create!(:name => outpatients)
    expect {
      current_user.patient_lists.create(:name => outpatients)
    }.to change(PatientList, :count).by(0)
  end
  
end