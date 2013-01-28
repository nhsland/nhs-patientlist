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

  describe "#details" do
    let(:audit) { AuditPresenter.new(patient.associated_audits[-1]) }

    it "returns a string" do
      audit.details.should be_kind_of(String)
    end

    describe "for a to do item audit" do
      context "when created" do
        it "outputs 'To do item Blood Sample created'" do
          ToDoItem.make! patient: patient, patient_list: patient_list, description: "Blood Sample"
          audit.details.should == "To do item Blood Sample created"
        end
      end

      context "when updated" do
        let(:to_do_item) { ToDoItem.make! patient: patient, patient_list: patient_list }

        it 'outputs "State changed from todo to done"' do
          to_do_item.mark_as_done
          audit.details.should == "State changed from todo to done"
        end

        it 'outputs "State changed from todo to pending"' do
          to_do_item.mark_as_pending
          audit.details.should == "State changed from todo to pending"
        end

        it 'outputs "State changed from todo to deleted"' do
          to_do_item.mark_as_deleted
          audit.details.should == "State changed from todo to deleted"
        end
      end

      context "when handed over" do
        let(:to_do_item) { ToDoItem.make! description: "Blood Sample", patient: patient, patient_list: patient_list }
        let(:other_list) { PatientList.make! name: "Nightshift" }

        it 'outputs "Handed over to patient list: Nightshift"' do
          to_do_item.handover_to(other_list)
          audit.details.should == "Blood Sample handed over to patient list: Nightshift"
        end

        it "includes deleted handed over items" do
          to_do_item.mark_as_deleted
          to_do_item.handover_to(other_list)
          audit.details.should == "Blood Sample handed over to patient list: Nightshift"
        end
      end
    end

    describe "for a membership audit" do
      context "when created" do
        it 'outputs "Added to patient list: Outpatients"' do
          Membership.make! patient_list: (PatientList.make! name: "Outpatients"), patient: patient
          audit.details.should == "Added to patient list: Outpatients"
        end

        it 'outputs "Added to patient list: Nightshift"' do
          Membership.make! patient_list: (PatientList.make! name: "Nightshift"), patient: patient
          audit.details.should == "Added to patient list: Nightshift"
        end
      end

      context "when deleted" do
        it 'outputs "Removed from patient list: Outpatients"' do
          Membership.make! patient_list: (PatientList.make! name: "Outpatients"), patient: patient
          Membership.last.destroy
          audit.details.should == "Removed from patient list: Outpatients"
        end
      end

      context "when risk level is changed" do
        it 'outputs "Risk level changed from low to medium"' do
          membership.risk_level = "medium"
          membership.save

          audit.details.should == "Risk level changed from low to medium"
        end

        it 'outputs "Risk level changed from low to high"' do
          membership.risk_level = "high"
          membership.save

          audit.details.should == "Risk level changed from low to high"
        end
      end
    end

  end

end
