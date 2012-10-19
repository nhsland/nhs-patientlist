require 'spec_helper'

describe ToDoItems::HandoversController do
  class ToDoItems::HandoversController < ApplicationController
    skip_before_filter :authenticate_user!
  end

  let(:patient)      { Patient.make! }
  let(:patient_list) { PatientList.make! }
  let(:grade)        { Grade.make! }
  let(:team)         { Team.make!  }
  let(:to_do_item)   { ToDoItem.make! :patient => patient }

  describe "GET new" do
    before do
      get :new, :to_do_item_id => to_do_item.to_param
    end

    it "renders the new handover page" do
      response.should render_template("new")
    end
  end

  describe "post create" do
    let(:valid_attributes) do
      {
        :to_do_item_id => to_do_item.to_param,
        :handover   => {
          :to_do_item_id => to_do_item.to_param,
          :grade_id      => grade.to_param
        },
        :handover_list => {
          :team_id       => team.id,
          :shift_date    => "2012-08-15"
        }
      }
    end

    context "when there is a handover list for the team and date specified" do
      let!(:handover_list)     { HandoverList.create! valid_attributes[:handover_list] }
      let!(:existing_handover) { handover_list.handovers << Handover.make! }

      it "adds a new handover to the existing handover list" do
        post :create, valid_attributes
        handover_list.reload.handovers.count.should == 2
      end
    end

    context "when there is no handover list for the date specified" do
      it "creates a new handover" do
        expect {
          post :create, valid_attributes
        }.to change(Handover, :count).by(1)
      end

      it "creates a new handover list" do
        expect {
          post :create, valid_attributes
        }.to change(HandoverList, :count).by(1)
      end

      it "assigns the handover list to the handover" do
        post :create, valid_attributes
        Handover.last.handover_list.should == HandoverList.last
      end

      it "assigns to_do_item to handover" do
        post :create, valid_attributes
        Handover.last.to_do_item.should == to_do_item
      end

      it "assigns a grade to the handover" do
        post :create, valid_attributes
        Handover.last.grade.should == grade
      end

      context "redirections" do
        let(:patient_list) { PatientList.make! }
        
        it "redirects to the current_list when session includes the current list id" do
          session[:current_list] = patient_list.to_param 
          post :create, valid_attributes
          response.should redirect_to(list_path(patient_list))
        end

        it "redirects to root if the session does not include the current list id" do
          post :create, valid_attributes
          response.should redirect_to(root_path)         
        end

        it "redirects to root if the current list ID is invalid" do
          session[:current_list] = -9999
          post :create, valid_attributes
          response.should redirect_to(root_path)
        end
      end

      it "displays a status notice" do
        post :create, valid_attributes
        flash[:notice].should == "Task handed over"
      end
    end

    context "on error" do
      before do
        Handover.any_instance.stub(:save => false)
        post :create, valid_attributes
      end

      it "renders new" do
        response.should render_template(:new)
      end

      it "displays an error" do
        flash[:alert].should == "Could not hand task over"
      end
    end
  end
end
