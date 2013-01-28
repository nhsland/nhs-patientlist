require 'spec_helper'

describe "Handover to do items" do
  let!(:patient_list) { PatientList.make! }
  let!(:patient_list_b) { PatientList.make! }
  let!(:patient) { Patient.make! }
  let!(:to_do_item) { ToDoItem.make! patient: patient, patient_list: patient_list }

  before :each do
    login(User.make!)
  end

  it "moves a to do item from one patient list to another" do
    visit patient_list_path(patient_list)
    click_link "Hand over to do items"

    check to_do_item.description
    select patient_list_b.name, from: "To list"
    click_button "Hand over to do items"

    patient_list_b.to_do_items.should == [to_do_item]
  end

  it "moves multiple items from one patient list to another" do
    to_do_item_b = ToDoItem.make! patient: patient, patient_list: patient_list

    visit patient_list_path(patient_list)
    click_link "Hand over to do items"

    page.should have_css('input[type="checkbox"]', count: patient_list.to_do_items.count)

    check to_do_item.description
    check to_do_item_b.description
    select patient_list_b.name, from: "To list"
    click_button "Hand over to do items"

    patient_list_b.to_do_items.should == [to_do_item, to_do_item_b]
  end

  it "doesn't move unchecked items" do
    to_do_item_b = ToDoItem.make! patient: Patient.make!(hospno: "123"), patient_list: patient_list

    visit patient_list_path(patient_list)
    click_link "Hand over to do items"

    check to_do_item.description
    select patient_list_b.name, from: "To list"
    click_button "Hand over to do items"

    patient_list_b.to_do_items.should == [to_do_item]
  end

  it "moves to do items from multiple patients" do
    to_do_item_b = ToDoItem.make! patient: Patient.make!(hospno: "123"), patient_list: patient_list

    visit patient_list_path(patient_list)
    click_link "Hand over to do items"

    check to_do_item.description
    check to_do_item_b.description
    select patient_list_b.name, from: "To list"
    click_button "Hand over to do items"

    patient_list_b.to_do_items.should == [to_do_item, to_do_item_b]
  end

end
