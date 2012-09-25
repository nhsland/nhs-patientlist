class ToDoItem < ActiveRecord::Base
  audited

  belongs_to :patient
  belongs_to :patient_list

  attr_accessible :description, :patient_id, :status, :patient_list, :patient_list_id

  validates :status, inclusion: {in: %w{todo pending done} }
  validates_presence_of :description

  def creator
    self.audits.where(action:'create').last.user_id
  end

  def handed_over?
    Handover.where("to_do_item_id = ?", self.id).any?
  end
end


