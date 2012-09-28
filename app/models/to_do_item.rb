class ToDoItem < ActiveRecord::Base
  audited

  belongs_to :patient
  belongs_to :patient_list
  has_one    :handover

  attr_accessible :description, :patient_id, :status, :patient_list, :patient_list_id

  validates :status, inclusion: {in: %w{todo done} }
  validates_presence_of :description
  validates_presence_of :patient
  validates_presence_of :patient_list  

  def creator
    self.audits.where(action:'create').last.user_id
  end

  def handed_over?
    Handover.where("to_do_item_id = ?", self.id).any?
  end

  def self.handed_over
    joins("inner join handovers on handovers.to_do_item_id = to_do_items.id")
  end

  def self.find_by_patient_and_list(patient, patient_list)
    where(:patient_list_id => patient_list.id,
          :patient_id => patient.id)
  end

  def self.patient_tasks_todo(patient, patient_list)
    find_by_patient_and_list(patient, patient_list).
      where(:status => "todo").
      where("to_do_items.id not in (?)", handed_over.map(&:id).join(","))
  end

  def self.patient_tasks_pending(patient, patient_list)
    find_by_patient_and_list(patient, patient_list).
      where(:status => "todo").
      handed_over 
  end

  def self.patient_tasks_done(patient, patient_list)
    find_by_patient_and_list(patient, patient_list).
      where(:status => "done")
  end
end


