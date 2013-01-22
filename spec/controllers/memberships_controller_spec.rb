require 'spec_helper'

describe MembershipsController do
  before do
    user = User.make!
    sign_in user
  end
  
  describe "PUT update" do
    let(:membership)   { Membership.make! }
    let(:patient_list) { membership.patient_list }
    let(:valid_params) do
      {:id => membership.to_param, :membership => {:risk_level => "high"}}
    end

    before do
      membership.save!
    end

    it "redirects to the patient list" do
      put :update, valid_params
      response.should redirect_to list_path(patient_list)
    end

    it "updates the membership" do
      put :update, valid_params
      membership.reload.risk_level.should == "high"
    end
  end

  describe "DELETE destroy" do
    let(:membership)   { Membership.make! }
    let(:patient_list) { membership.patient_list }

    it "destroys the membership" do
      request.env["HTTP_REFERER"] = root_path
      delete :destroy, id: membership.to_param
      Membership.count.should == 0
    end
  end
end
