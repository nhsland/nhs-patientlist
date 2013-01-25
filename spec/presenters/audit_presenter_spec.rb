require 'spec_helper'

describe AuditPresenter do
  let(:patient_list) { PatientList.make! }
  let(:membership) { Membership.make! patient_list: patient_list }
  let(:patient) { membership.patient }

  subject { AuditPresenter.new(patient.associated_audits.first) }

  it { should respond_to(:date) }
  it { should respond_to(:formatted_time) }
  it { should respond_to(:user) }
  it { should respond_to(:action) }
  it { should respond_to(:details) }

  describe "initialize" do
    it "requires an Audit as a parameter" do
      expect { AuditPresenter.new }.to raise_error
      expect { AuditPresenter.new("error") }.to raise_error

      audit = patient.associated_audits.first
      expect { AuditPresenter.new(audit) }.not_to raise_error
    end

    it "assigns audit attribute" do
      subject.audit.should == patient.associated_audits.first
    end
  end

  describe "date" do
    it "returns the correct date" do
      subject.date.should == patient.associated_audits.first.created_at.to_date
    end
  end

  describe "formatted_time" do
    it "returns the created_at time in the correct format" do
      subject.formatted_time.should == patient.associated_audits.first.created_at.strftime("%l:%I%P")
    end
  end

  describe "user" do
    it "returns the correct user" do
      subject.user.should == User.find(patient.associated_audits.first.user_id)
    end

    it "can return the user's details" do
      subject.user.email.should == User.first.email
    end
  end

  describe "action" do
    it "returns a correctly formatted string" do
      subject.action.should == "Create Membership"
    end

    context "for an update audit" do
      it "returns the appropriate string" do
        ToDoItem.make! patient: patient
        patient.to_do_items.last.update_attributes(description: "Updated!")
        update_audit = AuditPresenter.new(patient.associated_audits.last)

        update_audit.action.should == "Update To Do Item"
      end

      context "when it is a risk level update" do
        it "says risk level and not membership" do
          membership.update_attributes(risk_level: "high")

          update_audit = AuditPresenter.new(patient.associated_audits.last)
          update_audit.action.should == "Update Risk Level"
        end
      end
    end

    context "for a destroy audit" do
      it "returns the approriate string" do
        ToDoItem.make! patient: patient
        patient.to_do_items.first.destroy
        destroy_audit = AuditPresenter.new(patient.associated_audits.last)

        destroy_audit.action.should == "Destroy To Do Item"
      end
    end
  end

  describe "details" do
    let(:audit) { AuditPresenter.new(patient.associated_audits.last) }

    it "returns a string" do
      audit.details.should be_kind_of(String)
    end
  end

end
