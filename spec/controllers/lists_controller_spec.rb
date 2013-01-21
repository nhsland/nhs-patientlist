require 'spec_helper'

describe ListsController do
  let (:user) { User.make! }

  before do
    sign_in user
  end
  
  describe "GET index" do
    it "renders the list index" do
      get :index
      response.should render_template "index"
    end
  end

  describe "GET show" do
    let(:patient_list) { PatientList.make! :name => "A List" }

    it "assigns the correct patient list" do
      get :show, :id => patient_list.to_param
      controller.patient_list.should == patient_list
    end

    it "renders the show page" do
      get :show, :id => patient_list.to_param
      response.should render_template "show"
    end
  end

  describe "POST create" do
    let(:valid_params) do
      {:patient_list => {:name => "Test List"}}
    end
    let(:patient_list) { PatientList.find_by_name("Test List") }
    
    context "when sucessful" do
      before do
        post :create, valid_params
      end

      it "creates a new patient list for the user" do
        user.patient_lists.should include(patient_list)
      end

      it "redirects to the new list" do
        response.should redirect_to(list_path(patient_list))
      end

      it "displays an informative notice" do
        flash[:notice].should == "Created Test List"
      end
    end

    context "on error" do
      before do
        PatientList.any_instance.stub(:save => false)
        post :create, valid_params
      end

      it "displays an error" do
        flash[:alert].should_not be_nil
        flash[:alert].should match(/Could not create list/)
      end

      it "redirects to the index" do
        response.should redirect_to lists_path
      end
    end
  end
end
