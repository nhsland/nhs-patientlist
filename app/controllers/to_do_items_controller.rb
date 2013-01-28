class ToDoItemsController < ApplicationController

  def create
    to_do_item = ToDoItem.new(params[:to_do_item])
    if to_do_item.save
      redirect_to patient_list_path(to_do_item.patient_list)
    else
      message = "Could not create todo item: #{to_do_item.errors.full_messages.join(', ')}"
      redirect_to patient_lists_path, :alert => message
    end
  end

  def update
    if params[:to_do_item][:state].present?
      to_do_item = ToDoItem.find(params[:id])
      to_do_item.send("mark_as_#{params[:to_do_item][:state]}")
    end

    redirect_to patient_list_path(to_do_item.patient_list)
  end

  # def pending
  #   to_do_item = ToDoItem.find(params[:id])
  #   to_do_item.mark_as_pending
  #   redirect_to patient_list_path(to_do_item.patient_list)
  # end

  # def done
  #   to_do_item = ToDoItem.find(params[:id])
  #   to_do_item.mark_as_done
  #   redirect_to patient_list_path(to_do_item.patient_list)
  # end

end
