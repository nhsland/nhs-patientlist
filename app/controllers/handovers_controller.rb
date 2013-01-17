class HandoversController < ApplicationController
  expose(:patient_list) { PatientList.find params[:list_id] }

  def new
    @patients_with_to_do_items = patient_list.to_do_items.where("state IN (?)", ["todo", "pending"]).group_by(&:patient)
    @patient_lists = PatientList.where("id != ?", patient_list.id)
  end

  def create

    if params[:to_do_items].present?
      to_do_items = patient_list.to_do_items.where("id IN (?)", params[:to_do_items])

      if to_do_items.any?
        new_list = PatientList.find params[:to_list]
        to_do_items.each do |item|
          item.handover_to(new_list)
        end
      end
      redirect_to list_path(patient_list)
    else
      flash[:error] = "You must select at least one item to hand over"
      redirect_to new_list_handover_path(patient_list)
    end
  end

end
