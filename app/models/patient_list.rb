class PatientList < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent => :destroy
  has_many :patients, :through => :memberships
  has_many :to_do_items

  validates :name, :presence => true,
            :uniqueness => {:scope => :user_id, :message => "must be unique"}

  attr_accessible :name, :user
end
