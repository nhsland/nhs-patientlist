require 'spec_helper'

describe ToDoItemsController do
  let(:user) { User.make! }

  before do
    sign_in user
  end

  describe "POST create" do
    let!(:patient)      { Patient.make! }
    let!(:patient_list) { PatientList.make! }
    let(:valid_params) do
      {
        :to_do_item => {
          :description     => "do something",
          :patient_list_id => patient_list.to_param,
          :patient_id      => patient.to_param
        }
      }
    end
    let(:to_do_item) { patient_list.to_do_items.find_by_description("do something") }

    context "on success" do
      before do
        post :create, valid_params
      end

      it "creates a new to do item linked to the patient and the list" do
        to_do_item.should_not be_nil
        patient_list.to_do_items.should include(to_do_item)
        patient.to_do_items.should include(to_do_item)
      end

      it "redirects to the patient list" do
        response.should redirect_to(list_path(patient_list))
      end
    end

    context "on error" do
      before do
        ToDoItem.any_instance.stub(:save => false)
        post :create, valid_params
      end

      it "redirects to the patient list index" do
        response.should redirect_to(lists_path)
      end

      it "displays an error" do
        flash[:alert].should_not be_nil
        flash[:alert].should match(/Could not create todo item/)
      end
    end
  end
end
