require 'spec_helper'

class ListsController
  skip_before_filter :authenticate_user!
end

describe ListsController do
  describe "GET show" do
    it "renders the list index" do
      get :index
      response.should render_template "index"
    end
  end 
end
