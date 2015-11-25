class Membership < ActiveRecord::Base
  audited associated_with: :patient

  belongs_to :patient_list
  belongs_to :patient

  attr_accessible :risk_level

  validates :patient_id, :patient_list_id, :presence => true
  validates :patient_id,
    :uniqueness => {
      :scope => :patient_list_id, :message => "is already on this list"
    }

  def owner
    self.patient_list.user
  end
end

