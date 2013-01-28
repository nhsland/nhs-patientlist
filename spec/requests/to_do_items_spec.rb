require 'spec_helper'

describe "To do items" do
  let(:membership) { Membership.make! }
  let(:patient_list) { membership.patient_list }

  it "changes an item state to deleted" do
    login(User.make!)
    to_do_item = ToDoItem.make! patient: membership.patient, patient_list: patient_list

    visit patient_list_path(patient_list)
    click_link 'Delete item'
    to_do_item.reload.state.should == 'deleted'
  end

end
