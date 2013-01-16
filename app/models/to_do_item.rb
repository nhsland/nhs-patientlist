class ToDoItem < ActiveRecord::Base
  audited

  # associations
  belongs_to :patient
  belongs_to :patient_list

  # whitelisted attributes
  attr_accessible :description, :patient_id, :patient_list, :patient_list_id

  # validations
  validates_presence_of :description, :patient, :patient_list

  # scopes
  scope :for_list, -> patient_list { where(patient_list_id: patient_list.id) }
  scope :todo,    -> { where(state: 'todo') }
  scope :pending, -> { where(state: 'pending') }
  scope :done,    -> { where(state: 'done') }

  # state machine
  state_machine initial: :todo do
    state :todo
    state :pending
    state :done

    event :mark_as_pending do
      transition :todo => :pending
    end

    event :mark_as_done do
      transition [:todo, :pending] => :done
    end
  end

  # instance methods
  def creator
    self.audits.where(action:'create').last.user_id
  end

end
