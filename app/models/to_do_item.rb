class ToDoItem < ActiveRecord::Base
  audited associated_with: :patient

  # associations
  belongs_to :patient
  belongs_to :patient_list
  belongs_to :grade

  # whitelisted attributes
  attr_accessible :description, :patient_id, :patient_list, :patient_list_id, :grade, :grade_id

  # validations
  validates_presence_of :description, :patient, :patient_list

  # scopes
  default_scope where("state != ?", 'deleted')
  scope :for_list, -> patient_list { where(patient_list_id: patient_list.id) }
  scope :todo,    -> { where(state: 'todo') }
  scope :pending, -> { where(state: 'pending') }
  scope :done,    -> { where(state: 'done') }
  scope :for_patient, -> patient { where(patient_id: patient.id) }

  def mark_as_todo
    self.state = "todo"
    save
  end

  def mark_as_pending
    self.state = "pending"
    save
  end

  def mark_as_done
    self.state = "done"
    save
  end

  def mark_as_deleted
    self.state = "deleted"
    save
  end

  # instance methods
  def creator
    self.audits.where(action:'create').last.user_id
  end

  def handover_to(list)
    Membership.find_or_create_by_patient_id_and_patient_list_id(patient_id, list.id)
    patient_list.handover_items.create(to_do_item: self, patient_list_to: list)
    update_attributes(patient_list: list)
  end

end
