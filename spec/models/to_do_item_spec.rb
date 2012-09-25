require 'spec_helper'

describe ToDoItem do
  let(:patient)      { Patient.make!(:firstnames=>'Rita', :lastname=>"O'Really") }
  let(:patient_list) { PatientList.make! :name => "Test List" }
  let(:item)         do
    ToDoItem.make! :description  => "5mg of pentaflourowhatsit, stat",
                   :patient_list => patient_list,
                   :patient => patient
  end
 
  it { should belong_to(:patient_list) }
  it { should belong_to(:patient) }
  it { should validate_presence_of(:description) }
 
  it "is created in 'todo' state by default" do
    item.reload.status.should == 'todo'
  end

  it "is audited" do
    item.update_attribute :status, 'pending'
    item.audits.last.audited_changes['status'].should == %w{todo pending}
  end

  describe "#handed_over?" do
    it "is false when the task has not been handed over" do
      item.should_not be_handed_over
    end

    it "is true when the task is on a handover list" do
      handover = Handover.make! :to_do_item => item
      item.should be_handed_over
    end
  end
end
