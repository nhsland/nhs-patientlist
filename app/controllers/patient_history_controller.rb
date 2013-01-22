class PatientHistoryController < ApplicationController

  def show
    @patient = Patient.where(pat_id: params[:id]).first
    redirect_to root_path if @patient.nil?
  end

end
