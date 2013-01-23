class PatientHistoryController < ApplicationController
  expose(:patient) { Patient.where(pat_id: params[:id]).first }

  def show
    redirect_to root_path if patient.nil?
  end

end
