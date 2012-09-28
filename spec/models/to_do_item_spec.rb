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


  describe "state finders" do
    let(:patient) { Patient.make! }
    let(:patient_list) do
      result = PatientList.make
      result.patients << patient
      result.save!
      result
    end

    let(:to_do_item) do
      ToDoItem.make! :status => "todo", :patient_list => patient_list, :patient => patient
    end

    before do
      to_do_item.save!
    end

    describe ".find_by_patient_and_list" do
      it "finds to do items for a given patient on a patient list" do
        ToDoItem.find_by_patient_and_list(patient, patient_list).should == [to_do_item]
      end

      it "is chainable" do
        ToDoItem.find_by_patient_and_list(patient, patient_list).class.should == ActiveRecord::Relation
      end      
    end

    describe ".patient_tasks_todo" do 
      it "finds tasks in the todo state that have not been handed over" do
        ToDoItem.patient_tasks_todo(patient, patient_list).should == [to_do_item]
      end

      it "ignores tasks in the todo state that have been handed over" do
        Handover.make! :to_do_item => to_do_item
        ToDoItem.patient_tasks_todo(patient, patient_list).to_a.should == []
      end

      it "is chainable" do
        ToDoItem.patient_tasks_todo(patient, patient_list).class.should == ActiveRecord::Relation
      end
    end


    describe ".patient_tasks_pending" do
      it "ignores tasks in the todo state that have not been handed over" do
        ToDoItem.patient_tasks_pending(patient, patient_list).should == []
      end

      it "finds tasks in the todo state that have been handed over" do
        Handover.make! :to_do_item => to_do_item
        ToDoItem.patient_tasks_pending(patient, patient_list).should == [to_do_item]
      end      

      it "is chainable" do
        ToDoItem.patient_tasks_pending(patient, patient_list).class.should == ActiveRecord::Relation
      end
    end

    describe ".patient_tasks_done" do
      it "finds tasks in the done state" do
        to_do_item.update_attribute(:status, "done")
        ToDoItem.patient_tasks_done(patient, patient_list).should == [to_do_item]
      end

      it "ignores tasks not in the done state" do
        ToDoItem.patient_tasks_done(patient, patient_list).should == []
      end

      it "is chainable" do
        ToDoItem.patient_tasks_done(patient, patient_list).class.should == ActiveRecord::Relation
      end      
    end
  end
  
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
