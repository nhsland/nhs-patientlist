class PatientList < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent => :destroy
  has_many :patients, :through => :memberships
  has_many :to_do_items

  has_many :handover_items, :foreign_key => "patient_list_from_id"
  has_many :handed_over_items, through: :handover_items, source: :to_do_item

  validates :name, :presence => true,
            :uniqueness => {:scope => :user_id, :message => "must be unique"}

  attr_accessible :name, :user
end
