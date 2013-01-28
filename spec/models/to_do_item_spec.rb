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
  it { should belong_to(:grade) }
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

    it "changes from 'done' -> 'todo' when mark_as_todo" do
      to_do_item = ToDoItem.make
      to_do_item.mark_as_done
      to_do_item.mark_as_todo
      to_do_item.state.should == 'todo'
    end

    it "changes from 'todo' -> 'deleted' when mark_as_deleted" do
      to_do_item = ToDoItem.make
      to_do_item.mark_as_deleted
      to_do_item.state.should == 'deleted'
    end
  end

  it "is audited" do
    item.update_attribute :state, 'done'
    item.audits.last.audited_changes['state'].should == %w{todo done}
  end

  describe "#creator" do
    let(:to_do_item) { ToDoItem.make! }

    it "finds the user who created the to do item" do
      to_do_item.creator.should == current_user.id
    end
  end

  describe "default scope" do
    it "returns all items which haven't been deleted" do
      to_do_item = ToDoItem.make!
      to_do_item.mark_as_deleted

      ToDoItem.all.should_not include(to_do_item)
    end
  end

  describe "for_patient scope" do

    it "returns all to_do_items for specified patient" do
      to_do_item = ToDoItem.make!
      patient = to_do_item.patient

      ToDoItem.for_patient(patient).should == [to_do_item]
    end

    it "excludes to_do_item items belonging to other patients" do
      ToDoItem.make!
      to_do_item = ToDoItem.make!
      patient = to_do_item.patient

      ToDoItem.for_patient(patient).should == [to_do_item]
    end

  end

  describe "for_list scope" do

    it "returns all to_do_items for list" do
      ToDoItem.for_list(patient_list).should == [item]
    end

    it "doesn't include items for other lists" do
      ToDoItem.make!
      ToDoItem.for_list(patient_list).should == [item]
    end

  end

  describe "handover_to" do
    let(:to_do_item) { ToDoItem.make! }
    let(:new_list)   { PatientList.make! }

    it "changes the patient_list it is associated with" do
      to_do_item.handover_to(new_list)
      to_do_item.patient_list.should == new_list
    end

    it "creates a handover item" do
      to_do_item.handover_to(new_list)
      HandoverItem.last.to_do_item.should == to_do_item
      HandoverItem.last.patient_list_to.should == new_list
    end

    it "creates a new Membership for the patient and new list if one doesn't exist" do
      expect do
        to_do_item.handover_to(new_list)
      end.to change(Membership, :count).by(1)
    end

    it "doesn't create a new Membership for the patient and new list if one already exists" do
      Membership.make! patient_list: new_list, patient: to_do_item.patient
      expect do
        to_do_item.handover_to(new_list)
      end.not_to change(Membership, :count)
    end

  end

end
