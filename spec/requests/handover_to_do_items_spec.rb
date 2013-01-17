require 'spec_helper'

describe "Handover to do items" do
  let!(:patient_list) { PatientList.make! }
  let!(:patient_list_b) { PatientList.make! }
  let!(:patient) { Patient.make! }
  let!(:to_do_item) { ToDoItem.make! patient: patient, patient_list: patient_list }

  before :each do
    Team.make!
    Team.make! shift: Shift.make!(name: "Day")
    login(User.make!)
  end

  it "should move a to do item from one patient list to another" do
    visit list_path(patient_list)
    click_link "Handover to do items"

    check to_do_item.description
    select patient_list_b.name, from: "Patient Lists"
    click_button "Handover to do items"

    patient_list_b.to_do_items.should == [to_do_item]
  end

  it "should move multiple items from one patient list to another" do
    to_do_item_b = ToDoItem.make! patient: patient, patient_list: patient_list

    visit list_path(patient_list)
    click_link "Handover to do items"

    page.should have_css("#content ul li", count: patient_list.to_do_items.count)

    check to_do_item.description
    check to_do_item_b.description
    select patient_list_b.name, from: "Patient Lists"
    click_button "Handover to do items"

    patient_list_b.to_do_items.should == [to_do_item, to_do_item_b]
  end

  it "shouldn't move unchecked items" do
    to_do_item_b = ToDoItem.make! patient: Patient.make!(hospno: "123"), patient_list: patient_list

    visit list_path(patient_list)
    click_link "Handover to do items"

    page.should have_css("#content ul li", count: patient_list.to_do_items.count)

    check to_do_item.description
    select patient_list_b.name, from: "Patient Lists"
    click_button "Handover to do items"

    patient_list_b.to_do_items.should == [to_do_item]
  end
  
end
