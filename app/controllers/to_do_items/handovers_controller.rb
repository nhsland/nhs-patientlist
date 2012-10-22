class ToDoItems::HandoversController < ApplicationController
  expose(:to_do_item) { ToDoItem.find(params[:to_do_item_id]) }
  expose(:patient)    { to_do_item.patient }
  expose(:handover)
  expose(:handover_list) do
    team_id = params[:handover_list][:team_id]
    shift_date = Date.strptime(params[:handover_list][:shift_date], "%Y-%m-%d")
    HandoverList.find_or_create_by_shift_date_and_team_id(shift_date, team_id)
  end

  def new
    handover.handover_list = HandoverList.new
  end

  def create
    handover.handover_list = handover_list
    if handover.save
      redirect_path = root_path

      if session.has_key?(:current_list)
        patient_list = PatientList.find_all_by_id(session[:current_list]).first 
        redirect_path = list_path(patient_list) unless patient_list.nil?
      end
        
      redirect_to redirect_path, :notice => "Task handed over"
    else
      flash[:alert] = "Could not hand task over"
      render :new
    end
  end
end
