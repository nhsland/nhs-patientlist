require 'spec_helper'

describe PatientList do
  it { should belong_to(:user) }
  it { should have_many(:memberships) }
  it { should have_many(:patients) }
  it { should have_many(:to_do_items) }
  it { should have_many(:handed_over_items) }

  it { should validate_presence_of(:name) }
  
  describe "list name" do
    let(:other_user) { User.make! }
    
    it "is unique within a user's lists" do
      current_user.patient_lists.create!(:name => "Outpatients")
      new_list = current_user.patient_lists.new(:name => "Outpatients")
      
      new_list.should_not be_valid
    end

    it "can be repeated accross differernt user's lists" do
      current_user.patient_lists.create!(:name => "Outpatients")
      new_list = other_user.patient_lists.new(:name => "Outpatients")

      new_list.should be_valid
    end
  end

  describe "handed_over_items association" do
    let(:handover)     { HandoverItem.make! }
    let(:patient_list) { handover.patient_list_from }

    it "should contain the handed over to_do_item" do
      patient_list.handed_over_items.should include(handover.to_do_item)
    end

    it "should not contain duplicate to_do_items" do
      handover2 = HandoverItem.make!(to_do_item: handover.to_do_item,
                                     patient_list_to: handover.patient_list_from,
                                     patient_list_from: handover.patient_list_to)
      patient_list.handed_over_items.should == [handover2.to_do_item]
    end
  end

  describe "currently_handed_over_items" do
    let(:patient_list) { PatientList.make! }
    let(:other_patient_list) { PatientList.make! }
    let(:to_do_item) { ToDoItem.make! patient_list: patient_list }

    it "doesn't include items that are currently to do" do
      patient = to_do_item.patient

      patient_list.currently_handed_over_items(patient).should be_empty
    end

    it "includes items that have been handed to another list" do
      to_do_item.handover_to(other_patient_list)

      patient_list.currently_handed_over_items(to_do_item.patient).should == [to_do_item]
    end

    it "doesn't include items that have been handed over and handed back" do
      to_do_item.handover_to(other_patient_list)
      to_do_item.handover_to(patient_list)

      patient_list.currently_handed_over_items(to_do_item.patient).should be_empty
    end

  end

  describe "all_items_with_state" do
    let!(:item) { ToDoItem.make! }
    let(:patient_list) { item.patient_list }
    let(:patient) { item.patient }
    let(:item_2) { ToDoItem.make! patient_list: patient_list, patient: patient }

    it "returns all to_do_items and currently_handed_over_items for patient" do
      item_2.handover_to(PatientList.make!)

      patient_list.all_items_with_state("todo", patient).should == [item, item_2]
    end

    it "doesn't include other patient's to do items" do
      item_3 = ToDoItem.make! patient_list: patient_list, patient: Patient.make!

      patient_list.all_items_with_state("todo", patient).should_not include(item_3)
    end

    it "doesn't include duplicate handed_over_items" do
      item_2.handover_to(PatientList.make!)
      item_2.handover_to(patient_list)

      patient_list.all_items_with_state("todo", patient).should == [item, item_2]
    end

    it "includes done items when specified" do
      pending_item = ToDoItem.make! patient_list: patient_list, patient: patient

      item.mark_as_done
      item_2.mark_as_done
      item_2.handover_to(PatientList.make!)

      patient_list.all_items_with_state("done", patient).should == [item, item_2]
    end
  end
end
