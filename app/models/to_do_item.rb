class ToDoItem < ActiveRecord::Base
  audited

  belongs_to :patient
  belongs_to :patient_list
  has_one    :handover

  attr_accessible :description, :patient_id, :patient_list, :patient_list_id

  validates_presence_of :description, :patient, :patient_list

  state_machine initial: :todo do
    state :todo
    state :pending
    state :done

    event :mark_as_pending do
      transition :todo => :pending
    end

    event :mark_as_done do
      transition :pending => :done
    end
  end

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

end
