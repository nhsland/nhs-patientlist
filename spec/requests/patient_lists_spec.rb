require 'spec_helper'

describe "Patient lists" do
  let(:user)       { User.make!(email: "test@example.com") }
  let(:other_user) { User.make! }
  let(:patient)    { Patient.make!(:hospno=>"4567", :firstnames=>"Rita", :lastname=>"O'Really", :allergies=>"toes", :pastmedhx=>"Grouts", :id=>123) }
  let(:admission)  { Admission.make!(:currward=>'RENAL', :admstatus => "Admitted", :patient=>patient, :admpid => 123) }
  let(:my_list)    { user.patient_lists.create(:name => "Inpatients") }

  before do
    10.times do
      User.make!
    end
    patient.save
    admission.save
    my_list.save
    login(user)
  end

  it "displays 'new list'" do
    visit user_patient_lists_path current_user
    page.should have_css '#new-list'
  end

  it "does not display 'new list' on other users' lists" do
    visit user_patient_lists_path other_user
    page.should_not have_css '#new-list'
  end


  describe "a patient list" do
    before :each do
      my_list.patients << patient
      my_list.save
    end

    it "doesn't have a delete link if it's another user's list" do
      other_list = other_user.patient_lists.create(:name => "Outpatients")
      visit user_patient_list_path other_user, other_list
      page.should_not have_content "Delete"
    end
  end
end
