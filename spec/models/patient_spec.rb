require 'spec_helper'

describe Patient do
  let(:patient) { Patient.make! }

  describe ".not_discharged" do
    let(:admission) { Admission.make! :patient => patient }

    before do
      Admission.make! :patient => patient, :admstatus => "Discharged"
      admission.save!
    end
    
    it "finds patients with an admission that has not been discharged" do
      Patient.not_discharged.should == [patient]
    end

    it "ignores patients discharged from all admissions" do
      admission.update_attribute(:admstatus, "Discharged")
      Patient.not_discharged.should == []
    end

    it "is chainable" do
      Patient.not_discharged.class.should == ActiveRecord::Relation
    end
  end

  describe "current_ward" do
    let!(:renal_admission) { Admission.make! :currward => "RENAL", :admstatus => "Admitted", :patient => patient }
    let!(:ortho_admission) { Admission.make! :currward => "ORTHO", :admstatus => "Discharged", :patient => patient }

    it "finds the ward name for the admission that has not been discharged" do
      patient.current_ward.should == "RENAL"
    end

    it "returns 'Discharged' when the patient is no longer in the hospital" do
      renal_admission.update_attribute(:admstatus, "Discharged")
      patient.current_ward.should == "Discharged"
    end
  end
end
