class MembershipsController < ApplicationController
  expose(:membership)
  # POST
  def create
    list = PatientList.find(params[:membership][:patient_list])
    begin
      patient = Patient.find(params[:patient_id])
      list.patients << patient
      flash[:notice] = "Added #{patient.name} to #{list.name}"
    rescue ActiveRecord::RecordInvalid => e
      respond_to do |format|
        p e
        format.html{ redirect_to :back, alert: "Could not add to list: #{e.message}" and return }
        format.json{ render json: e.message.to_json, status: :unprocessable_entity and return}
      end
    end
    respond_to do |format|
      format.html{ redirect_to :back }
      format.json{ render json: list.to_json }
    end
  end

  # PUT
  def update
    membership.save!
    patient_list = membership.patient_list
    redirect_to patient_list_path(patient_list)
  end

  # DELETE
  def destroy
    membership = Membership.find(params[:id])
    membership.destroy if membership
    redirect_to :back
  end

end
