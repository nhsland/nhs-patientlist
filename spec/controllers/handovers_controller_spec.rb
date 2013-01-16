require 'spec_helper'

describe HandoversController do
  login_user

  let (:to_do_item)   { ToDoItem.make! }
  let (:to_do_item_2) { ToDoItem.make!(:patient_list => to_do_item.patient_list, :patient => to_do_item.patient) }
  let (:list)         { to_do_item.patient_list }
  let (:new_list)     { PatientList.make! }

  describe "#new" do

    it "renders the new template" do
      get :new, :list_id => list
      response.should render_template :new
    end

    it "sets the current list" do
      get :new, :list_id => list
      controller.patient_list.should == list
    end

    it "assigns @patients_with_to_do_items" do
      get :new, :list_id => list
      assigns(:patients_with_to_do_items).should include(to_do_item.patient)
    end

    it "assigns @patient_lists that doesn't include the current list" do
      get :new, :list_id => list
      assigns(:patient_lists).should_not include(list)
    end

  end

  describe "#create" do

    describe "ensure a patient membership on that list exists" do

      it "should create a membership if it doesn't exist" do
        expect do
          post :create, :list_id => list, :to_do_items => to_do_item.id, :to_list => new_list
        end.to change(Membership, :count).by(1)
      end

      it "should use the membership if one exists" do
        Membership.make!(:patient_list => new_list, :patient => to_do_item.patient)
        expect do
          post :create, :list_id => list, :to_do_items => to_do_item.id, :to_list => new_list
        end.not_to change(Membership, :count)
      end

    end

    context "with a single to_do_item" do

      before :each do
        post :create, :list_id => list, :to_do_items => to_do_item.id, :to_list => new_list
      end

      it "changes the list that the to_do_item belongs to" do
        ToDoItem.first.patient_list.should == new_list
      end

      it "redirects to the original list" do
        response.should redirect_to(list_path(list))
      end

    end

    context "with multiple to_do_items" do

      it "changes the list that the to_do_items belong to" do
        post :create, :list_id => list, :to_do_items => [to_do_item.id, to_do_item_2.id], :to_list => new_list
        ToDoItem.first.patient_list.should == new_list
        ToDoItem.last.patient_list.should == new_list
      end

    end

    it "should set a flash message if no to_do_items are selected" do
      post :create, :list_id => list, :to_list => new_list
      flash[:error].should =~ /You must select at least one item to hand over/
      response.should redirect_to(new_list_handover_path(list))
    end

    it "should ignore any to_do_items that aren't in the original list" do
      bad_to_do_item = ToDoItem.make!(:patient => to_do_item.patient, :patient_list => new_list)
      expect do
        post :create, :list_id => list, :to_do_items => bad_to_do_item, :to_list => new_list
      end.not_to change(list.to_do_items, :count)
    end

  end

end
