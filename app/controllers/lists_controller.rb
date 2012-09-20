class ListsController < ApplicationController
  expose(:patient_list) { PatientList.find params[:id] }

  # GET
  def index
    
  end

  def show
    
  end
end
