class User < ActiveRecord::Base
  has_many :patient_lists
  belongs_to :grade

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :grade, :grade_id
end
