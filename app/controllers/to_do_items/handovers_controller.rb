class ToDoItems::HandoversController < ApplicationController
  expose(:to_do_item) { ToDoItem.find(params[:to_do_item_id]) }
  expose(:patient)    { to_do_item.patient }
  expose(:handover)
  expose(:grade)  
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
      redirect_to root_path, :notice => "Task handed over"
    else
      flash[:alert] = "Could not hand task over"
      render :new
    end
  end
end
