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
  it { should validate_presence_of(:patient) }
  it { should validate_presence_of(:patient_list) }


  describe "state" do
    it "instanciates a new object with the state todo" do
      ToDoItem.new.state.should == 'todo'
    end

    it "changes from 'todo' -> 'pending' when mark_as_pending" do
      to_do_item = ToDoItem.make
      to_do_item.mark_as_pending
      to_do_item.state.should == 'pending'
    end

    it "changes from 'pending' -> 'done' when mark_as_done" do
      to_do_item = ToDoItem.make
      to_do_item.mark_as_pending
      to_do_item.mark_as_done
      to_do_item.state.should == 'done'
    end
  end


  describe ".find_by_patient_and_list" do
    let(:patient) { Patient.make! }
    let(:patient_list) do
      result = PatientList.make
      result.patients << patient
      result.save!
      result
    end

    let(:to_do_item) do
      ToDoItem.make! :patient_list => patient_list, :patient => patient
    end

    before do
      to_do_item.save!
    end

    it "finds to do items for a given patient on a patient list" do
      ToDoItem.find_by_patient_and_list(patient, patient_list).should == [to_do_item]
    end

    it "is chainable" do
      ToDoItem.find_by_patient_and_list(patient, patient_list).class.should == ActiveRecord::Relation
    end

  end

  it "is audited" do
    item.update_attribute :state, 'done'
    item.audits.last.audited_changes['state'].should == %w{todo done}
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

  describe "#creator" do
    let(:to_do_item) { ToDoItem.make! }

    it "finds the user who created the to do item" do
      to_do_item.creator.should == current_user.id
    end
  end
end
