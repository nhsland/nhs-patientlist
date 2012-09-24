class MembershipsController < ApplicationController

  def create
    list = current_user.patient_lists.find(params[:membership][:patient_list])
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

  def destroy
    membership = Membership.find_by_patient_list_id_and_patient_id params[:patient_list_id], params[:patient_id]
    if membership.owner == current_user
      membership.destroy
      redirect_to :back
    else
      render :status => :unauthorized
    end
  end

end
