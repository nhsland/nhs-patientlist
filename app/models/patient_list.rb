class PatientList < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent => :destroy
  has_many :patients, :through => :memberships
  has_many :to_do_items

  has_many :handover_items, :foreign_key => "patient_list_from_id"
  has_many :handed_over_items, through: :handover_items, source: :to_do_item, uniq: true

  validates :name, :presence => true,
            :uniqueness => {:scope => :user_id, :message => "must be unique"}

  attr_accessible :name, :user

  def currently_handed_over_items(patient)
    handed_over_items.for_patient(patient) - to_do_items
  end

  def all_items_with_state(state, patient)
    state_to_do_items = to_do_items.send(state).for_patient(patient)
    state_handed_over_items = handed_over_items.for_patient(patient).where("to_do_items.state = ?", state)

    (state_to_do_items + state_handed_over_items).uniq
  end
end
