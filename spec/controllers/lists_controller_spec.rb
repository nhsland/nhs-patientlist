require 'spec_helper'

class ListsController
  skip_before_filter :authenticate_user!
end

describe ListsController do
  describe "GET index" do
    it "renders the list index" do
      get :index
      response.should render_template "index"
    end
  end

  describe "GET show" do
    let(:patient_list) { PatientList.make! :name => "A List" }

    it "renders the show page" do
      get :show, :id => patient_list.to_param
      response.should render_template "show"
    end
  end
end
