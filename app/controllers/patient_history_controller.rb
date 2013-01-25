class PatientHistoryController < ApplicationController
  expose(:patient) { Patient.where(pat_id: params[:id]).first }

  def show
    if patient.present?
      @audits = patient.associated_audits.each.map { |audit| AuditPresenter.new(audit) }
    else
      redirect_to root_path if patient.nil?
    end
  end

end
