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
        response.should redirect_to(patient_list_path(patient_list))
      end
    end

    context "on error" do
      before do
        ToDoItem.any_instance.stub(:save => false)
        post :create, valid_params
      end

      it "redirects to the patient list index" do
        response.should redirect_to(patient_lists_path)
      end

      it "displays an error" do
        flash[:alert].should_not be_nil
        flash[:alert].should match(/Could not create todo item/)
      end
    end
  end

  describe "PUT update" do
    let(:item) { ToDoItem.make! }

    it "changes the state of a to do item from 'todo' -> 'pending'" do
      put :update, id: item.id, to_do_item: { state: 'pending' }
      item.reload
      item.state.should == 'pending'
    end

    it "changes the state of a to do item from 'todo' -> 'done'" do
      put :update, id: item.id, to_do_item: { state: 'done' }
      item.reload
      item.state.should == 'done'
    end

    it "changes the state of a to do item from 'pending' -> 'todo'" do
      item.mark_as_pending
      put :update, id: item.id, to_do_item: { state: 'todo' }
      item.reload
      item.state.should == 'todo'
    end

    it "changes the state of a to do item from 'done' -> 'todo'" do
      item.mark_as_done
      put :update, id: item.id, to_do_item: { state: 'todo' }
      item.reload
      item.state.should == 'todo'
    end

    it "only changes the state to one of: todo, pending, done" do
      put :update, id: item.id, to_do_item: { state: 'finished' }
      item.reload
      item.state.should == 'todo'
    end
  end

  describe "DESTROY delete" do
    let(:item) { ToDoItem.make! }

    it "changes the state of a to do item to 'deleted'" do
      delete :destroy, id: item.id
      item.reload
      item.state.should == 'deleted'
    end

    it "redirects to the item patient list" do
      delete :destroy, id: item.id
      response.should redirect_to(item.patient_list)
    end

  end

end
