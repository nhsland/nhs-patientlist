class ToDoItemsController < ApplicationController

  def create
    to_do_item = ToDoItem.new(params[:to_do_item])
    if to_do_item.save
      redirect_to list_path(to_do_item.patient_list)
    else
      message = "Could not create todo item: #{to_do_item.errors.full_messages.join(', ')}"
      redirect_to lists_path, :alert => message
    end
  end

end
