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
    to_do_item = ToDoItem.find(params[:id])

    if params[:to_do_item][:state].present? && %w(todo pending done).include?(params[:to_do_item][:state])
      to_do_item.send("mark_as_#{params[:to_do_item][:state]}")
    end

    redirect_to patient_list_path(to_do_item.patient_list)
  end

end
