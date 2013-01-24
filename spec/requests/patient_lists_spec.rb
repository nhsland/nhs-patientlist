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

  describe "changing membership risk levels", js: true do

    before :each do
      my_list.patients << patient
      my_list.save

      page.driver.options[:resychronize] = false

      @membership = Membership.last
    end

    it "changes the risk level" do
      visit list_path(my_list)
      choose "risk_level_#{@membership.id}_high"
      wait_until { page.evaluate_script("$.active") == 0 }
      Membership.last.reload.risk_level.should == "high"
    end

    context "with multiple patients" do

      it "changes the risk level for the correct membership" do
        my_list.patients << Patient.make!
        my_list.save
        membership_b = Membership.last

        visit list_path(my_list)
        choose "risk_level_#{@membership.id}_medium"
        wait_until { page.evaluate_script("$.active") == 0 }
        @membership.reload.risk_level.should == "medium"

        choose "risk_level_#{membership_b.id}_high"
        wait_until { page.evaluate_script("$.active") == 0 }
        membership_b.reload.risk_level.should == "high"
        @membership.reload.risk_level.should == "medium"
      end

    end

  end
end
